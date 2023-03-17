//
//  TBAppIntents.swift
//  WyGoal
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
    static var title: LocalizedStringResource = "Start WyGoal"
    static var description = IntentDescription("Launches the WyGoal App.")
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
    static var title: LocalizedStringResource = "Set up WyGoal Test Data"
    static var description = IntentDescription("Sets up saved test data for the next WyGoal run")
    static var openAppWhenRun = false  // <---- Won't launch app, or load ViewControllers.
    
    func perform() async throws -> some IntentResult {
        print("TaskBlotterTestDataSetup.perform()")
        let domainStore = DomainStore(domain: testEffortDomain)
        domainStore.saveData()
        return .result()  //.finished
    }
}

///**
// This intent demnstrates that the data store can be cleared by calling into the bundle from a shortcut without
// loading the viewcontrollers.
// It saves an empty default Effort Domain via the DomainStore class.
// */
//struct TaskBlotterClearData: AppIntent {
//    static var title: LocalizedStringResource = "Clear WyGoal Data"
//    static var description = IntentDescription("Clears the saved data for the next WyGoal run.")
//    static var openAppWhenRun = false  // <---- Won't launch app, or load ViewControllers.
//
//    func perform() async throws -> some IntentResult {
//        print("TaskBlotterClearData.perform()")
//        DomainStore.save(domain: DomainStore().domain ) { result in
//            if case .failure(let error) = result {
//                fatalError(error.localizedDescription)
//            }
//        }
//        return .result()  //.finished
//    }
//}

struct WyGoalAddIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Wygoal"
    static var description = IntentDescription("Adds a WyGoal to work on")
    static var openAppWhenRun = true

    @Parameter(title: "Name of the WyGoal")
    var name: String    // not non-optional will have Siri assure that it is provided.
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("WyGoalAdd.perform() \(name)")
        
        let tbc = getTBRootController()
        tbc.setNavigation(navTarget: "WyGoal", name: name)
        tbc.doNavigation()
        return .result(value: "Launched WyGoal screen with new WyGoal" )
    }
}

struct WyGoalObjectiveAddIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Objective to the Wygoal app"
    static var description = IntentDescription("Adds a WyGoal Objective to work on")
    static var openAppWhenRun = true

    @Parameter(title: "Name of the Objective")
    var name: String    // non-optional will have Siri assure that it is provided.
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("WyGoalObjectiveAddIntent.perform() \(name)")
        
        let tbc = getTBRootController()
        tbc.setNavigation(navTarget: "AddObjective", name: name)
        tbc.doNavigation()
        return .result(value: "Launched WyGoal screen with new WyGoal" )
    }
}


struct WyGoalTaskAddIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Wygoal Task"
    static var description = IntentDescription("Adds a WyGoal task to complete")
    static var openAppWhenRun = false  // <---- Won't launch app, or load ViewControllers.

    @Parameter(title: "Name of the Task")
    var name: String    // not non-optional will have Siri assure that it is provided.

    
    func perform() async throws -> some IntentResult {
        print("WyGoalObjectiveAddIntent.perform() \(name)")
        
        return .result()  //.finished
    }
}


/**
 This saves data without calling the app, so if the app is running, it will not see the update.
 an improvement is needed: running a service, or just actually calling the app, like the nav does.
 */
//struct AddObjectiveIntent: AppIntent {
//    static var title: LocalizedStringResource = "Add an objective in the WyGoal App"
//
//    static var description = IntentDescription("Adds an objective underneath the current goal in the WyGoal App")
//
//    @Parameter(title: "Name of the Objective")
//    var name: String    // not non-optional will have Siri assure that it is provided.
//
//    func perform() async throws -> some IntentResult {
//        print("AddObjectiveIntent.perform() has parameter 'name' from the user \(name)")
//
//        DomainStore.load { result in
//            switch result {
//            case .failure(let error):
//                fatalError(error.localizedDescription)
//            case .success(let domainData):
//                print("Loaded Domain Data \(domainData.name)")
//                let newObjectiveLocation = domainData.addObjective(objective: Objective(name: name), gSlot: 0)
//                print("{Saving to: \(newObjectiveLocation)} name: \(name)")
//                DomainStore.save(domain: domainData) { result in
//                    if case .failure(let error) = result {
//                        fatalError(error.localizedDescription)
//                    }
//                }
//            }
//        }
//        StateStore.load { result in
//            switch result {
//            case .failure(let error):
//                fatalError(error.localizedDescription)
//            case .success(let stateData):
//                print("loaded state: \(stateData.description)")
//            }
//        }
//        //todo similar to above, but pass data to the tab bar.
//        return .result(value: "Added the Objective" )
//    }
//
//}

