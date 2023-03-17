//
//  EffortDomain.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation

/**
 An effort domain refers to the context that a person will use to prioritize time and efort use,
 plus the goals within that context.
 A persons goals and priorities, for example are different during work hours than they are outside of work.
 */
class EffortDomain: Codable, CustomStringConvertible {
    static let defaultGSlot = 0
    var name = ""
    var todoMaxTasks = defaultMaxTasks
    var goals: [Goal] = []
    var description: String {
        let heading = "{EffortDomain} |name:\(name)|todoMaxTasks: \(todoMaxTasks)|\n"
        var goalsAsStr = ""
        for goal in goals {
            goalsAsStr += "\t\(goal)\n"
        }
        return heading + goalsAsStr
    }

    
    private enum CodingKeys: String, CodingKey {
        case name, todoMaxTasks, goals
    }
    
    
    init(name: String, todoMaxTasks: Int = defaultMaxTasks) {
        //        print("EfortDomain.init goals.count: \(self.goals.count)")
        self.goals.append(Goal(name: "default goal", createDefaultObjective: true))
        self.name = name
        self.todoMaxTasks = todoMaxTasks
        //        self.addGoal(goal: Goal(name: "default goal", createDefaultObjective: true))
        //        print("EfortDomain.init goals: \(goals)")
    }
    
    func addGoal(goal: Goal) -> Int {
        self.goals.append(goal)
        return self.goals.count - 1  // gSlot of the goal we just added
    }
    

    func isValidGslot(gSlot: Int) -> Bool {
        return self.goals.indices.contains(gSlot)
    }
    
    /**
    Returns the user provided goal slot, suitable for adding objectives if it is a valid goal index.
    If it is not a valid goal index, the default goal slot is returned.
     */
    func validGSlot(gSlot: Int) -> Int {
        if isValidGslot(gSlot: gSlot){
            return gSlot
        } else {
            return EffortDomain.defaultGSlot  // was no good.  forced to default
        }
    }

    /**
     Add objective at the specfied Goal Slot or a default
     */
    func addObjective(objective: Objective, gSlot: Int) -> AppState {
        let gSl = validGSlot(gSlot: gSlot)
        self.goals[gSl].objectives.append(objective)
        let appState = AppState.factory(gSl, self.goals[gSl].objectives.count - 1)
        return appState
    }

    func isValidOslot(givenGslot: Int, oSlot: Int) -> Bool {
        if isValidGslot(gSlot: givenGslot) {
            return self.goals[givenGslot].objectives.indices.contains(oSlot)
        } else {
            return false
        }
    }

    /**
    Returns the user provided go slot, suitable for adding tasks if it is the g ad o indecies are valid.
    If the g an o index is not valid, the default goal slot, objective slot  is returned.
     */
    func validGOSlot(givenGslot: Int, oSlot: Int) -> AppState {
        let newAppState = AppState()
        newAppState.gSlot = givenGslot
        newAppState.oSlot = oSlot

        if isValidOslot(givenGslot: givenGslot, oSlot: oSlot){
            return newAppState
        } else {
            newAppState.gSlot = EffortDomain.defaultGSlot
            newAppState.oSlot = Goal.defaultOslot
            return   newAppState // was no good.  forced to default
        }
        
    }

    
    /** This should be more sophisticated when  the domain store is somthing that can mutate while the user is working with objectives.
     The task could be added in a default place if the objective becomes unavailable*/
    func addTask(task: Task, gSlot: Int, oSlot: Int) -> AppState {
        let appState = validGOSlot(givenGslot: gSlot, oSlot: oSlot)
        self.goals[appState.gSlot].objectives[appState.oSlot].tasks.append(task)
        return appState
    }
    
    /**
     Retuns the Goal being removed, if the gSlot Index is valid in the goals list.  ( Maybe the caller will undo, or put it in a different slot, or just tell the user.)
     Returns nil if the gSlot is out of range in the goals list.
     */
    func removeGoal(gSlot: Int) -> Goal? {
        if self.goals.indices.contains(gSlot) {
            let goalAtOSlot = self.goals[gSlot]
            self.goals.remove(at: gSlot)
            return goalAtOSlot
        }
        return nil
    }
    
    func requestNewValidGOState(desiredState: AppState, previousAppState: AppState) -> AppState {
        let resultingAppState = AppState()
        if !isValidGslot(gSlot: desiredState.oSlot) {
            /** Requested goal is not valid so return defaults*/
            return resultingAppState
        } else {
            resultingAppState.gSlot = desiredState.gSlot
            resultingAppState.oSlot = requestValidOslot(
                goal: self.goals[resultingAppState.gSlot],
                desiredOslot: previousAppState.oSlot)
            return resultingAppState
        }
    }
    
    /**
     logic requires knowledge of prior appState and the state of goals in the AppDomain
     Return an appstate that has a valid goal, as requested if possible, and also if possible  a valid objective
     Try to preserve existing oSlot if goal is not changing.
     */
    func requestNewCurrentGState(desiredGSlot: Int, previousAppState: AppState) -> AppState {
        let resultingAppState = AppState()
        if desiredGSlot == previousAppState.gSlot {
            if isValidGslot(gSlot: desiredGSlot){
                /** Valid gSlot. can try to preserve previous oSlot*/
                resultingAppState.gSlot = desiredGSlot
                resultingAppState.oSlot = requestValidOslot(
                    goal: self.goals[resultingAppState.gSlot],
                    desiredOslot: previousAppState.oSlot)
                return resultingAppState
            } else {
                /** Requested goal is not valid so return defaults*/
                return resultingAppState
            }
        } else {
            if isValidGslot(gSlot: desiredGSlot) {   // would be sightly simpler if this were the outer test
                /** Valid gSlot. No previous*/
                resultingAppState.gSlot = desiredGSlot
                resultingAppState.oSlot = requestValidOslot(
                    goal: self.goals[resultingAppState.gSlot],
                    desiredOslot: Goal.defaultOslot)
                return resultingAppState
            } else {
                /** Requested goal is not valid so return defaults*/
                return resultingAppState
            }
        }
    }

    /**
     Returns desiredOslot if it is valid.
     Returns Goal.defaultOslot if that is valid.
     Returns Goal.invalidOslot if there is no valid oSlot in goal.   Caller must create an objective in the Goal
     */
    func requestValidOslot(goal: Goal, desiredOslot: Int) -> Int {
        if goal.objectives.indices.contains(desiredOslot){
            return desiredOslot
        } else {
            if goal.objectives.indices.contains(Goal.defaultOslot) {
                return Goal.defaultOslot
            } else {
                return Goal.invalidOslot
            }
        }
    }
    
}

