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

class TBUIOTController: TBRootAccessController, UITableViewDataSource, UITableViewDelegate {

    var screenObjective = Objective(name: "UNKNOWN Objective")
    var screenObjectiveIndex = -1
    var screenGoalIndex = -1
    @IBOutlet weak var objectiveNameTF: UITextField!
    @IBOutlet weak var taskListingTableView: UITableView!
    @IBOutlet weak var defaultObjectiveButton: UIButton!
    @IBOutlet weak var maxTaskStepper: UIStepper!
    @IBOutlet weak var maxTaskTF: UITextField!
    @IBOutlet weak var createTaskButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Objective + Tasks"
        setupFromSaved()
        taskListingTableView.delegate = self
        taskListingTableView.dataSource = self
        
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
        self.taskListingTableView.reloadData()

    }
    
    
    @IBAction func createTaskButtonAction(_ sender: UIButton) {
        print("pressed create Task button.  Segue should happen")
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let targetVC = segue.destination as? TBUITaskController {
            
            if segue.identifier == "ShowTaskDetail"  {
                print("Doing segue: \(String(describing: segue.identifier))")
                if let indexPath = self.taskListingTableView.indexPathForSelectedRow {
                    targetVC.screenTask = self.screenObjective.tasks[indexPath.row]
                    targetVC.screenTaskIndex = indexPath.row
                }
            } else if segue.identifier == "CreateNewTask" {
                // todo add this task to the domain and save it
                // similar code in the TBUITabBarController could be combined.
                let newTask = Task(name: "New Task", detail: "")
                let appState = self.getTBDomainStore().domain.addTask(task: newTask, gSlot: self.screenGoalIndex, oSlot: self.screenObjectiveIndex)
                self.getTBDomainStore().saveData()
                targetVC.screenTask = newTask
                targetVC.screenTaskIndex = self.getTBDomainStore().domain.goals[appState.gSlot].objectives[appState.oSlot].tasks.count //?? 0
            } else {
                print("TBUIGOController.prepare() Unrecognized Segue\(String(describing: segue.identifier)) ")
            }
        }
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
    /**
     todo eliminate this method and all of its uses in favor of assuring that the objective is always created before coming to this screen
     */
    func oIndexSaveCheck() -> Int {
        if self.screenObjectiveIndex == -1 {
            let domainStore = getTBDomainStore()
            let screenState = domainStore.domain.addObjective(objective: screenObjective, gSlot: self.screenGoalIndex)
            domainStore.saveData()

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
            domainStore.saveData()
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
        stateStore.state.gSlot = self.screenGoalIndex
        stateStore.state.oSlot = oIndex
        stateStore.saveData()
        print("defaultObjectiveButtonAction saved:  \(self.screenGoalIndex), \(oIndex)")
        setSetDefaultButtonText() // might have updated if we just created an Objective
    }

    @IBAction func deleteObjectiveButtonAction(_ sender: Any) {
    print("Raise an Alert to confirm delete")
        doObjectiveDeleteAlert(condition: "Will delete the curent Objective",
                    choice: "Are you sure you want to delete it?",
                    notice: "Objective Deleted",
                    newState: "Will now return to current Goal")
    }
    
    @IBAction func maxTasksStepperAction(_ sender: Any) {
        let domainStore = getTBDomainStore()
        let maxTasks = Int(maxTaskStepper.value)
        print("change in maxTasksStepper): \(maxTasks)")
        _ = oIndexSaveCheck()
        domainStore.domain.goals[self.screenGoalIndex].objectives[self.screenObjectiveIndex].maxTasks = maxTasks
        domainStore.saveData()
        self.maxTaskTF.text = String(maxTasks)
    }
        
    func doObjectiveDeletePopNav() {
        print("Will do delete of \(self.screenGoalIndex),\(self.screenObjectiveIndex)")
        print("Then invoke nave back to the goal \(self.screenGoalIndex)")
        _ = self.getTBDomainStore().domain.goals[self.screenGoalIndex].removeObjective(oSlot: self.screenObjectiveIndex)
        self.navigationController?.popViewController(animated: true)
    }
    
    func doObjectiveDeleteAlert(condition: String, choice: String, notice: String, newState: String) {
        let outerAlertController = UIAlertController(
            title: condition,
            message: choice,
            preferredStyle: .alert)
        let outerAlertActionConfirmPath = UIAlertAction(
            title: "Yes", style: .default)
                { _ in
                    // This is the change action the user is approving.
                    self.doObjectiveDeletePopNav()
                    let innerAlertController =
                        UIAlertController(
                            title: notice,
                            message: newState,
                            preferredStyle: .alert)
                    innerAlertController.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: .default, handler: nil))
                    self.present(
                        innerAlertController,
                        animated: true,
                        completion: nil)
                }

        let outerAlertActionEscapePath = UIAlertAction(
            title: "No", style: .default)

        
        outerAlertController.addAction(outerAlertActionConfirmPath)
        outerAlertController.addAction(outerAlertActionEscapePath)
   
        present(outerAlertController, animated: true, completion: nil)
    }
}

extension TBUIOTController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.screenObjective.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let task = self.getTBDomainStore().domain.goals[self.screenGoalIndex].objectives[self.screenObjectiveIndex].tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: task.status.rawValue, for: indexPath)
        /**Using off the shelf cell, not mine**/
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowTaskDetail", sender: self)
        }

}
