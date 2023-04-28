//
//  mainView.swift
//  project400
//
//  Created by Omar Alshuaili on 25/04/2023.
//

import SwiftUI

struct mainView: View {
    @State var currentView: AnyView = AnyView(homeView())
    @Environment(\.isBottomBarVisible) var isBottomBarVisible
    @StateObject var viewModel = AppointmentViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    currentView
                    Spacer()
                }
                VStack {
                    Spacer()
                    if isBottomBarVisible {
                        BottomBar(currentView: $currentView)
                    }
                }
            }
        }.environmentObject(viewModel)
    }
    func changeView<Content: View>(_ view: Content) {
        currentView = AnyView(view)
    }
}

struct mainView_Previews: PreviewProvider {
    static var previews: some View {
        mainView()
    }
}
