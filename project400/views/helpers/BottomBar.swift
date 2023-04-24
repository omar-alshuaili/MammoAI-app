//
//  BottomBar.swift
//  project400
//
//  Created by Omar Alshuaili on 06/03/2023.
//

import SwiftUI

struct BottomBar: View {
    @State private var isShowingSquareCamera = false
    @State private var fullWidthIcon1 : Bool = false
    @State private var fullWidthIcon2 : Bool = false
    @State private var fullWidthIcon3 : Bool = false
    @State private var fullWidthIcon4 : Bool = false
    
    var body: some View {
        HStack(spacing: 15){
            
            Button {
                withAnimation(.easeInOut) {
                    fullWidthIcon1 = true
                    fullWidthIcon2 = false
                    fullWidthIcon3 = false
                    fullWidthIcon4 = false
                    
                }
                
            } label: {
                HStack {
                    Image("home-icon")
                        .resizable()
                        .frame(width: 25,height: 25)
                    if(fullWidthIcon1){
                        Text("Home")
                            .font(Font.custom("Poppins Bold", size: 14))
                            .foregroundColor(.white)
                    }
                }
                
            }
            
            .padding()
            .background(!fullWidthIcon1 ? .clear : Color(red: 0.24313725490196078, green: 0.23921568627450981, blue: 0.25098039215686274))
            .cornerRadius(30)
            
            
            
            Button {
                withAnimation(.easeInOut) {
                    fullWidthIcon1 = false
                    fullWidthIcon2 = true
                    fullWidthIcon3 = false
                    fullWidthIcon4 = false
                }
                
            } label: {
                HStack {
                    Image("appointments-icon")
                        .resizable()
                        .frame(width: 25,height: 25)
                    if(fullWidthIcon2){
                        Text("Calander")
                            .font(Font.custom("Poppins Bold", size: 12))
                            .foregroundColor(.white)
                    }
                }
                
            }
            
            .padding()
            .background(!fullWidthIcon2 ? .clear : Color(red: 0.24313725490196078, green: 0.23921568627450981, blue: 0.25098039215686274))
            .cornerRadius(30)
            
            
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
            
            
            
            Button {
                withAnimation(.easeInOut) {
                    fullWidthIcon1 = false
                    fullWidthIcon2 = false
                    fullWidthIcon3 = true
                    fullWidthIcon4 = false
                }
                
            } label: {
                HStack {
                    Image("scan-icon")
                        .resizable()
                        .frame(width: 25,height: 25)
                    if(fullWidthIcon3){
                        Text("Scans")
                            .font(Font.custom("Poppins Bold", size: 12))
                            .foregroundColor(.white)
                    }
                }
                
            }
            
            .padding()
            .background(!fullWidthIcon3 ? .clear : Color(red: 0.24313725490196078, green: 0.23921568627450981, blue: 0.25098039215686274))
            .cornerRadius(30)
            
            
            
            
            
            
            
            
            
            Button {
                withAnimation(.easeInOut) {
                    fullWidthIcon1 = false
                    fullWidthIcon2 = false
                    fullWidthIcon3 = false
                    fullWidthIcon4 = true
                }
                
            } label: {
                HStack {
                    Image("user-icon")
                        .resizable()
                        .frame(width: 20,height: 20)
                    if(fullWidthIcon4){
                        Text("Profile")
                            .font(Font.custom("Poppins Bold", size: 14))
                            .foregroundColor(.white)
                    }
                }
                
            }
            
            .padding()
            .background(!fullWidthIcon4 ? .clear : Color(red: 0.24313725490196078, green: 0.23921568627450981, blue: 0.25098039215686274))
            .cornerRadius(30)
            
            
           
            
        }.frame(maxWidth: .infinity,alignment: .bottom)
            .padding(.vertical)
            .background(Color(red: 0.050980392156862744, green: 0.047058823529411764, blue: 0.058823529411764705))
            .frame(height: 50)

        
        
        
        
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar()
    }
}
