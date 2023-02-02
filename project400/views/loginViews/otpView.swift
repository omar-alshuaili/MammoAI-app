//
//  otpView.swift
//  project400
//
//  Created by Omar Alshuaili on 09/12/2022.
//

import SwiftUI

struct otpView: View {
    @EnvironmentObject var loginViewModel : SinginViewModel
    @FocusState var activeField : otpField?
    var fieldColorNotActive = Color(red: 240/256, green: 240/256, blue: 240/256)
    
    
    
    var body: some View {
        
        ZStack {
            VStack {
                otpFiel()
                
                Button {
                    Task{await loginViewModel.verifyOTP()}
                }
                
            label: {
                
                Text("Continue")
                    .frame(maxWidth:   .infinity)
                    .padding(18)
                    .background(checkState() ? .black : .clear)
                
                    .foregroundColor(checkState() ? .white : .gray)
                    .font(.system(size: 21))
                    .fontWeight(.semibold)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(checkState() ? .clear : .black,lineWidth: 1.3)
                        
                    ).opacity(checkState() ? 1:0.6)
                    .cornerRadius(10)
            }
                    
                
            }
            .padding()
            .frame(maxHeight: .infinity,alignment: .top)
            .navigationTitle("Verification")
            .onChange(of: loginViewModel.otpFields) { newValue in
                otpValidation(value: newValue)
            }
        .alert(loginViewModel.errMes, isPresented: $loginViewModel.showAlert){}
        }
        .background{
            NavigationLink( tag: "HOME", selection: $loginViewModel.navigationTag){
                homeView()
                    .environmentObject(loginViewModel)
                
            }label: {
                
            }.labelsHidden()
            
            
        }.alert(loginViewModel.errMes, isPresented: $loginViewModel.showAlert){}
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden()
        
    }
    
    func checkState()->Bool {
        for index in 0..<6{
            if loginViewModel.otpFields[index].isEmpty { return false}
        }
        return true
    }
    
    // MARK: otp fields validation
    func otpValidation(value : [String]) {
        for index in 0..<6{
            if value[index].count == 6 {
                DispatchQueue.main.async {
                    loginViewModel.otpText = value[index]
                    loginViewModel.otpFields[index] = ""
                    
                    //updating text field with value
                    
                    for item in loginViewModel.otpText.enumerated(){
                        loginViewModel.otpFields[item.offset] = String(item.element)
                    }
                }
                return
            }
        }
        
        // moving to next field
        for index in 0..<5{
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        //moving back if current field is empty and the previous one is not
        for index in 1...5{
            if value[index].isEmpty  && !value[index - 1].isEmpty {
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        
        
        for index in 0..<6{
            if value[index].count > 1{
                loginViewModel.otpFields[index] = String(value[index].last!)
            }
        }
    
       
            
        
    }
    
    // MARK: otp fields
    @ViewBuilder
    func otpFiel()->some View {
        HStack(spacing: 5){
            ForEach(0..<6,id: \.self) { index in
                VStack(spacing:8){
                    TextField("",  text: $loginViewModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField,equals: activeStateForIndex(index: index))
                        .frame(width: 60, height: 70)
                        .background(loginViewModel.otpFields[index].isEmpty ?
                                    fieldColorNotActive : .clear
                                    
                        )
                        .cornerRadius(8)
                        .overlay(
                            
                            RoundedRectangle(cornerRadius: 8.0).stroke(
                                !loginViewModel.otpFields[index].isEmpty ? fieldColorNotActive : .clear
                            )
                            
                            
                        )
                    
                    
                }.frame(maxWidth:  .infinity)
                
                
                
            }
            
        }
        
    }
    
    func activeStateForIndex(index: Int) -> otpField {
        switch index {
        case 0 : return .field1
        case 1 : return .field2
        case 2 : return .field3
        case 3 : return .field4
        case 4 : return .field5
        default: return .field6
        }
    }
}



struct otpView_Previews: PreviewProvider {
    static var previews: some View {
        otpView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


// MARK: focus state enum

enum otpField {
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6

    
}
