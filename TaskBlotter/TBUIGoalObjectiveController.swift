//
//  TBUIGoalController.swift
//  Task Blotter Base
//
//  Created by Paul Sons on 2/22/23.
//

import UIKit
import Intents
import CoreSpotlight

//import Foundation
import CoreServices
//import OrderKit

import UniformTypeIdentifiers

public let newActivityTypeADDObjective = "net.psons.Task-Blotter-Base.add-objective"

// likely replace this with somthing like TBUIGOController
class TBUIGoalObjectiveController: UIViewController {
    
    var localGoal = Goal(name: "UNKNOWN")
    
    @IBOutlet weak var newObjectiveNameTV: UITextField!
    @IBOutlet weak var newObjectiveMaxTasksTV: UITextField!
    @IBOutlet weak var storyListingTV: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // This will be common to my TabBarController children, so maybe a base class?
    func useParentTBC() -> TBUITabBarController {
        if let taskBlotterTabBarViewController = tabBarController as? TBUITabBarController {
            return taskBlotterTabBarViewController
        } else {
            assertionFailure("Error This class should be a subclass of TBUITabBarController")
            return TBUITabBarController()
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        // todo calling controller should set AppState "currentGSlot" and "currentOSlot"
        self.storyListingTV.text = self.localGoal.name
        self.userActivity?.becomeCurrent()
    }
    
    
    @IBAction func addNewObjectiveButtonAction(_ sender: UIButton) {
        print("addNewObjectiveButtonAction: It's time to sunset TBUIGoalObjectiveController")
//        if let name: String = self.newObjectiveNameTV.text {
//            if let maxTasksStr: String = self.newObjectiveMaxTasksTV.text {
//                if let maxTasksInt = Int(maxTasksStr) {
//                    print("addNewObjectiveButtonAction: \(name) \(maxTasksInt)")
//                    //self.useParentTBC().domainStore.domain
//                    // get current goal by applying the current app state to the domain.
//                    // the replacement for this will have the goal index passed in, and not expect the app state to pint to it.
//                    // though even that approach has to validate the goal it is trying to use.
////                    let currentAppState = self.useParentTBC().stateStore.state
//                    let effortDomain = self.useParentTBC().domainStore.domain
//                    let actualScreenIndexState = effortDomain.addObjective(objective: Objective(name: name, maxTasks: maxTasksInt), gSlot: self.scr: currentAppState)
//                    self.storyListingTV.text = effortDomain.goals[actualScreenIndexState.gSlot].objectiveStrings()
//                } else {
//                    print("addNewObjectiveButtonAction: \(name)")
//                }
//            }
//        }
    }
    
    
    @IBAction func newObjectiveEditAction(_ sender: UIButton) {
        print("Have Not Implemented newObjectiveEditAction yet.")
    }
    
}
