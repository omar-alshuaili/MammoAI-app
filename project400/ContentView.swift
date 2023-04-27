//
//  ContentView.swift
//  project400
//
//  Created by Omar Alshuaili on 08/12/2022.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var login_status  = false
    var body: some View {
        VStack {
            if login_status {
               mainView()
            }
            else{
                startPage()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
