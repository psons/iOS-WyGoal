//
//  Goal.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation

let defaultMaxObjectives = 3

class Goal: Codable, CustomStringConvertible {
    static let defaultOslot = 0
    let _id: String
    var name = ""
    var maxObjectives = 3
    let gid: String
    var objectives: [Objective] = []
    var description: String {
        let heading = "{Goal} |_id: \(_id)|name: \(name)|maxObjectives: \(maxObjectives)|gid: \(gid)|\n"
        var objectivesAsStr = ""
        for objective in objectives {
            objectivesAsStr += "\t\(objective)\n"
        }
        return heading + objectivesAsStr
    }

    init(name: String, maxObjectives: Int = defaultMaxObjectives, createDefaultObjective: Bool = false) {
        self._id = "Need to implement _id in init"
        self.name = name
        self.maxObjectives = maxObjectives
        self.gid = "Need to implement gid in init"
        if createDefaultObjective {
            self.objectives.append(Objective(name: "default objective"))
        }
    }

    func addObjective(objective: Objective) {
        self.objectives.append(objective)
    }

    func objectiveStrings() -> String {
        var sList = ""
        for objective in self.objectives {
            sList += "\t\t\(objective)\n"
        }
        return sList
    }
    
}
