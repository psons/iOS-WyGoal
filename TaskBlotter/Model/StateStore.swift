//
//  StateStore.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/10/23.
//

import Foundation

/**
 Data saving class for the users 'context' consisting of:
  - the index of the current goal that they may be creating / editing, or a default goal, which always exists.
  - the index of the current objective that they may be creating / editing or a default objective, which always exists.
  - todo: context should include a current task if the user is creating or editing a task
 */
class StateStore {
    var state: AppState
    init(state: AppState) {
        self.state = state
    }
    
    init(currentGSlot: Int = 0, currentOSlot: Int = 0) {
        self.state = AppState()
        self.state.gSlot = currentGSlot
        self.state.oSlot = currentOSlot
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("state.json")
    }
    

    func saveData() {
        StateStore.save(state: self.state) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }

    static func load(completion: @escaping (Result<AppState, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(AppState()))
                    }
                    return
                }
                let loadedStateData = try JSONDecoder().decode(AppState.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedStateData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /**
     Thinking why this should be static:  the caller may go out of scope while the async save is happening.
     */
    static func save(state: AppState, completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(state)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(1))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
