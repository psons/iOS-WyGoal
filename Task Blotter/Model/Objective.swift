//
//  Objective.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation

let defaultMaxTasks = 1

// Objective replaces Story in the class model.
class Objective: Codable, CustomStringConvertible {
    var name: String
    var maxTasks = defaultMaxTasks
    let oid: String
    var tasks: [Task] = []
    var description: String {
        let heading = "{Objective} |maxTasks:\(maxTasks)|name: \(name)|oid: \(oid)|\n"
        var tasksAsStr = ""
        for task in tasks {
            tasksAsStr += "\t\t\t\(task)\n"
        }
        return heading + tasksAsStr
    }

    
    init(name: String, maxTasks: Int = defaultMaxTasks) {
        self.name = name
        self.maxTasks = maxTasks
        self.oid = "Need to implement oid in init"
    }

    func addTask(task: Task) {
        self.tasks.append(task)
    }

}
