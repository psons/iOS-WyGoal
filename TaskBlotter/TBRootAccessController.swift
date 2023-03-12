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
    
    func getTBRootController() ->TBUITabBarController{
        return navigationController!.viewControllers.first?.tabBarController as! TBUITabBarController
    }
    
    func getTBStateStore() -> StateStore {
        return getTBRootController().stateStore
    }
    
    func getTBDomainStore() -> DomainStore {
        return getTBRootController().domainStore
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
