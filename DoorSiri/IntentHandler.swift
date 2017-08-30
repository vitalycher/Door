//
//  IntentHandler.swift
//  DoorSiri
//
//  Created by Vitaly Chernysh on 8/28/17.
//  Copyright © 2017 Egor Bozko. All rights reserved.
//

import Intents

class IntentHandler: INExtension, INStartWorkoutIntentHandling {
    
    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
        
        func openGlassDoor() {
            SessionManager.openGlassDoor { _ in
                completion(INStartWorkoutIntentResponse(code: .unspecified, userActivity: nil))
            }
        }
        
        func openIronDoor() {
            SessionManager.openIronDoor { _ in
                completion(INStartWorkoutIntentResponse(code: .unspecified, userActivity: nil))
            }
        }
        
        guard let workoutName = intent.workoutName?.spokenPhrase else {
            openGlassDoor()
            return
        }
        
        if workoutName == SiriVocabulary.ironDoor {
            openIronDoor()
        } else {
            openGlassDoor()
        }
    }

}
