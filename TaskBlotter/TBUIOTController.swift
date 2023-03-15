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
        setupFromSaved()
        // todo: uncomment when I do the tasktableview
//        taskListinTableView.delegate = self
//        taskListinTableView.dataSource = self
        
    }

    func setupFromSaved() {
        if self.screenGoalIndex == -1 {
            /**
            caller did not forward set required data
            in this case we can reach to the containing TabBarController to get data based on saved state
            */
            let parentTBC = useParentTBC()
            let goState = parentTBC.getValidatedGOState()   //todo make this get saved state data
            self.screenObjective = goState.objective
            self.screenObjectiveIndex = goState.oSlot
            self.screenGoalIndex = goState.gSlot
            print("used TBC to get setup TBUIOTController and load \(screenGoalIndex),\(screenObjectiveIndex)")
        } else {
            print("The caling controller already set up TBUIOTController with screenGoalIndex: \(screenGoalIndex)")
        }

    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.objectiveNameTF.text = self.screenObjective.name
        self.maxTaskTF.text = String(self.screenObjective.maxTasks)
        self.maxTaskStepper.value = Double(self.screenObjective.maxTasks)
        setSetDefaultButtonText()
    }

    /**
     Handles incrementing indecies for user display
     */
    func setSetDefaultButtonText() {
        let goalRankAsStr = String(self.screenGoalIndex + 1)
        let objRankAsStr =  self.screenObjectiveIndex == -1 ?  "?" :String(self.screenObjectiveIndex + 1)
        self.defaultObjectiveButton.setTitle("Set Default: \(goalRankAsStr):\(objRankAsStr)", for: .normal)
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
    
    /**
     Save the current objective if necessary, then save the curent screen goal index and this objective index as the default state
     */
    @IBAction func defaultObjectiveButtonAction(_ sender: UIButton) {
        print("pressed defaultObjectiveButtonAction. screenGoalIndex is: \(self.screenGoalIndex) screenObjectiveIndex is: \(self.screenObjectiveIndex)")
        let oIndex = oIndexSaveCheck()
        print("defaultObjectiveButtonAction ")
        let stateStore = getTBStateStore()
        stateStore.saveData(stateRef: AppState.factory(self.screenGoalIndex, oIndex))
        stateStore.state.gSlot = self.screenGoalIndex
        stateStore.state.oSlot = oIndex
        print("defaultObjectiveButtonAction saved:  \(self.screenGoalIndex), \(oIndex)")
        setSetDefaultButtonText() // might have updated if we just created an Objective
    }

    @IBAction func maxTasksStepperAction(_ sender: Any) {
        let domainStore = getTBDomainStore()
        let maxTasks = Int(maxTaskStepper.value)
        print("change in maxTasksStepper): \(maxTasks)")
        _ = oIndexSaveCheck()
        domainStore.domain.goals[self.screenGoalIndex].objectives[self.screenObjectiveIndex].maxTasks = maxTasks
        domainStore.saveData(domainRef: domainStore.domain)
        self.maxTaskTF.text = String(maxTasks)
    }
    
    
    
}
