//
//  TBUIGoalControllerViewController.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/4/23.
//

import UIKit

class TBUIGoalController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var goalListingTableview: UITableView!
    var goals: [Goal] = []
        
    @IBOutlet weak var goalListingTableView: UITableView!
    
    @IBOutlet weak var domainNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parentTBC = useParentTBC()
        self.goals = parentTBC.domainStore.domain.goals
        print("TBUIGoalControllerViewController.viewDidLoad()")
        goalListingTableView.delegate = self
        goalListingTableView.dataSource = self
    }
    
    /**
     TBUITabBarController.viewDidLoad()
     TBUITabBarController self.effortDomainAppState: 0x000060000297af00
     TBUIGoalControllerViewController.viewDidLoad()
     TBUIGoalControllerViewController edas: 0x000060000297af00
     */
    
    override func viewWillAppear(_ animated: Bool) {
        let domain = useParentTBC().domainStore.domain
        self.goals = domain.goals
        self.domainNameLabel.text = domain.name
        self.goalListingTableview.reloadData()
    }
    
    // This will be common to my TabBarController children, so maybe a base class?
    func useParentTBC() -> TBUITabBarController {
        if let taskBlotterTabBarViewController = tabBarController as? TBUITabBarController {
            return taskBlotterTabBarViewController
        } else {
            assertionFailure("Error This class should be loaded from of TBUITabBarController")
            return TBUITabBarController()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let targetVC = segue.destination as? TBUIGOController /*TBUIGoalObjectiveController*/ {
            if segue.identifier == "NewGoalDetail" {
                print("Making a Goal")
                targetVC.screenGoal = Goal(name: "New")
                targetVC.screenGoalIndex = self.useParentTBC().domainStore.domain.addGoal(goal: targetVC.screenGoal)
                self.useParentTBC().domainStore.saveData()
            } else if segue.identifier == "ShowGoalDetail"{
                print("Showing an existing Goal")
                if let indexPath = self.goalListingTableview.indexPathForSelectedRow {
                    let goal = goals[indexPath.row]
                    targetVC.screenGoal = goal
                    targetVC.screenGoalIndex = indexPath.row
                }
            } else {
                print("Unrecognized Segue is probably a bug: \(segue.destination)")
            }
        }
    }
    
  

}

// extensions for protocols needed to support TableView
extension TBUIGoalController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! TBUIGoalCell
        
        let goal = self.goals[indexPath.row]
        
        cell.goalNameLabel.text = goal.name
        let objectivesAsStr = prefixAsLines(upTo: 4, ofStringList: getNames(objectives: goal.objectives))
        print(objectivesAsStr)
        print("")
        cell.objectiveSummary.text = objectivesAsStr
        cell.goalGrip.titleLabel?.text = String(indexPath.row + 1) // adjust index to user counting from 1
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowGoalDetail", sender: self)
        }

    
    /*
     ellipsis behavior of things that are string convertable
     */
    func prefixAsLines(upTo slots: Int, ofStringList inStrLines: [String], endingWith: String = "...") -> String {
        let lastIndex = inStrLines.count - 1
        var outStr = ""
        if slots <= 0 {
        } else {
            if lastIndex  < slots {
                outStr = inStrLines.joined(separator: "\n")
            } else if lastIndex == slots {
                outStr = inStrLines[..<(slots-1)].joined(separator: "\n") + "\n" + endingWith
            } else if lastIndex > slots {
                outStr = inStrLines[..<(slots-1)].joined(separator: "\n") + "\n" + endingWith
            }
        }
        return outStr
    }

    func getNames(objectives: [Objective]) -> [String] {
        var outStrs: [String] = []
        for objective in objectives {
            outStrs.append(objective.name)
        }
        return outStrs
    }
    
}

//extension TBUIGoalControllerViewController {
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
////    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Method does not override any method from its superclass
////        <#code#>
////    }
//}
