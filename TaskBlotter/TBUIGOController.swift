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
            domainStore.saveData(domainRef: domainStore.domain)
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
        domainStore.saveData(domainRef: domainStore.domain)
        self.maxObjectiveTF.text = String(self.screenGoal.maxObjectives)
    }
    
    @IBAction func defaultGoalButtonAction(_ sender: UIButton) {
        print("pressed defaultGoalButton. screenGoalIndex is: \(self.screenGoalIndex)")
       
        // todo: there is no gIndexSaveCheck() like oIndexSaveCheck
        //      Goal creation happens before segue, so it is already there

        let stateStore = getTBStateStore()
        let domainStore = getTBDomainStore()
        let newState = domainStore.domain.requestNewCurrentGState(desiredGSlot: self.screenGoalIndex, previousAppState: stateStore.state)
        stateStore.saveData(stateRef: newState)
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

    
    
    @IBAction func deleteGoalButtonAction(_ sender: Any) {
        print("pressed delete Goal button. goalRank is: \(self.screenGoalIndex)")
        print("alert if there are objectives, else delete it.")
        print("unwind / dismiss controller stack to the Goal Listing.")
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
                targetVC.screenObjective = Objective(name: "New Objective")
                /** Not setting objectiveRankindicates that the objective is not created or saved yet.
                 */
            } else {
                print("TBUIGOController.prepare() Unrecognized Segue\(String(describing: segue.identifier)) ")
            }
        }
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

