//
//  BasicReminderApp.swift
//  BasicReminder Watch App
//
//  Created by Timothy Andrian on 26/05/24.
//

import SwiftUI
import SwiftData

@main
struct BasicReminder_Watch_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserShift.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
