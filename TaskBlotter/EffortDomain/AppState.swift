//
//  AppState.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation

class AppState: Codable, CustomStringConvertible {
    var gSlot = EffortDomain.defaultGSlot  // index of an goal that will be used if none provided when creatig an Objective
    var oSlot = Goal.defaultOslot  // index of Objective that will be used if none provided when creatig a task.
    var tSlot = Objective.defaultTslot

    var description: String {
        return "Appstate slots (G,O) (\(gSlot),\(oSlot))"
    }
    
//    init() {
//        self.gSlot = EffortDomain.defaultGSlot
//        self.oSlot = Goal.defaultOslot
//        self.tSlot = Objective.defaultTslot
//    }
//    
//    init(_ gSlot: Int, _ oSlot: Int) {
//        self.gSlot = gSlot
//        self.oSlot = oSlot
//    }
    
    init(_ gSlot: Int = EffortDomain.defaultGSlot,
         _ oSlot: Int = Goal.defaultOslot ,
         _ tSlot: Int = Objective.defaultTslot) {
        self.gSlot = gSlot
        self.oSlot = oSlot
        self.tSlot = tSlot
    }
    
}
