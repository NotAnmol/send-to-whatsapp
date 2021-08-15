//
//  WhatsAppMeApp.swift
//  WhatsAppMe
//
//  Created by Anmol Jain on 15/08/21.
//

import SwiftUI

@main
struct WhatsAppMeApp: App {
    let persistenceController = PersistenceController.shared
	@Environment(\.scenePhase) var scenePhase
	
    var body: some Scene {
        WindowGroup {
			NavigationView {
				ContentView()
					.environment(\.managedObjectContext, persistenceController.container.viewContext)
			}
        }
		.onChange(of: scenePhase) { _ in
			persistenceController.save()
		}
    }
}
