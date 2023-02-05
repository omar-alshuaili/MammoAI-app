//
//  patientModel.swift
//  project400
//
//  Created by Omar Alshuaili on 20/01/2023.
//

import Foundation


struct Appointment: Identifiable,Codable,Hashable,Comparable {
    var id: String
    let name: String
    let date: String
    let time: String
    let phoneNo : String
    let details: String
    static func <(lhs: Appointment, rhs: Appointment) -> Bool {
            lhs.name < rhs.name
        }
    static let example = Appointment(id: "1", name: "Omar Alshuaili", date: "12-10-2023", time: "10:30", phoneNo: "0833417414", details: "Normal Check")
}
