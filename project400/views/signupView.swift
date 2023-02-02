//
//  signuoView.swift
//  project400
//
//  Created by Omar Alshuaili on 09/12/2022.
//

import SwiftUI

struct signupView: View {
    @ObservedObject  var SingUpVM = SingUpViewModel()
    @StateObject private var keyBoardHandler = KeyBoardHandler()
    @FocusState private var isEmailFocused: Bool
    @EnvironmentObject var coordinator: Coordinator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack{
            
            Color(red: 232/256, green: 226/256, blue: 219/256)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack(alignment: .leading, spacing: 30){
                
                VStack(alignment: .leading,spacing: 5) {
                    Text("Welcome Back,")
                        .font(Font.custom("Gilroy-Bold", size: 39))
                        .padding(.leading,-5)
                        .foregroundColor(CustomColor.primary)
                    Text("Please enter your email.")
                        .foregroundColor(CustomColor.primary)
                        .font(Font.custom("Gilroy-Regular", size: 17))
                }
                
                
                
                
                VStack(alignment: .leading,spacing: 13){
                    Text("Your email address")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                    TextField("Enter Your Email", text: $SingUpVM.email)
                        .textFieldStyle(TappableTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke((SingUpVM.isEmailValid() || SingUpVM.email.isEmpty) && !isEmailFocused ? Color.gray : Color.red, lineWidth: 1.3)
                            
                        )
                        .onTapGesture {
                            print(isEmailFocused)
                            isEmailFocused = !isEmailFocused
                        }
                    
                }
                
                
                
                VStack(alignment: .leading,spacing: 13){
                    Text("Your password")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                    SecureField("Enter Your password", text: $SingUpVM.password)
                        .padding()
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke( SingUpVM.password.isEmpty ? Color.gray : Color.red, lineWidth: 1.3)
                            
                            
                            
                        )
                        .submitLabel(.done)
                    
                    
                }
                if let errorMessage = SingUpVM.errorMessage {
                    Text(errorMessage)
                }
                Button {
                    SingUpVM.signUp(email: SingUpVM.email, password: SingUpVM.password) {result in
                        
                        switch result {
                        case .success(_):
                            coordinator.path.append(.login)
                        case .failure(let error):
                            SingUpVM.errorMessage = error.errorMessage
                        }
                    }
                    
                } label: {
                    Text("Get Started")
                        .frame(maxWidth:   .infinity)
                        .padding()
                        .background(CustomColor.primary)
                        .cornerRadius(15)
                        .padding(.top,20)
                        .foregroundColor(.white)
                        .font(.system(size: 21))
                        .fontWeight(.semibold)
                }
                
                
                
                Spacer()
                
                HStack{
                    Button(action: {
                        dismiss()
                        
                    })
                    {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(Color(hue: 0.435, saturation: 0.528, brightness: 0.292))
                            .frame(width: 50,height: 50)
                            .background(Color(hue: 0.435, saturation: 0.241, brightness: 0.739))
                            .cornerRadius(25)

                        
                        
                        
                    }
                    
                }
                
                
            } //vstack
            .padding()
            .ignoresSafeArea(.keyboard)
            .navigationBarBackButtonHidden()
            
            
            
            
            
        }
        
    }
}




struct TappableTextFieldStyle: TextFieldStyle {
    @ObservedObject  var SinginVM = SinginViewModel()
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .cornerRadius(14)
            .ignoresSafeArea(.keyboard)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .keyboardType(.emailAddress)
        
        
    }
}


struct signupView_Previews: PreviewProvider {
    static var previews: some View {
        signupView()
    }
}
