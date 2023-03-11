//
//  ModelData.swift
//  Task Blotter
//
//  Created by Paul Sons on 3/4/23.
//

import Foundation
var effortDomainJsonString =
    """
    {
        "name": "Daydreaming time",
        "todoMaxTasks": 6,
        "goals": [
            {
            "_id": "c21f969b5f",
            "name": "Default / New Task Story.",
            "maxObjectives": 3,
            "gid": "c21f969b5f",
            "objectives": [
                {
                    "maxTasks": 3,
                    "name": "new task story with a long name that wraps past first line in a separator",
                    "oid": "c21f969b5f.c9ec52c702",
                    "tasks": [
                        {
                            "status": "in progress",
                            "name": "live in the moment",
                            "detail": "Do the right thing for the moment now!",
                            "tid": "c21f969b5f.c9ec52c702.0eeac89fb5"
                        },
                        {
                            "status": "todo",
                            "name": "think about the future",
                            "detail": "We always want a plan for our ideals, even if the plan has to change.",
                            "tid": "c21f969b5f.c9ec52c702.d06267f230"
                        },
                        {
                            "status": "todo",
                            "name": "another task",
                            "detail": "There is always more work to todo.",
                            "tid": "c21f969b5f.c9ec52c702.e34beb1074"
                        },
                        {
                            "status": "todo",
                            "name": "yet another task",
                            "detail": "We need to play some times.",
                            "tid": "c21f969b5f.c9ec52c702.5103dd140c"
                        },
                        {
                            "status": "todo",
                            "name": "yet another another task",
                            "detail": "Time to rest.   I'm exhausted.",
                            "tid": "c21f969b5f.c9ec52c702.92292d0f87"
                        }
                    ]
                },
                {
                    "maxTasks": 1,
                    "name": "A second story",
                    "oid": "c21f969b5f.c9ec52d813",
                    "tasks": [
                        {
                            "status": "todo",
                            "name": "Deja Vu",
                            "detail": "Same right things again!",
                            "tid": "c21f969b5f.c9ec52d813.9ffbd900c6"
                        },
                        {
                            "status": "todo",
                            "name": "Do over another another task",
                            "detail": "Time to sleep.  I'm faded.",
                            "tid": "c21f969b5f.c9ec52d813.03303ea097"
                        }
                    ]
                }
            ]
        },
    
        {
                    "_id": "c32f070b6f",
                    "name": "Be awesome Full Stacker",
                    "maxObjectives": 1,
                    "gid": "c327777777",
                    "objectives": [
                        {
                            "maxTasks": 3,
                            "name": "Server side Python",
                            "oid": "c32777777.c0eaaaaaa0",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Get DePaul to list CSC438",
                                    "detail": "Need a middle tier cours for APIs.  Python would be fun",
                                    "tid": "c32777777.c0eaaaaaa0.0eeac89fa1"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "Web Client 1",
                            "oid": "c32777777.c0eaaaaaa1",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Angular",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa1.0eeac89fa2"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "Web Client 2",
                            "oid": "c32777777.c0eaaaaaa2",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "React Native",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa2.0eeac89fa3"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "Android 1",
                            "oid": "c32777777.c0eaaaaaa3",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Java",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa3.0eeac89fa4"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "Android 2",
                            "oid": "c32777777.c0eaaaaaa4",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Kotlin",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa4.0eeac89fa6"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "iOS 1 class ",
                            "oid": "c32777777.c0eaaaaaa5",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Storyboards",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa5.0eeac89fa7"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "iOS 2 Class",
                            "oid": "c32777777.c0eaaaaaa6",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Swift UI",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa6.0eeac89fa8"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "Data Back end 1",
                            "oid": "c32777777.c0eaaaaaa7",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Mongo and Spark",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa7.0eeac89fa0"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "Data Back end 2",
                            "oid": "c32777777.c0eaaaaaa8",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "RDBMS and Hadoop",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa8.0eeac89fa9"
                                }
                            ]
                        },
                        {
                            "maxTasks": 3,
                            "name": "Transport messaging 1",
                            "oid": "c32777777.c0eaaaaaa9",
                            "tasks": [
                                {
                                    "status": "in progress",
                                    "name": "Tibco and Kafka",
                                    "detail": "",
                                    "tid": "c32777777.c0eaaaaaa9.0eeac89f11"
                                }
                            ]
                        }
                    ]
            },

    
    
            {
                "_id": "c32f070b6f",
                "name": "Be Excellent to each other my friends, for in the long run it will all be righteous",
                "maxObjectives": 1,
                "gid": "c32f070b6f",
                "objectives": [
                    {
                        "maxTasks": 3,
                        "name": "Bill story",
                        "oid": "c32f070b6f.c0ec63c813",
                        "tasks": [
                            {
                                "status": "in progress",
                                "name": "Fix Phone Booth",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c813.0eeac89fa5"
                            },
                            {
                                "status": "todo",
                                "name": "Grab Dad's keys",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c813.d06267f23b"
                            },
                            {
                                "status": "todo",
                                "name": "Prepare report",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c813.e34beb10c4"
                            },
                            {
                                "status": "todo",
                                "name": "Gather all the friends",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c813.5103dd140d"
                            },
                            {
                                "status": "todo",
                                "name": "Form Wyld Stalyon",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c813.92292d0fe7"
                            }
                        ]
                    },
                    {
                        "maxTasks": 3,
                        "name": "Ted story",
                        "oid": "c32f070b6f.c0ec63c8ed",
                        "tasks": [
                            {
                                "status": "in progress",
                                "name": "Rescue Princess",
                                "detail": "She is imprisoned in the tower.",
                                "tid": "c32f070b6f.c0ec63c8ed.0eeac89fbf"
                            },
                            {
                                "status": "todo",
                                "name": "Thank Rufus",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c8ed.d06267f23a"
                            },
                            {
                                "status": "todo",
                                "name": "Clean up Napoleon",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c8ed.e34beb10b4"
                            },
                            {
                                "status": "todo",
                                "name": "Recruit Billy The Kidd",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c8ed.5103dd14cc"
                            },
                            {
                                "status": "todo",
                                "name": "Grab Abe Lincoln.",
                                "detail": "",
                                "tid": "c32f070b6f.c0ec63c8ed.92292d0fd7"
                            }
                        ]
                    }
                ]
            },
            {
                "_id": "c32f070aaa",
                "name": "Find Grail",
                "maxObjectives": 1,
                "gid": "c32f070aaa",
                "objectives": [
                    {
                        "maxTasks": 3,
                        "name": "Arthur story",
                        "oid": "c32f070aaa.c0ec63cbbb",
                        "tasks": [
                            {
                                "status": "todo",
                                "name": "Visit French",
                                "detail": "",
                                "tid": "c32f070aaa.c0ec63cbbb.5103dd140d"
                            },
                            {
                                "status": "in progress",
                                "name": "Argue with peasants",
                                "detail": "",
                                "tid": "c32f070aaa.c0ec63cbbb.0eeac89fa5"
                            },
                            {
                                "status": "todo",
                                "name": "Convict witch",
                                "detail": "",
                                "tid": "c32f070aaa.c0ec63cbbb.d06267f23b"
                            },
                            {
                                "status": "todo",
                                "name": "Fight Knight",
                                "detail": "",
                                "tid": "c32f070aaa.c0ec63cbbb.e34beb10c4"
                            }
                        ]
                    },
                    {
                        "maxTasks": 3,
                        "name": "Galahad story",
                        "oid": "c32f070aaa.c0ec63cccc",
                        "tasks": [
                            {
                                "status": "in progress",
                                "name": "Punish Zoot",
                                "detail": "She is imprisoned in the tower.",
                                "tid": "c32f070aaa.c0ec63cccc.0eeac89fbf"
                            },
                            {
                                "status": "todo",
                                "name": "Pick up Shrubbery",
                                "detail": "Theres a guy, Rodger who arranges and designs them",
                                "tid": "c32f070aaa.c0ec63cccc.d06267f23a"
                            },
                            {
                                "status": "todo",
                                "name": "Return to 3 headed guy with shrubberies",
                                "detail": "",
                                "tid": "c32f070aaa.c0ec63cccc.e34beb10b4"
                            }
                        ]
                    }
                ]
            },
            {
                "_id": "c32f090abc",
                "name": "Win Championship",
                "maxObjectives": 1,
                "gid": "c32f090abc",
                "objectives": [
                    {
                        "maxTasks": 3,
                        "name": "Enter Tourney",
                        "oid": "c32f090abc.c0ec63cdef",
                        "tasks": [
                            {
                                "status": "todo",
                                "name": "Win 6 games in a row.",
                                "detail": "Defeat everybody in field of 66 teams",
                                "tid": "c32f090abc.c0ec63cdef.5103dd1123"
                            }
                        ]
                    }
                ]
            }
        ]
    }
    """
let effortDomainData = effortDomainJsonString.data(using: .utf8)!
var testEffortDomain: EffortDomain  = try! JSONDecoder().decode(EffortDomain.self, from: effortDomainData)
//print(effortDomain)

let appStateJsonString =
"""
{
"currentGSlot": 0,
"currentOSlot": 0
}
"""
let appStateData = appStateJsonString.data(using: .utf8)!
let appState: AppState = try! JSONDecoder().decode(AppState.self, from: appStateData)

//let dummyDataEffortDomainAppState = EffortDomainAppState(effortDomain: &effortDomain, appState: &appState)
