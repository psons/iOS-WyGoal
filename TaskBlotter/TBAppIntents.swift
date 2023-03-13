//
//  TBAppIntents.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/2/23.
//

import Foundation
import AppIntents
import UIKit  // needed to access UIApplication

func getTBRootController() -> TBUITabBarController {
    return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController as! TBUITabBarController
}

struct StartTaskBlotterIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Task Blotter"
    static var description = IntentDescription("Launches the Task Blotter App.")
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("StartTaskBlotterIntent.perform()")
        let tbc = getTBRootController()
        tbc.selectedIndex = 1
        return .result()  //.finished
    }
}

struct TaskBlotterTestDataSetup: AppIntent {
    static var title: LocalizedStringResource = "Set up Task Blotter Test Data"
    static var description = IntentDescription("Sets up saved test data for the next Task Blotter run")
    static var openAppWhenRun = false  // <---- Won't launch app, or load ViewControllers.
    
    func perform() async throws -> some IntentResult {
        print("TaskBlotterTestDataSetup.perform()")
        let domainStore = DomainStore()
        domainStore.saveData(domainRef: testEffortDomain)
        return .result()  //.finished
    }
}

/**
 This intent demnstrates that the data store can be cleared by calling into the bundle from a shortcut without
 loading the viewcontrollers.
 It saves an empty default Effort Domain via the DomainStore class.
 */
struct TaskBlotterClearData: AppIntent {
    static var title: LocalizedStringResource = "Clear Task Blotter Data"
    static var description = IntentDescription("Clears the saved data for the next Task Blotter run.")
    static var openAppWhenRun = false  // <---- Won't launch app, or load ViewControllers.
    
    func perform() async throws -> some IntentResult {
        print("TaskBlotterClearData.perform()")
        DomainStore.save(domain: DomainStore().domain ) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
        return .result()  //.finished
    }
}

/**
 This saves data without calling the app, so if the app is running, it will not see the update.
 an improvement is needed: running a service, or just actually calling the app, like the nav does.
 */

struct AddObjectiveIntent: AppIntent {
    static var title: LocalizedStringResource = "Add an objective in the Task Blotter App"
    
    static var description = IntentDescription("Adds an objective underneath the current goal in the Task Blotter App")
    
    @Parameter(title: "Name of the Objective")
    var name: String    // not non-optional will have Siri assure that it is provided.
    
    func perform() async throws -> some IntentResult {
        print("AddObjectiveIntent.perform() has parameter 'name' from the user \(name)")
        
        DomainStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let domainData):
                print("Loaded Domain Data \(domainData.name)")
                let newObjectiveLocation = domainData.addObjective(objective: Objective(name: name), gSlot: 0)
                print("{Saving to: \(newObjectiveLocation)} name: \(name)")
                DomainStore.save(domain: domainData) { result in
                    if case .failure(let error) = result {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
        
        StateStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let stateData):
                print("loaded state: \(stateData.description)")
            }
        }

        
        
        
        //todo similar to above, but pass data to the tab bar.
        return .result(value: "Added the Objective" )
    }
    
}

/**
go to the goal via nav controller so i have context
and prove I can go past the tab bar inexes
 */
struct ViewDefaultGoalIntent: AppIntent {
    static var title: LocalizedStringResource = "View the Saved Goal"
    static var description = IntentDescription("Views the User Saved Goal where new Objectives and Tasks will be created in the Task Blotter App")
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("ViewDefaultGoalIntent invoked")
        let tbc = getTBRootController()
        tbc.setNavigation(navTarget: "GoalListing")
        tbc.doNavigation()
        return .result(value: "Launched to the default Goal" )
    }
    
}

/**
go to the goal + Objective via nav controller so that back goes to the parent goal.
 */
struct ViewSavedObjectiveIntent: AppIntent {
    static var title: LocalizedStringResource = "View the Saved Objective "
    static var description = IntentDescription("Views the User Saved Objective where Tasks will be created in the Task Blotter App")
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("ViewSavedObjectiveIntent invoked")
        let tbc = getTBRootController()
        tbc.setNavigation(navTarget: "ObjectiveTasks")
        tbc.doNavigation()
        return .result(value: "Launched to the Saved Objective" )
    }
    
}



// builds Intents into a shortcuts.
struct TaskBlotterShortcuts: AppShortcutsProvider {
    // phrases .applicationName or Siri roams out to an internet search.
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddObjectiveIntent(), phrases: [
                "Create an Objective in \(.applicationName)",
                "Add Objective to \(.applicationName)",
                "Add Story to  \(.applicationName)",
                "Add Grouping of tasks to \(.applicationName)"])

        AppShortcut(
            intent: ViewSavedObjectiveIntent(), phrases: [
                "View Saved Objective in \(.applicationName)",
                "View an Objective  \(.applicationName)",
                "View my Objective \(.applicationName)",
                "Get the Objective \(.applicationName)"])
        
        AppShortcut(
            intent: ViewDefaultGoalIntent(), phrases: [
                "View Default Goal in \(.applicationName)",
                "View a Goal  \(.applicationName)",
                "View my Goal \(.applicationName)"])
        
        AppShortcut(
            intent: TaskBlotterTestDataSetup(), phrases: [
                "Load and Persist Task Blotter Data \(.applicationName)"])

        AppShortcut(
            intent: TaskBlotterClearData(), phrases: [
                "Clear Persisted Task Blotter Data \(.applicationName)"])

        AppShortcut(
            intent: StartTaskBlotterIntent(), phrases: [
                "Start \(.applicationName)",
                "Launch \(.applicationName)",
                "Launch My Goal App \(.applicationName)"])
        

    }
}


