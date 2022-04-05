//
//  quizlet_ishApp.swift
//  quizlet-ish
//
//  Created by Jordan Yee on 4/4/22.
//

import SwiftUI
import Firebase

@main
struct quizlet_ishApp: App {
    
    init() {
        FirebaseApp.configure()
        AuthenticationService.signIn()
      }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
