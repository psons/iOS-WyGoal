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

    // This will be common to my TabBarController children, so maybe a base class?

    /**
            access the data and application state from the root controller.
     */
    func useEffortDomainAppStateRef() -> EffortDomainAppState {
        return self.useParentTBC().effortDomainAppState!
    }
    
    // Gets a reference from the parent tabBarController to keep track of user position in the app asneeded for Siri Intens ad NSUserActivities
//    func useAppState()-> AppState {
//        return self.useParentTBC().appState
//    }

    override func viewWillAppear(_ animated: Bool) {
//        self.storyListingTV.text = useEffortDomainRef().goals[useAppState().currentGSlot].objectiveStrings()

        // todo calling controller should set AppState "currentGSlot" and "currentOSlot"
        //        self.storyListingTV.text = useEffortDomainAppStateRef().currentGoal.objectiveStrings()
        self.storyListingTV.text = self.localGoal.name
//        self.userActivity = donateAddObjectiveActivity()
        self.userActivity?.becomeCurrent()
    }
    
    
//    func donateAddObjectiveActivity() -> NSUserActivity {
//        let addObjectiveActivity = NSUserActivity(activityType: newActivityTypeADDObjective)
//        addObjectiveActivity.persistentIdentifier =
//          NSUserActivityPersistentIdentifier(newActivityTypeADDObjective)
//
//        addObjectiveActivity.isEligibleForSearch = true
//        addObjectiveActivity.isEligibleForPrediction = true
//        addObjectiveActivity.title = "Add an Objective"
//        addObjectiveActivity.suggestedInvocationPhrase = "Blotter new Objective"
//
//        // See https://docs.google.com/document/d/1fs4SBer2XYgen4w8QxEg5uWwAG06SSVhimdxR02Kd_s/edit?usp=sharing
//        let attributeSet = CSSearchableItemAttributeSet(contentType: UTType.png )
//        attributeSet.contentDescription = "Goal Pursuit!"
//        attributeSet.thumbnailData = UIImage(named: "logo")?.pngData()
//        //attributeSet.thumbnailData = thumbnail?.jpegData(compressionQuality: 1.0)
//        attributeSet.contentDescription = "An Objective will be achieved with a collection of tasks."
//
//        addObjectiveActivity.contentAttributeSet = attributeSet
//        return addObjectiveActivity
//    }
    
    /**
     todo Programatically add a space for a user to add an Objective
        Objective needs to be in curently selected Endeavor.
        For now:
         - just Default Endeavor
             - concat the Objective into static text view
     */
    

    @IBAction func addNewObjectiveButtonAction(_ sender: UIButton) {
        if let name: String = self.newObjectiveNameTV.text {
            if let maxTasksStr: String = self.newObjectiveMaxTasksTV.text {
                if let maxTasksInt = Int(maxTasksStr) {
                    print("addNewObjectiveButtonAction: \(name) \(maxTasksInt)")
                    self.useEffortDomainAppStateRef().currentGoal.addObjective(objective: Objective(name: name, maxTasks: maxTasksInt))
                    self.storyListingTV.text = self.useEffortDomainAppStateRef().currentGoal.objectiveStrings()
                } else {
                    print("addNewObjectiveButtonAction: \(name)")
                }
            }
        }
    }
    
        
//    func navigateToPlanScreen(_ activity: NSUserActivity?) {
//        print("navigateToPlanScreen")
//        let viewController = TBUIPlanController(activity)
//        navigationController?.popToRootViewController(animated: false)
//        navigationController?.pushViewController(viewController, animated: true)
//    }
    
    @IBAction func newObjectiveEditAction(_ sender: UIButton) {
        print("Have Not Implemented newObjectiveEditAction yet.")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


/**
 write an extension of EffortDomain that recieve field obkects from the view controller, knows how to read tem to update the model
 and can useAppState to update self.  The caller should update AppSate as needed and pass it into this extension to update the model.

 */

//extension EffortDomain {
//
//    func addObjective( at: AppState, nameTF: UITextField, maxTasksTF: UITextField) {
//
//    }
//}
