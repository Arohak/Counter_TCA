//
//  MyApp.swift
//  Counter
//
//  Created by Ara Hakobyan on 1/8/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct MyApp: App {
//    static let store = Store(initialState: MainFeature.State()) {
//        MainFeature()
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            MainView(store: MyApp.store)
//        }
//    }
    
    static let store = Store(
        initialState: ContactsFeature.State(
            contacts: [
                Contact(id: UUID(), name: "Blob"),
                Contact(id: UUID(), name: "Blob Jr"),
                Contact(id: UUID(), name: "Blob Sr"),
            ]
        )
    ) {
        ContactsFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            ContactsView(store: MyApp.store)
        }
    }
}