/**
go to the goal via nav controller so i have context
and prove I can go past the tab bar inexes
 Todo:  fix: This doesn't load the saved goal.  Just goes t the goal lisiting screen.
 */
struct ViewGoalListingIntent: AppIntent {
    static var title: LocalizedStringResource = "View the Saved Goal"
    static var description = IntentDescription("Views the User Saved Goal where new Objectives and Tasks will be created in the WyGoal App")
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
    static var description = IntentDescription("Views the User Saved Objective where Tasks will be created in the WyGoal App")
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
            intent: WyGoalAddIntent(), phrases: [
                "Add \(.applicationName)",
                "Add a \(.applicationName)",
                "Add my \(.applicationName)",
                "Creat a \(.applicationName)",
                "Creat my \(.applicationName)",
                "Please create my \(.applicationName)",
                "Please create a new \(.applicationName)",
                "Add a new \(.applicationName)"])

        // WyGoalObjectiveAddIntent
        AppShortcut(
            intent: WyGoalObjectiveAddIntent(), phrases: [
                "\(.applicationName) Objective",
                "Add Objective to \(.applicationName)",
                "Add an Objective to \(.applicationName)",
                "Add my Objective to \(.applicationName)",
                "Creat an Objective in \(.applicationName)",
                "Creat my Objective in \(.applicationName)",
                "Please create my Objective in \(.applicationName)",
                "Please create a new Objective in \(.applicationName)",
                "Add a new Objective \(.applicationName)",
                "Add a new \(.applicationName) Objective",
                "Add a new Objective \(.applicationName)"])

        // WyGoalTaskAddIntent
        AppShortcut(
            intent: WyGoalTaskAddIntent(), phrases: [
                "\(.applicationName) Task",
                "Add \(.applicationName) Task",
                "Add a \(.applicationName) Task",
                "Add my \(.applicationName) Task",
                "Creat a \(.applicationName) Task",
                "Creat my \(.applicationName) Task",
                "Please create my \(.applicationName) Task",
                "Please create a new \(.applicationName) Task",
                "Add a new \(.applicationName) Task"])


//        AppShortcut(
//            intent: AddObjectiveIntent(), phrases: [
//                "Create an Objective in \(.applicationName)",
//                "Add Objective to \(.applicationName)",
//                "Add Story to  \(.applicationName)",
//                "Add Grouping of tasks to \(.applicationName)"])

        AppShortcut(
            intent: ViewSavedObjectiveIntent(), phrases: [
                "View Saved Objective in \(.applicationName)",
                "View an Objective  \(.applicationName)",
                "View my Objective \(.applicationName)",
                "Get the Objective \(.applicationName)"])
        
        AppShortcut(
            intent: ViewGoalListingIntent(), phrases: [
                "View \(.applicationName) Listing",
                "View \(.applicationName)s",
                "View my \(.applicationName)s"])
        
        AppShortcut(
            intent: TaskBlotterTestDataSetup(), phrases: [
                "Load \(.applicationName) Test Data"])

//        AppShortcut(
//            intent: TaskBlotterClearData(), phrases: [
//                "Clear Persisted WyGoal Data \(.applicationName)"])

        AppShortcut(
            intent: StartTaskBlotterIntent(), phrases: [
                "Start \(.applicationName)",
                "Launch \(.applicationName)",
                "Launch My Goal App \(.applicationName)"])
        

    }
}


