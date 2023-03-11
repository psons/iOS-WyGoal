//
//  TBUIGoalControllerViewController.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/4/23.
//

import UIKit

class TBUIGoalControllerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
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
//        print("TBUIGoalControllerViewController edas: \(Unmanaged.passUnretained(edas).toOpaque())")
//        useParentTBC().loadData(domainInOutRef: &edas.effortDomain)
        self.goals = domain.goals
        self.domainNameLabel.text = domain.name
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

    
    /**
     This will be common to my TabBarController children, so maybe a base class?
     access the data and application state from the root controller.
     */
    func useEffortDomainAppStateRef() -> EffortDomainAppState {
        let tbc = self.useParentTBC()
        return tbc.effortDomainAppState!
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detail = segue.destination as? TBUIGOController /*TBUIGoalObjectiveController*/ {
            if let indexPath = self.goalListingTableview.indexPathForSelectedRow {
                let goal = goals[indexPath.row]
                detail.localGoal = goal
                detail.goalRank = indexPath.row
            }
        }
    }
    
  

}

// extensions for protocols needed to support TableView
extension TBUIGoalControllerViewController {
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
