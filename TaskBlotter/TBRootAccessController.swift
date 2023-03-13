//
//  TBRootAccessController.swift
//  TaskBlotter
//
//  Created by Paul Sons on 3/11/23.
//

import UIKit

/**
 Subclass this controller for ViewControllers that
  - will be access through a Navigation Controller
  - and need access to the Task Blotter root controller data.
 */

class TBRootAccessController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     Some controllers may use this that were loaded by a nav controller
     Some controllers may use this that were loaded by a TabBarController.
     This has crashed if the calling controller wasn't loaded by a navigationController useParentTBC seems to always work,
     but I need to test more. ' if let' should cover problems.
     
    */
    func getTBRootController() ->TBUITabBarController{
        if let navC = navigationController {
            if let tbcViaNav = navC.viewControllers.first?.tabBarController as? TBUITabBarController {
                return tbcViaNav
            }
        }
        return useParentTBC()
    
    }
    
    func getTBStateStore() -> StateStore {
        return getTBRootController().stateStore
    }
    
    func getTBDomainStore() -> DomainStore {
        return getTBRootController().domainStore
    }
    
    func useParentTBC() -> TBUITabBarController {
        if let taskBlotterTabBarViewController = tabBarController as? TBUITabBarController {
            return taskBlotterTabBarViewController
        } else {
            assertionFailure("Error This class should be loaded from of TBUITabBarController")
            return TBUITabBarController()
        }
    }
}
