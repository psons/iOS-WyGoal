//
//  EffortDomainAppState.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation

/**
 State Rules:
 1 - an EffortDomain always has a default Goal
 2 - the default Goal in an EffortDomain always has a default Objective.
 3 - Goals other than the default Goal in an Effort Domain may be empty, having no Objectives
 4 - Objectives may be empty, having no Tasks.
 
 in the future, the default goal and Objective may change so that a user can put new Objectives and Tasks in with Siri, and set where they go.
 */
class EffortDomainAppState: Codable, CustomStringConvertible {
    var effortDomain = EffortDomain(name:"un specified name")
    var appState = AppState()
    
//    /**
//     Initialize the with the EffortDomain, and use the default appState of 0, 0
//     */
//    init(effortDomain: inout EffortDomain) {
//
//        // appState handled by initializer
//        self.effortDomain = effortDomain
//
//        // make sure there is a current goal or default Goal
//        if !self.effortDomain.goals.indices.contains(self.appState.currentGSlot){
//            print("Error in EffortDomainAppState.init().   EffortDomain is supposed to always have a default goal")
//        }
//        // now can use self.currentGoal
//
//        if !self.currentGoal.objectives.indices.contains(Goal.defaultOslot) {
//            self.currentGoal.objectives[Goal.defaultOslot] = Objective(name: "default objective")
//        }
//
//    }

    init(effortDomain: EffortDomain, appState: AppState) {
        self.effortDomain = effortDomain
        self.appState = appState
        
        // make sure appState points at a Goal
        if !self.effortDomain.goals.indices.contains(self.appState.currentGSlot){
            print("Error in EffortDomainAppState.init(). AppState currentGSlot does not agree with EffortDomain. ")
            print("\t Forcing AppState to appState.currentGSlot EffortDomain.defaultGSlot")
            self.appState.currentGSlot = EffortDomain.defaultGSlot
        }
        // now can use self.currentGoal

        /**
         todo Need some test scenarios for this when user can manipulate appState current Goal and Objective with Siri
         `and when task adding is supported.`
         */
        if !self.currentGoal.objectives.indices.contains(appState.currentOSlot) {
            print("Error in EffortDomainAppState.init(). AppState currentOSlot does not agree with EffortDomain. ")
            print("\t Appending to currentGoal.objectives")
            self.currentGoal.objectives.append(Objective(name: "default objective"))
            self.appState.currentOSlot = self.currentGoal.objectives.count
        }
    }
    
    var description: String {
        var headline = "{EffortDomainAppState} |currentGoal-name: \(self.currentGoal.name)|"
        headline += "currentObjective-name: \(self.currentObjective.name)|"
        let bodyLines = "\n\(self.appState.description)\n\(self.effortDomain.description)"
        return headline + bodyLines
    }

    var currentGoal: Goal {
        get {return effortDomain.goals[appState.currentGSlot]}
    }

    var currentObjective: Objective {
        get {return effortDomain.goals[appState.currentGSlot].objectives[appState.currentOSlot]}
    }
    
    /**
     not supporting maxTasks here because a case where maxTasks is provided, probably won't use the defaut current location
     */
    func addObjective(name: String) {
        self.currentGoal.addObjective(objective: Objective(name: name))
    }
}
