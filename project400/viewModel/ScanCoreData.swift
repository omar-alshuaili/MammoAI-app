import Foundation
import CoreData

class ScanCoreData: ObservableObject {
    @Published private(set) var container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "MyScan")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
        }
    }
}
