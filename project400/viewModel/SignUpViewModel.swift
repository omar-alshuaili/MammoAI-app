//
//  SignUpViewModel.swift
//  project400
//
//  Created by Omar Alshuaili on 09/12/2022.
//

import Foundation
import FirebaseAuth


enum FBError:Error,Identifiable {
    case error(String)
    var id: UUID{
        UUID()
    }
    
    var errorMessage: String {
        switch self {
        case .error(let message):
            return message
        }
    }
    
}

class SingUpViewModel: ObservableObject {
    @Published var password = ""
    @Published var email = ""
    @Published var errorMessage: String?
    
    // MARK: - enum for FireBase Error
    
    
    
    // MARK: - Validation Function
    
    func isPasswordValid() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}$")
        
        return passwordTest.evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        
        return emailTest.evaluate(with: email)
    }
    
    func caLogIn() -> Bool {
        ( isPasswordValid() && isEmailValid())
    }
    
   
    
    // MARK: - fireBase Auth
    
    func signUp(email: String, password: String, completion: @escaping (Result<Bool, FBError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(.error(error.localizedDescription)))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            }
        }
    }
    
}



