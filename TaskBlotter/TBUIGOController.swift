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

class TBUIGOController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var objectives: [Objective] = []
    var localGoal = Goal(name: "UNKNOWN Goal name")
    var goalRank = -1

    @IBOutlet weak var objectiveListingTableView: UITableView!
    @IBOutlet weak var goalNameTV: UITextView!
    @IBOutlet weak var goalRankTF: UITextField!
    @IBOutlet weak var maxObjectiveStepper: UIStepper!
    @IBOutlet weak var maxObjectiveTF: UITextField!
    @IBOutlet weak var createObjectiveButton: UIButton!
    @IBOutlet weak var defaultGoalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Goal + Objectives"
        objectiveListingTableView.delegate = self
        objectiveListingTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.objectives = localGoal.objectives
        self.goalNameTV.text = self.localGoal.name
        
        let rankAsStr = String(self.goalRank + 1 ) // user sees rank as counting number, not array index.
        self.goalRankTF.text = rankAsStr

    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if let detail = segue.destination as? TBUIOTController {
             if let indexPath = self.objectiveListingTableView.indexPathForSelectedRow {
                 let objective = objectives[indexPath.row]
                 detail.localObjective = objective
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

        let objective = self.objectives[indexPath.row]

        // wire the cell GUI features to outlets in the prototype cell view controller.
        cell.objectiveNameLabel.text = objective.name
        let tasksAsStr =  "Need Task listing as a string here" // prefixAsLines(upTo: 4, ofStringList: getNames(objectives: goal.objectives))
        print(tasksAsStr)
        print("")
        cell.taskSummary.text = tasksAsStr
        cell.objectiveGrip.titleLabel?.text = String(indexPath.row + 1) // adjust index to user counting from 1
        return cell
    }
}

