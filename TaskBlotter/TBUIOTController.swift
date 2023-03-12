//
//  TBUIOTController.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/10/23.
//

import UIKit
// Task Blotter UI Objective + Task Controller
// Color associated with Objective Things: A4C4FF = Bluish
// Background Color associated with Task Things: 63CFA3 = Greenish
//  darker text against white:   = darker Greenish
// Cell Identifier: "TaskCell"

class TBUIOTController: TBRootAccessController {

    var screenObjective = Objective(name: "UNKNOWN Objective")
    var screenObjectiveIndex = -1
    var screenGoalIndex = -1
    @IBOutlet weak var objectiveNameTF: UITextField!
    @IBOutlet weak var taskListinTableView: UITableView!
    @IBOutlet weak var defaultObjectiveButton: UIButton!
    @IBOutlet weak var maxTaskStepper: UIStepper!
    @IBOutlet weak var maxTaskTF: UITextField!
    @IBOutlet weak var createTaskButton: UIButton!

 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Objective + Tasks"
        // todo: uncomment when I do the tasktableview
//        taskListinTableView.delegate = self
//        taskListinTableView.dataSource = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.objectiveNameTF.text = self.screenObjective.name
        let goalRankAsStr = String(self.screenGoalIndex + 1)
        let objRankAsStr =  self.screenObjectiveIndex == -1 ?  "?" :String(self.screenObjectiveIndex + 1)
        
        self.defaultObjectiveButton.setTitle("Set Default: \(goalRankAsStr):\(objRankAsStr)", for: .normal)
        self.maxTaskTF.text = String(self.screenObjective.maxTasks)
        self.maxTaskStepper.value = Double(self.screenObjective.maxTasks)
    }
    
    /**
     calling oIndexSaveCheck will create and insert the localObjective if the curent objectiveIndex is -1.
     This should be used to assure saving of any user edit after the 'Create New Objective' button Segue to this screen.
     This does not update the AppState used as a shortcut target for new Objectives and Tasks, but the caller may do so
     */
    func oIndexSaveCheck() -> Int {
        if self.screenObjectiveIndex == -1 {
            let domainStore = getTBDomainStore()
            let screenState = domainStore.domain.addObjective(objective: screenObjective, gSlot: self.screenGoalIndex)
            domainStore.saveData(domainRef: domainStore.domain)

            // should be able to return the objective rank here from the newState
            self.screenObjectiveIndex = screenState.oSlot
            return self.screenObjectiveIndex
        } else {
            return self.screenObjectiveIndex
        }
    }

    
    @IBAction func objectiveNameTFdidEndExitAction(_ sender: UITextField) {
        if let editedName = sender.text {
            print("Exit Ended on \(editedName)")
            let domainStore = getTBDomainStore() // Fatal if back button without ending exit on return
            let oIndex = oIndexSaveCheck()
            domainStore.domain.goals[self.screenGoalIndex].objectives[oIndex].name = editedName
            domainStore.saveData(domainRef: domainStore.domain)
            /**
             is it possible that the 2 saves here happen out of order?  Depends on the dispatch queue design.
             */
        }
    }
    
    @IBAction func defaultObjectiveButtonAction(_ sender: UIButton) {
        print("pressed defaultObjectiveButtonAction. screenGoalIndex is: \(self.screenGoalIndex) screenObjectiveIndex is: \(self.screenObjectiveIndex)")
        // first save the obj so tomake sure it is a legit index to save as a target
        let oIndex = oIndexSaveCheck()
        let stateStore = getTBStateStore()
        let domainStore = getTBDomainStore()
//        let newState = domainStore.domain.requestNewCurrentGState(desiredGSlot: self.goalIndex, previousAppState: stateStore.state)
//        stateStore.saveData(stateRef: newState)
    }

    @IBAction func maxTasksStepperAction(_ sender: Any) {
        let domainStore = getTBDomainStore()
        let maxTasks = Int(maxTaskStepper.value)
        print("change in maxTasksStepper): \(maxTasks)")
        let oIndex = oIndexSaveCheck()
        domainStore.domain.goals[self.screenGoalIndex].objectives[self.screenObjectiveIndex].maxTasks = maxTasks
        domainStore.saveData(domainRef: domainStore.domain)
        self.maxTaskTF.text = String(maxTasks)
    }
    
    
    
}
