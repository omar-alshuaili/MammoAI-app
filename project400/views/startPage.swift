//
//  startPage.swift
//  project400
//
//  Created by Omar Alshuaili on 08/12/2022.
//

import SwiftUI

struct startPage: View {
    @State private var isActive = false
    @State var showingLogin = false
    @State var showingSignUp = false
    var body: some View {
        //        let headerFont = Font.custom(FontNameManager.DMSans.bold, size: 28)
        
        NavigationView {
            ZStack(alignment: .top) {
                Color(red: 251/256, green: 252/256, blue: 253/256)
                    .ignoresSafeArea(.all)
                
                
                
                
                VStack(spacing: 20) {
                    Spacer()
                    Image("medicine")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 320)
                    
                    Spacer()
                    
                    
                    VStack(spacing: 10) {
                        Text("Therapy & Care")
                            .font(Font.custom("Gilroy-Bold", size: 40))
                            .foregroundColor(Color(hue: 0.592, saturation: 0.741, brightness: 0.212))
                        
                        Text("Your health at the tip of your finger")
                            .foregroundColor(.black)
                            .font(Font.custom("Gilroy-Medium", size: 17))
                    }
                    .padding()
                    
                    
                    
                    NavigationLink(destination: signupView()) {
                        
                        Text("Get started")
                            .frame(maxWidth: .infinity , maxHeight:  20)
                            .font(Font.custom("Gilroy-Bold", size: 18))
                            .padding(20)
                            .foregroundColor(.white)
                        
                        
                    }
                    
                    .background(Color(hue: 0.592, saturation: 0.741, brightness: 0.212))
                    .cornerRadius(18)
                    
                    
                    
                    NavigationLink(destination: loginView())
                    {
                        Text("I already have an account")
                            .frame(maxWidth: .infinity , maxHeight:  20)
                            .foregroundColor(CustomColor.primary)
                            .font(Font.custom("Gilroy-Bold", size: 16))
                            .padding(20)
                            .background(Color(red: 0.918, green: 0.938, blue: 0.933))
                            .cornerRadius(18)
                            .opacity(0.6)
                    }
                    
                    
                    Spacer()
                    
                    
                    
                    
                }
                
                
                
                .padding()
                .frame(maxHeight: .infinity)
                
                
                
                
                
            }
            
            
        }
        
        
        
        
    }
}

struct CustomColor {
    static let primary = Color("primary")
    
}

struct startPage_Previews: PreviewProvider {
    static var previews: some View {
        startPage()
    }
}
