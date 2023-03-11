//
//  DataState.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/8/23.
//

import Foundation

enum DataState: String {
    case clear = "clear"  // wipe out the Domain data to empty state
    case testdata = "testData" // wipe and load the hard coded data from json
    case normal = "normal" // load whatever data has been persisted
    var state: String { return self.rawValue }

}

