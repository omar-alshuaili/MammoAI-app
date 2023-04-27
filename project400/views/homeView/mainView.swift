//
//  mainView.swift
//  project400
//
//  Created by Omar Alshuaili on 25/04/2023.
//

import SwiftUI

struct mainView: View {
    @State private var currentView: AnyView = AnyView(homeView())
    var body: some View {
        NavigationView {
                   VStack {
                       currentView
                       Spacer()
                       BottomBar(currentView: $currentView)
                   }
               }
           }
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView()
    }
}
