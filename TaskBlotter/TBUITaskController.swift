//
//  TBUITaskController.swift
//  WyGoal
//
//  Created by Paul Sons on 3/16/23.
//

import UIKit

class TBUITaskController: UIViewController {

    var screenTask = Task(status: .todo, name: "UNKNOWN", detail: "")
    var screenTaskIndex = -1
    
    @IBOutlet weak var taskNameTF: UITextField!
    @IBOutlet weak var taskDetailTV: UITextView!
    @IBOutlet weak var taskStatusSC: UISegmentedControl!
    @IBOutlet weak var taskRankTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task Detail"

    }

    override func viewWillAppear(_ animated: Bool) {
        self.taskNameTF.text = self.screenTask.name
        self.taskDetailTV.text = self.screenTask.detail
        self.taskRankTF.text = String(self.screenTaskIndex)
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
