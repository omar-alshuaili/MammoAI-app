//
//  project400App.swift
//  project400
//
//  Created by Omar Alshuaili on 08/12/2022.
//

import SwiftUI
import FirebaseCore
import CoreData

enum Route: Hashable {
    case login
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async ->
        UIBackgroundFetchResult {
            return .noData
        }

    
}


class PersistenceManager {
    static let shared = PersistenceManager()

    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "MyScan")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}

class Coordinator: ObservableObject {
    @Published var path = [Route]()
}

@main
struct project400: App {
    // register app delegate for Firebase setup
    @StateObject var dataManager = AppointmentViewModel()
    @StateObject var ScansDataManager = ScanCoreData()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .login:
                            signupView()
                        }
                    }
                    .environment(\.managedObjectContext, ScansDataManager.container.viewContext)
            }
            .environmentObject(coordinator)
            .environmentObject(dataManager)
            
        }
    }
}
