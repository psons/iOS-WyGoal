//
//  TBUIGOControllerViewController.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/10/23.
//

import UIKit

// Color associated with Objective Things: A4C4FF = Bluish
// Background Color associated with Goal Things: B29EFF = Purplish
//  darker text against white: 5F5488 = darker purpleish
// Cell Identifier: "ObjectiveCell"

class TBUIGOController: TBRootAccessController, UITableViewDataSource, UITableViewDelegate{
    
    var objectives: [Objective] = []
    var screenGoal = Goal(name: "UNKNOWN Goal name")
    var screenGoalIndex = -1
    
    @IBOutlet weak var objectiveListingTableView: UITableView!
    @IBOutlet weak var goalNameTF: UITextField!
    @IBOutlet weak var maxObjectiveStepper: UIStepper!
    @IBOutlet weak var maxObjectiveTF: UITextField!
    @IBOutlet weak var createObjectiveButton: UIButton!
    @IBOutlet weak var defaultGoalButton: UIButton!
    
    @IBAction func goalNameTFdidEndExitAction(_ sender: UITextField,
                                              forEvent event: UIEvent) {
        if let editedName = sender.text {
            print("Exit Ended on \(editedName)")
            let domainStore = getTBDomainStore()
            domainStore.domain.goals[self.screenGoalIndex].name = editedName
            domainStore.saveData()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Goal + Objectives"
        objectiveListingTableView.delegate = self
        objectiveListingTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.objectives = screenGoal.objectives
        self.goalNameTF.text = self.screenGoal.name
        
        let rankAsStr = String(self.screenGoalIndex + 1 ) // user sees rank as counting number, not array index.
        self.defaultGoalButton.setTitle("Set Default: \(rankAsStr)", for: .normal)
        self.maxObjectiveTF.text = String(self.screenGoal.maxObjectives)
        self.maxObjectiveStepper.value = Double(self.screenGoal.maxObjectives)
        self.objectiveListingTableView.reloadData()
    }
    
    @IBAction func maxObjectiveStepperAction(_ sender: UIStepper) {
        let domainStore = getTBDomainStore()
        let maxObjectives = maxObjectiveStepper.value
        print("change in maxObjectiveStepper): \(maxObjectives)")
        domainStore.domain.goals[self.screenGoalIndex].maxObjectives = Int(maxObjectives)
        domainStore.saveData()
        self.maxObjectiveTF.text = String(self.screenGoal.maxObjectives)
    }
    
    @IBAction func defaultGoalButtonAction(_ sender: UIButton) {
        print("pressed defaultGoalButton. screenGoalIndex is: \(self.screenGoalIndex)")
        
        // todo: there is no gIndexSaveCheck() like oIndexSaveCheck
        //      Goal creation happens before segue, so it is already there
        
        let stateStore = getTBStateStore()
        let domainStore = getTBDomainStore()
        let newState = domainStore.domain.requestNewCurrentGState(desiredGSlot: self.screenGoalIndex, previousAppState: stateStore.state)
        domainStore.saveData()
        stateStore.state.gSlot = newState.gSlot
        stateStore.state.oSlot = newState.oSlot
        stateStore.saveData()
        print("defaultObjectiveButtonAction saved:  \(newState)")
        setSetDefaultButtonText() // might have updated if we just created an Objective
        
    }
    
    /**
     Handles incrementing index for user display
     */
    func setSetDefaultButtonText() {
        let goalRankAsStr = String(self.screenGoalIndex + 1)
        self.defaultGoalButton.setTitle("Set Default: \(goalRankAsStr)", for: .normal)
    }
    
    func goalHasNoObjectives() -> Bool {
        return self.getTBDomainStore().domain.goals[self.screenGoalIndex].objectives.count == 0
    }
    
    func doGoalDeletePopNav() {
        print("Will do delete of \(self.screenGoalIndex)")
        print("Then invoke nav back to the goal listing")
        _ = self.getTBDomainStore().domain.removeGoal(gSlot: self.screenGoalIndex)
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func deleteGoalButtonAction(_ sender: Any) {
        print("pressed delete Goal button. goalRank is: \(self.screenGoalIndex)")
        if goalHasNoObjectives() {
            doGoalDeleteAlert(condition: "Will delete the curent Goal",
                              choice: "Are you sure you want to delete it?",
                              notice: "Goal Deleted",
                              newState: "Will now return to the Goal Listing")
        } else {
            alertCondition(notice: "There are objectives for this Goal.",
                           newState: "You must delete them before this Goal can be deleted")
        }
        
    }
    
    @IBAction func createObjectiveButtonAction(_ sender: UIButton) {
        print("pressed create Objective button.  Segue should happen")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let targetVC = segue.destination as? TBUIOTController {
            targetVC.screenGoalIndex = self.screenGoalIndex
            if segue.identifier == "ShowObjectiveDetail"  {
                print("Doing segue: \(String(describing: segue.identifier))")
                if let indexPath = self.objectiveListingTableView.indexPathForSelectedRow {
                    let objective = objectives[indexPath.row]
                    targetVC.screenObjective = objective
                    targetVC.screenObjectiveIndex = indexPath.row
                }
            } else if segue.identifier == "CreateNewObjective" {
                let newObjective = Objective(name: "New Objective")
                print("New Objective should add to goal \(self.screenGoalIndex) \(self.screenGoal.name)")
                let appState = self.getTBDomainStore().domain.addObjective(objective: newObjective, gSlot: self.screenGoalIndex)
                self.getTBDomainStore().saveData()
                print("New Objective now reports the appState as \(appState)")
                targetVC.screenObjective = newObjective
                targetVC.screenObjectiveIndex = appState.oSlot
            } else {
                print("TBUIGOController.prepare() Unrecognized Segue\(String(describing: segue.identifier)) ")
            }
        }
    }

    func alertCondition(notice: String, newState: String) {
        print("Need to alert for condition: \(notice)")
        print("With Prompt: \(newState)")

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
    
    
    
    func doGoalDeleteAlert(condition: String, choice: String, notice: String, newState: String) {
        let outerAlertController = UIAlertController(
            title: condition,
            message: choice,
            preferredStyle: .alert)
        let outerAlertActionConfirmPath = UIAlertAction(
            title: "Yes", style: .default)
                { _ in
                    // This is the change action the user is approving.
                    self.doGoalDeletePopNav()
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

// extensions for protocols needed to support TableView
extension TBUIGOController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objectives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectiveCell", for: indexPath) as! TBUIObjectiveCell

//        let objective = self.objectives[indexPath.row]
        let objective = self.getTBDomainStore().domain.goals[self.screenGoalIndex].objectives[indexPath.row]

        // wire the cell GUI features to outlets in the prototype cell view controller.
        cell.objectiveNameLabel.text = objective.name
        let tasksAsStr =  "Need Task listing as a string here" // prefixAsLines(upTo: 4, ofStringList: getNames(objectives: goal.objectives))
        print(tasksAsStr)
        print("")
        cell.taskSummary.text = tasksAsStr
        cell.objectiveGrip.titleLabel?.text = String(indexPath.row + 1) // adjust index to user counting from 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowObjectiveDetail", sender: self)
        }
    
}

