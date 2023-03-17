//
//  TBUITaskController.swift
//  WyGoal
//
//  Created by Paul Sons on 3/16/23.
//

import UIKit

class TBUITaskController: UIViewController {

    var task = Task(status: .todo, name: "UNKNOWN", detail: "")
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDetail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task Detail"

    }

    override func viewWillAppear(_ animated: Bool) {
        self.taskName.text = self.task.name
        self.taskDetail.text = self.task.detail
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
