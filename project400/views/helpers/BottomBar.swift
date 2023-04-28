//
//  BottomBar.swift
//  project400
//
//  Created by Omar Alshuaili on 06/03/2023.
//

import SwiftUI

struct BottomBar: View {
    @State private var isShowingSquareCamera = false
    @State private var selectedButton: String? = nil
    @Binding var currentView: AnyView
    
    var icons = [
        (icon:"home-icon",text:"Home"),
        (icon:"appointments-icon",text:"Calander"),
        (icon:"scan-icon",text:"Scan"),
        (icon:"user-icon",text:"Profile")
    ]
    
    var body: some View {
       
            ZStack{
                HStack{
                    ForEach(icons, id: \.text) { icon in
                        ExtractedView(selectedButton: $selectedButton, text: icon.text, icon: icon.icon, currentView: $currentView)
                    }.frame(maxWidth: .infinity,alignment: .bottom)
                    
                }.frame(maxWidth: .infinity,alignment: .bottom)
                    .padding(.vertical)
                    .background(Color(red: 0.050980392156862744, green: 0.047058823529411764, blue: 0.058823529411764705))
                    .frame(height: 50)
                
                
                
                
                Button(action: { self.isShowingSquareCamera.toggle() }) {
                    
                    Text("+")
                        .font(.system(size: 40))
                }
                .frame(width: 70,height: 70)
                .background(Color(red: 0.3843137254901961, green: 0.48627450980392156, blue: 0.8823529411764706))
                .clipShape(Circle())
                .foregroundColor(.white)
                .shadow(radius: 5)
                .offset(y:-50)
                
                .sheet(isPresented: $isShowingSquareCamera) {
                    
                    SquareCameraWrapperView()
                        .padding()
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                        .ignoresSafeArea(.keyboard)
                    
                }
                
            }
            
        
        
        
    }
}

struct ExtractedView: View {
    
    
    @Binding var selectedButton: String?
        var text: String
        var icon: String
    @Binding var currentView: AnyView

    
    var isSelected: Binding<Bool> {
            Binding(
                get: { text == selectedButton },
                set: { newValue in
                    if newValue {
                        selectedButton = text
                    } else if text == selectedButton {
                        selectedButton = nil
                    }
                }
            )
        }
    

    var body: some View {
       
            Button {
                withAnimation(.easeInOut) {
                    isSelected.wrappedValue = true
                    updateCurrentView()
                }
                
            } label: {
                HStack {
                    Image(icon)
                        .resizable()
                        .frame(width: 25,height: 25)
                    if isSelected.wrappedValue {
                        Text(text)
                            .font(Font.custom("Poppins Bold", size: 14))
                            .foregroundColor(.white)
                    }
                }.frame(width: isSelected.wrappedValue ? 120 : 10)
                
            }
            
            .padding()
            .background(!isSelected.wrappedValue ? .clear : Color(red: 0.24313725490196078, green: 0.23921568627450981, blue: 0.25098039215686274))
            .cornerRadius(30)
       
    }
    
    private func updateCurrentView() {
            switch text {
            case "Home":
                currentView = AnyView(homeView())
            case "Calander":
                currentView = AnyView(CalendarView())
            case "Scan":
                currentView = AnyView(ScanView())
            default:
                currentView = AnyView(ProfileView())
            }
        }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar( currentView: .constant(AnyView(homeView())))
    }
}

