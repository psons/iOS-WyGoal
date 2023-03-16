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
    var intentData = ""
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

    /**
     Retrns an AppState with indexes verified to be on the model's current state.
     todo: consider whether the actual disk saved state migh be changing outside of the control of this app
        for 2023-03-17 CSC471 class assume that the updates allways go through the statestore and domain stor, and that even Siri voice updates
     launch the app and maintain the in-memory store
     */
    func useSyncedSavedState() -> AppState {
        let appState = self.stateStore.state
        let validatedAppState = self.domainStore.domain.requestNewValidGOState(desiredState: appState, previousAppState: appState)
        return validatedAppState
    }

    
    /**
     gets the screen state data for two cases where screen state materializes from saved / cached state, not user clicks and navigation.
         - tab bar direct to the current saved objective
         - building up a nav array-stack as from a shortcut
     */
    func getValidatedGOState() -> GOState {
        let goState = GOState()
        let validatedAppState = useSyncedSavedState()
        goState.gSlot = validatedAppState.gSlot
        goState.oSlot = validatedAppState.oSlot
        goState.goal = self.domainStore.domain.goals[validatedAppState.gSlot]
        goState.objective = goState.goal.objectives[goState.oSlot]
        return goState
    }
    
    /**
     Builds and launches all or part of an array of nav controller rooted at the TBUITabBarController
     0 - Goal listing: TBUIGoalController
     1 - GO Goal Objectives: goalStoryBoardID
     2 - OT Objective Tasks:
     3 - Task Detail: // nav not supported, but want this screen.
     */
    func doNavigation() {
        
        if self.navTarget == "none" {
            return
        }
        
        if self.navTarget == "WyGoal" {
            
  
            print("TBUITabBarController wil do doNavigation() to \(self.navTarget)")
            let goalNav = self.viewControllers?[2] as! UINavigationController // hard coded 2 is the position of this controller in the tab index.

            let goalListingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goalListingStoryBoardID")
            
            let goalObjectivesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goalObjectivesStoryBoardID") as! TBUIGOController

            /**
             TODO:  these next two lines are goal creation andsetting up of the apropriate VC, same as iin the segue
             */
            goalObjectivesVC.screenGoal = Goal(name: self.intentData)
            goalObjectivesVC.screenGoalIndex = self.domainStore.domain.addGoal(goal: goalObjectivesVC.screenGoal)
            self.domainStore.saveData()
            
            // set up the nav controller
            goalNav.setViewControllers([goalListingVC, goalObjectivesVC], animated: true)
            // will display last VC in the list
            
            // set the TAB Bar controller have the Nav as curently selected
            self.selectedViewController = goalNav  // this actualy displays the view controller after the arry is set up on prev line.

            
        }
        
        if self.navTarget == "GoalListing" {
            print("TBUITabBarController wil do doNavigation() to \(self.navTarget)")
            let goalNav = self.viewControllers?[2] as! UINavigationController // hard coded 2 is the position of this controller in the tab index.

            let goalListingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goalListingStoryBoardID")
            // todo: build up a list of controllers here for deeper navigation cases.like [goalVC, goalObjectiveVC]

            goalNav.setViewControllers([goalListingVC], animated: true)  // can make longer array, and will display last.
            self.selectedViewController = goalNav  // this actualy displays the view controller after the arry is set up on prev line.
        }
        if self.navTarget == "ObjectiveTasks" {
            
            let screenStateData = getValidatedGOState()
            
            print("TBUITabBarController wil do doNavigation() to \(self.navTarget)")
            let goalNav = self.viewControllers?[2] as! UINavigationController // hard coded 2 is the position of this controller in the tab index.

            let goalListingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goalListingStoryBoardID")
            
            let goalObjectivesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goalObjectivesStoryBoardID") as! TBUIGOController
            goalObjectivesVC.screenGoal = screenStateData.goal
            goalObjectivesVC.screenGoalIndex = screenStateData.gSlot
            
            let objectiveTasksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "objectiveTasksStoryBoardID") as! TBUIOTController
            objectiveTasksVC.screenGoalIndex = screenStateData.gSlot
            objectiveTasksVC.screenObjectiveIndex = screenStateData.oSlot
            objectiveTasksVC.screenObjective = screenStateData.objective
            
            // set up the nav controller
            goalNav.popToRootViewController(animated: false)
            goalNav.setViewControllers([goalListingVC, goalObjectivesVC, objectiveTasksVC], animated: true)
            // will display last VC in the list
            
            // set the TAB Bar controller have the Nav as curently selected
            self.selectedViewController = goalNav  // this actualy displays the view controller after the arry is set up on prev line.
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
     
    /**
        determines the navigation screen and provides a name for minimal creation of a goal, objective, or task.
     */
    func setNavigation(navTarget: String, name: String) {
        self.intentData = name
        setNavigation(navTarget: navTarget)
    }
    
    func setNavigation(navTarget: String) {
        self.navTarget = navTarget
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in TBUITabBarController prepare for segue. self.navTarget: \(self.navTarget)")
            }

}

/**
 Data representing a path down to an Objective as a user might nevigate in the app
  It is an elaboration on an AppState with a known EffortDomainModel.
    A few screens save a goal along with the
    todo: set up as ubclass of AppState, which will require AppState to be updated with Codable init 
 */
class GOState {
    var oSlot = -1
    var gSlot = -1
    var goal = Goal(name: "UNKNOWN")
    var objective = Objective(name: "UNKNOWN")
}
