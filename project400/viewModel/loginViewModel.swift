//
//  loginViewModel.swift
//  project400
//
//  Created by Omar Alshuaili on 08/12/2022.
//

import Foundation
import FirebaseAuth
import SwiftUI


class SinginViewModel: ObservableObject {
    @Published var password = ""
    @Published var email = ""
    @Published var otpText : String = ""
    @Published var code : String = ""
    @Published var phonenumber : String = ""
    @Published var otpFields : [String] = Array(repeating: "", count: 6)


    // MARK: error
    @Published var showAlert : Bool = false
    @Published var errMes : String = ""

    // MARK: otp credentials
    @Published var verificationCode : String =  ""
    
    @Published var isLoading : Bool =  false
    @Published var navigationTag : String?

    
    @AppStorage("log_status") var log_status = false
    @AppStorage("user_id") var Loged_user_id = ""

    // MARK: - enum for FireBase Error
    
    
    
    // MARK: - Validation Function
    
    //    func isPasswordValid() -> Bool {
    //        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
    //
    //        return passwordTest.evaluate(with: password)
    //    }
    
    func isEmailValid() -> Bool {
        //        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        //
        //        return emailTest.evaluate(with: email)
        return true
    }
    
    func caLogIn() -> Bool {
        ( !password.isEmpty && isEmailValid())
    }
    
    
    // MARK: - fireBase Auth
    
    
    

    
    // MARK: sending otp to the user
    func sendOTP()async{
        print(isLoading)
        if isLoading {return}
        do{
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(code)\(phonenumber)", uiDelegate: nil)
            DispatchQueue.main.async {
                self.isLoading = true
                self.verificationCode = result
                self.navigationTag = "VERIFICATION"
               
            }
        }
        catch{
            errorHandling(error: error.localizedDescription)
        }
    }
    
    func errorHandling(error:String){
        DispatchQueue.main.async {
            self.isLoading = false
            self.errMes = error
            self.showAlert.toggle()
            print(error)
        }
    }
    
    func verifyOTP()async{
        do{
            otpText = otpFields.reduce("") { partialResult, value in
               partialResult + value
            }
            
            isLoading = true
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationCode, verificationCode: otpText)
            let _ = try await Auth.auth().signIn(with: credential)
            
            DispatchQueue.main.async {[self] in
                self.isLoading = false
                log_status = true
                self.navigationTag = "HOME"
                guard let user_id = Auth.auth().currentUser?.uid else { return}
                Loged_user_id =  user_id  
            }
        }
        catch{
            errorHandling(error: error.localizedDescription)
        }
    }
    
    func logOut() {
        log_status = false
    }
    
    
    
    
    
}
