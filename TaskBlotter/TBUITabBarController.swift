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
        for 2023-03-17 CSC471 class assume that the updates always go through the statestore and domain stor, and that even Siri voice updates
     launch the app and maintain the in-memory store
     */
    func useSyncedSavedState() -> AppState {
        let appState = self.stateStore.state
        let validatedAppState = self.domainStore.domain.requestNewValidGOState(desiredState: appState, previousAppState: appState)
        return validatedAppState
    }

    
    /**
     Builds an AppState into a GOState
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
    
    func getGoalListingVC() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goalListingStoryBoardID")
    }
    
    /**
     Only uses goal and gSlot from the screenState
     */
    func getGoalObjectivesVC(screenState: GOState) -> TBUIGOController {
        var goalObjectivesVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "goalObjectivesStoryBoardID") as! TBUIGOController
        goalObjectivesVC.screenGoal = screenState.goal
        goalObjectivesVC.screenGoalIndex = screenState.gSlot
        return goalObjectivesVC
    }

    func getObjectiveTasksVC(screenState: GOState) -> TBUIOTController {
        let objectiveTasksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "objectiveTasksStoryBoardID") as! TBUIOTController
        objectiveTasksVC.screenGoalIndex = screenState.gSlot
        objectiveTasksVC.screenObjectiveIndex = screenState.oSlot
        objectiveTasksVC.screenObjective = screenState.objective
        return objectiveTasksVC
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
        
        let appNav = self.viewControllers?[2] as! UINavigationController // hard coded 2 is the position of this controller in the tab index.
        var vcList: [UIViewController] = []
        print("TBUITabBarController wil do doNavigation() to \(self.navTarget)")

        if self.navTarget == "WyGoal" {
            var screenState = GOState(goal: Goal(name: self.intentData) )
            _ = self.domainStore.domain.addGoal(goal: screenState.goal)
            self.domainStore.saveData()
            vcList.append(getGoalListingVC())
            let goalObjectivesVC = getGoalObjectivesVC(screenState: screenState)
            vcList.append(goalObjectivesVC)
            
        } else if self.navTarget == "GoalListing" {
            vcList.append(getGoalListingVC())
        } else if self.navTarget == "ObjectiveTasks" {  // shows an objective
            vcList.append(getGoalListingVC())

            let screenState = getValidatedGOState()
            
            let goalObjectivesVC = getGoalObjectivesVC(screenState: screenState)
            vcList.append(goalObjectivesVC)
            
            let objectiveTasksVC = getObjectiveTasksVC(screenState: screenState)
            vcList.append(objectiveTasksVC)
            
        } else if self.navTarget == "AddObjective" {  // creates an objective
            vcList.append(getGoalListingVC())

            // todo: need to load saved state her so the new objective goes wher the user wants it!
            
            let screenState = getValidatedGOState()

            // new objective creation affects screenState in 2 ways...
            screenState.objective = Objective(name: self.intentData)
            let newAppState = domainStore.domain.addObjective(objective: screenState.objective, gSlot: screenState.gSlot)
            screenState.oSlot = newAppState.oSlot
            domainStore.saveData()

            let goalObjectivesVC = getGoalObjectivesVC(screenState: screenState)
            vcList.append(goalObjectivesVC)
            
            // screenState has the new Objective.
            let objectiveTasksVC = getObjectiveTasksVC(screenState: screenState)
            vcList.append(objectiveTasksVC)

        } else {
            print("Bad Nav setup has to be fatal.")
            assertionFailure(" doNavigation() failure likely caused by bad setNavigation(navTarget: ...)")
        }
        // set up the nav controller
        appNav.popToRootViewController(animated: false)
        appNav.setViewControllers(vcList, animated: true)
        // will display last VC in the list
        
        // set the TAB Bar controller have the Nav as curently selected
        self.selectedViewController = appNav  // this actualy displays the view controller after the arry is set up on prev line.
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
    var gSlot = -1
    var oSlot = -1
    var goal = Goal(name: "UNKNOWN")
    var objective = Objective(name: "UNKNOWN")
    
    init(gSlot: Int = 1, oSlot: Int = 1, goal: Goal = Goal(name: "UNKNOWN"), objective: Objective = Objective(name: "UNKNOWN")) {
        self.gSlot = gSlot
        self.oSlot = oSlot
        self.goal = goal
        self.objective = objective
    }
}
