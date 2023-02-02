//
//  loginView.swift
//  project400
//
//  Created by Omar Alshuaili on 08/12/2022.
//

import SwiftUI

struct loginView: View {
    @StateObject var otpModel : OTPViewModel = .init()
    @ObservedObject  var SinginVM = SinginViewModel()
    @StateObject private var keyBoardHandler = KeyBoardHandler()
    @State private var isEmailFocused: Bool = false
    @State private var showError : Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment:.bottom){
            
            Color(red: 251/256, green: 252/256, blue: 253/256)
                .ignoresSafeArea(.all)
            
            
            
            
            VStack(alignment:.leading, spacing: 20){
                
                
                
                
                Text("What's your phone number?")
                    .font(Font.custom("Gilroy-Meduim", size: 28))
                    .padding(.leading,-5)
                    .foregroundColor(.black)
                
                
                
                
                
                
                HStack(spacing: 15) {
                    TextField("+353", text: $SinginVM.code, onEditingChanged: { (editingChanged) in
                        isEmailFocused = editingChanged
                        
                    })
                    
                    .textFieldStyle(TappableTextFieldStyle())
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke((isEmailFocused || !SinginVM.email.isEmpty) && !SinginVM.isEmailValid() ? .red: .black,lineWidth: (!SinginVM.isEmailValid() && !SinginVM.email.isEmpty) || (!SinginVM.email.isEmpty && SinginVM.isEmailValid()) ? 1.3 : 0 )
                        
                )
                    .frame(width: 90)

                    
                    
                    TextField("Your phone number", text: $SinginVM.phonenumber, onEditingChanged: { (editingChanged) in
                        isEmailFocused = editingChanged
                        
                    })
                    
                    
                    .textFieldStyle(TappableTextFieldStyle())
                    .tracking(1)
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke((isEmailFocused || !SinginVM.email.isEmpty) && !SinginVM.isEmailValid() ? .red: .black,lineWidth: (!SinginVM.isEmailValid() && !SinginVM.email.isEmpty) || (!SinginVM.email.isEmpty && SinginVM.isEmailValid()) ? 1.3 : 0 )
                        
                )
                    
                
            
                }
               
                
                
                Button {
                    Task{ await SinginVM.sendOTP() }

                } label: {
                    ZStack{
                        Text(SinginVM.isLoading ? "loading" : "Continue")
                            .frame(maxWidth:   .infinity)
                            .padding(18)
                            .background(SinginVM.isEmailValid() ? .black : .clear)
                        
                            .foregroundColor(SinginVM.isEmailValid() ? .white : .black)
                            .font(.system(size: 21))
                            .fontWeight(.semibold)
                        
                        
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(SinginVM.isEmailValid() ? .clear : .black,lineWidth: 1.3)
                                
                                
                            ).cornerRadius(10)
                            
                        ProgressView().opacity(SinginVM.isLoading ? 1 : 0)
                        
                    }
                       
                
                } .disabled(!isValid() || SinginVM.isLoading)
                    
                
                    
                    
                
                
                
                
                
                
                Spacer()
                
                
                HStack{
                    Button(action: {
                        dismiss()
                        
                    })
                    {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(.white)
                            .frame(width: 50,height: 50)
                            .background(.black)
                            .cornerRadius(25)
                        
                        
                        
                        
                    }
                    
                }
                
            } //vstack
            .padding()
            .navigationBarBackButtonHidden()
        
            
        } //Zstack
        .background{
            NavigationLink( tag: "VERIFICATION", selection: $SinginVM.navigationTag){
                otpView()
                    .environmentObject(SinginVM)
                
            }label: {
                
            }.labelsHidden()
            
            
        }.alert(SinginVM.errMes, isPresented: $SinginVM.showAlert){}
        .ignoresSafeArea(.keyboard)
        
        
        
       
        
        
        
    }
    
    func isValid()->Bool{

        if(SinginVM.isEmailValid() && !SinginVM.phonenumber.isEmpty){
//            showError.toggle()
            return true
        }
   
            return false

        
    }
    
    
    
    
    struct TappableTextFieldStyle: TextFieldStyle {
        @ObservedObject  var SinginVM = SinginViewModel()
        func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding(18)
                .ignoresSafeArea(.keyboard)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .keyboardType(.numberPad)
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.908))
                .cornerRadius(10)
            
            
        }
    }
    
    
    struct loginView_Previews: PreviewProvider {
        static var previews: some View {
            loginView()
        }
    }
    
    
    
}
