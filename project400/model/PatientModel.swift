//
//  Patient.swift
//  project400
//
//  Created by Omar Alshuaili on 25/04/2023.
//

import Foundation
struct Patient: Codable,Hashable {
    let name: String
    let age: String
    let phoneNumber: String
    let avatar: Int
    
    
    init?(dictionary: [String: Any]) {
        guard let avatar = dictionary["avatar"] as? Int,
              let name = dictionary["name"] as? String,
              let age = dictionary["age"] as? String,
              let phoneNumber = dictionary["phone"] as? String
        else {
            return nil
        }
        
        self.avatar = avatar
        self.name = name
        self.age = age
        self.phoneNumber = phoneNumber
    }
}
