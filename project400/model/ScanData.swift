//
//  ScanData.swift
//  project400
//
//  Created by Omar Alshuaili on 13/12/2022.
//


import Foundation


struct ScanData:Identifiable {
    var id = UUID()
    let content:String
    
    init(content:String) {
        self.content = content
    }
}
