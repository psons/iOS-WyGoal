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
    var appState = AppState()
    var domainStore = DomainStore()
    var effortDomainAppState: EffortDomainAppState?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.effortDomainAppState = EffortDomainAppState(effortDomain: domainStore.domain, appState: appState)
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.effortDomainAppState = EffortDomainAppState(effortDomain: domainStore.domain, appState: appState)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("TBUITabBarController.viewDidLoad()")        
        super.viewDidLoad()
        initDataState(dataState: .normal)
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
    
    /**
     This method runs async, and we need data from it, so it needs to be a method in a long lived object in the app.
     As a long livedobject it provides a 'self' attribute reference to assign the data to.
     otherwise the error message might be:
        - When the reference that gets the result is an inout paramater:
            Escaping closure captures 'inout' parameter 'domainInOutRef'
        - when it is local:
            Reference to property 'effortDomainAppState' in closure requires explicit use of 'self' to make capture semantics explicit
     */
    func loadData(domainInOutRef: inout EffortDomain) {
        DomainStore.load { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .success(let domainData):
                self.domainStore.domain = domainData
            }
        }
    }

    func saveData(domainRef: EffortDomain) {
        DomainStore.save(domain: domainRef) { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
        
    /**
     Different ways of setting the AppState() in sync with the saved domain.
        1 - clear empty data (see also AppIntent that cleard te domain data without loading the app)
        2 - test data
        3 - data loaded from disk
     */
    func initDataState(dataState: DataState) {
        switch dataState {
            // don't need this .   clear should be a separate shortcut.
        case .clear: // this is really dangerous for a real app.  Disable this after some testing.
            print("The .clear case shouldn't nef used in the TBUITabBarController")
//            self.domainStore =  DomainStore()
//            saveData(domainRef: self.domainStore.domain)
//            self.effortDomainAppState = EffortDomainAppState(effortDomain: &self.domainStore.domain,
//                                                             appState: &AppState())
        case .testdata: // this is really dangerous for a real app.  Disable this after some testing.
//            effortDomainAppState = dummyDataEffortDomainAppState
            self.domainStore.domain = testEffortDomain
            saveData(domainRef: self.domainStore.domain)
        case .normal:
//            self.domainStore =  DomainStore()
//            self.effortDomainAppState = EffortDomainAppState(effortDomain: &self.domainStore!.domain,
//                                                             appState: AppState())
            loadData(domainInOutRef: &self.domainStore.domain)

        }
        
    }

    
    func setNavigation(navTarget: String) {
        self.navTarget = navTarget
    }
    

    /*
    // MARK: - Navigation
     */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in TBUITabBarController prepare for segue. self.navTarget: \(self.navTarget)")
            }

}
