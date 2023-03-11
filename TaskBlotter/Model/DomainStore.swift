//
//  DomainPersist.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/7/23.
//

import Foundation
    
class DomainStore {
    var domain: EffortDomain
    init(domain: EffortDomain) {
        self.domain = domain
    }
    
    init(name: String = "default") {
        self.domain = EffortDomain(name: name)
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("domain.json")
    }
    

    func saveData(domainRef: EffortDomain) {
        DomainStore.save(domain: domainRef) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    static func load(completion: @escaping (Result<EffortDomain, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success(EffortDomain(name: "default")))
                    }
                    return
                }
                let loadedDomainData = try JSONDecoder().decode(EffortDomain.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(loadedDomainData))
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
    static func save(domain: EffortDomain, completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(domain)
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
