//
//  ScanCoreData.swift
//  project400
//
//  Created by Omar Alshuaili on 25/04/2023.
//

import Foundation
import CoreData


public class ScanCoreData: ObservableObject {

    let container = NSPersistentContainer(name: "MyScan")
    
    init(){
        container.loadPersistentStores { des, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
        }
    }

}
