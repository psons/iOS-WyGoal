//
//  TBUITabBarController.swift
//  Task Blotter Base
//
//  Created by Paul Sons on 2/22/23.
//

import UIKit

/**
 This class design aspires to keep a, AppState() object that has a current goal and current objective index that is always valid in the EffortDomain object.
 The reality is that the loading an persistence rules are different for AppState, which is transiant with any client looking at data, and EffortDomain, which may be
 mutating in other clients.  Therefore the EffortDomainAppState object has to have default behaviors to take compensating action if they are out of sync.
 */
class TBUITabBarController: UITabBarController {
    var navTarget: String = "none"
    var stateStore = StateStore()
    var domainStore = DomainStore()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("TBUITabBarController.viewDidLoad()")        
        super.viewDidLoad()
        loadDomainData()
        loadStateData()
        // saveStateData(stateRef: self.stateStore.state)  // todo, this is just temporary to test the method
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TBUITabBarController.viewWillAppear()")
        doNavigation()
    }

    
    func doNavigation() {
        if self.navTarget == "GoalDetail" {
            print("TBUITabBarController wil do doNavigation() to \(self.navTarget)")
            let goalNav = self.viewControllers?[2] as! UINavigationController // hard coded 2 is the position of this controller in the tab index.

            let goalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goal")
            // todo: build up a list of controllers here for deeper navigation cases.like [goalVC, goalObjectiveVC]

            goalNav.setViewControllers([goalVC], animated: true)  // can make longer array, and will display last.
            self.selectedViewController = goalNav  // this actualy displays the view controller after the arry is set up on prev line.
        }
        if self.navTarget == "none" {
            return
        }
    }
    

    func loadStateData() {
        StateStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let stateData):
                self.stateStore.state = stateData
            }
        }
    }

    func saveStateData(stateRef: AppState) {
        StateStore.save(state: stateRef) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }

    
    /**
     Loads the Domain data
     This method runs async, and we need data from it, so it needs to be a method in a long lived object in the app.
     As a long lived object it provides a 'self' attribute reference to assign the data to.
     otherwise the error message might be:
        - When the reference that gets the result is an inout paramater:
            Escaping closure captures 'inout' parameter 'domainInOutRef'
        - when it is local:
            Reference to property 'effortDomainAppState' in closure requires explicit use of 'self' to make capture semantics explicit
     */
    func loadDomainData() {
        DomainStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let domainData):
                self.domainStore.domain = domainData
            }
        }
    }

    func saveDomainData(domainRef: EffortDomain) {
        DomainStore.save(domain: domainRef) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
            
    func setNavigation(navTarget: String) {
        self.navTarget = navTarget
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in TBUITabBarController prepare for segue. self.navTarget: \(self.navTarget)")
            }

}
