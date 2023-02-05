//
//  testView.swift
//  project400
//
//  Created by Omar Alshuaili on 05/02/2023.
//

import SwiftUI






struct testView: View {
    @State var opacity = 0.4

    var body: some View {
                    ScrollView{
                        LazyVStack {

                ForEach(0..<100) { item in
                    Text("Item \(item)")
                        .opacity(opacity)
                        .border(.red.opacity(opacity))
                        .animation(.default.delay(1))
                        .onAppear {
                            withAnimation {
                                self.opacity = 1
                            }
                        }
                }
            }
                    }.frame(height: 100)
        
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
