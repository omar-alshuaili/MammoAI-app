//
//  otpViewModel.swift
//  project400
//
//  Created by Omar Alshuaili on 10/12/2022.
//


import SwiftUI
import Firebase
class OTPViewModel :ObservableObject {
    @Published var otpText : String = ""
    @Published var otpFields : [String] = Array(repeating: "", count: 6)


    // MARK: error
    @Published var showAlert : Bool = false
    @Published var errMes : String = ""

    // MARK: otp credentials
    @Published var verificationCode : String =  ""
    
    @Published var isLoading : Bool =  false
    @Published var navigationTag : String?

    
    @AppStorage("log_status") var log_status = false
    
    // MARK: sending otp to the user
    func sendOTP()async{
        print(isLoading)
        if isLoading {return}
        do{
            isLoading = true
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber("+353\(833418085)", uiDelegate: nil)
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
            }
        }
        catch{
            errorHandling(error: error.localizedDescription)
        }
    }
}

