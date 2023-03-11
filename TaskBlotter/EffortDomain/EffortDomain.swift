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

    /**
     Consider eliminating support for stored AppState, expecting the caller to pass it in when needed.
     Doing so will allow this to be an extension and separate the AppState type from the EffortDomain.
     */
    var appState: AppState?
    
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
    
    func addGoal(goal: Goal){
        self.goals.append(goal)
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
    private func doObjectiveAdd(objective: Objective, gSlot: Int) -> AppState {
        var gSl = validGSlot(gSlot: gSlot)
        self.goals[gSl].objectives.append(objective)
        var aSt = AppState()
        aSt.currentGSlot = gSl
        aSt.currentOSlot = self.goals[aSt.currentGSlot].objectives.count - 1
        self.appState = aSt
        return aSt
    }
    
    /**
     Add an Objective even if the requested location is out of bounds
     if the AppState.currentGSlot is out of bounds, use a default

     Retun the appState coordinates of the new objective, to the user
     Also set the AppState as current for the domain.
     */
    func addObjective(objective: Objective, appState: AppState? ) -> AppState {
        if var aSt = appState {
            /** working based on goal Slot from arg. gSlarg  */
            return self.doObjectiveAdd(objective: objective, gSlot: aSt.currentGSlot)
        } else {
            if var gSlotSelf = self.appState?.currentGSlot {
                /** working based on goal slot state in the object  gSlself*/
                return self.doObjectiveAdd(objective: objective, gSlot: gSlotSelf)
            } else {
                return self.doObjectiveAdd(objective: objective, gSlot: EffortDomain.defaultGSlot)
            }
        }
    }

    /**
     Add a task considering that either of the Goal or Objective could be out of bounds.
     */
//    func addTask(task: Task, appState: AppState? ) {
//    }
    
    
    /**
        Given an AppState
     */
    func validateAppState(appState: AppState) -> AppState {
        self.appState = appState
        var currentGoal: Goal?
        // make sure appState points at a Goal
        if !self.goals.indices.contains(self.appState!.currentGSlot){
            self.appState!.currentGSlot = EffortDomain.defaultGSlot  // was no good.  forced to default
        }
        // now can use currentGoal
        currentGoal = self.goals[self.appState!.currentGSlot]
        
        /**
         todo Need some test scenarios for this when user can manipulate appState current Goal and Objective with Siri
         `and when task adding is supported.`
         */
        if !currentGoal!.objectives.indices.contains(appState.currentOSlot) {
            print("Error in EffortDomainAppState.init(). AppState currentOSlot does not agree with EffortDomain. ")
            print("\t Appending to currentGoal.objectives")
            currentGoal!.objectives.append(Objective(name: "default objective"))
            self.appState!.currentOSlot = currentGoal!.objectives.count
        }

        return self.appState!
    }
    
}

class AppState: Codable, CustomStringConvertible {
    var currentGSlot = EffortDomain.defaultGSlot  // index of an goal that will be used if none provided when creatig an Objective
    var currentOSlot = Goal.defaultOslot  // index of Objective that will be used if none provided when creatig a task.
    //var currentTslot = 0
    var description: String {
        return "Appstate slots (G,O) (\(currentGSlot),\(currentOSlot))"
    }
}
