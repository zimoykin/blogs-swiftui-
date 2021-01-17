//
//  travelApp.swift
//  travel
//
//  Created by Дмитрий on 17.01.2021.
//

import SwiftUI

@main
struct travelApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
