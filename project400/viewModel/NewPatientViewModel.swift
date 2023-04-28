import SwiftUI
import FirebaseFirestore
import Combine

class NewPatientViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var patient: Patient?
    @Published var currentPatient: Patient?
    @Published var searchText = ""
    func addPatient(doctorId: String, avatar: Int, name: String, age: String, phone: String) {
        let newPatient: [String: Any] = [
            "avatar": avatar,
            "name": name,
            "age": age,
            "phone": phone
        ]
        
        db.collection("doctors").document(doctorId).collection("patients").addDocument(data: newPatient) { error in
            if let error = error {
                print("Error adding patient: \(error.localizedDescription)")
            } else {
                print("Patient added successfully")
            }
        }
    }
    
    //function to fetch the patient by phone number
    func searchPatientByPhoneNumber(phoneNumber: String) {
        
        let db = Firestore.firestore()
        @AppStorage("user_id")  var doctorId: String = ""
        db.collection("doctors")
            .document(doctorId)
            .collection("patients")
            .whereField("phone", isEqualTo: phoneNumber)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let document = querySnapshot?.documents.first {
                        let patient = Patient(name: document["name"] as? String ?? "",
                                              age: document["age"] as? String ?? "",
                                              phoneNumber: document["phone"] as? String ?? "",
                                              avatar: document["avatar"] as? Int ?? 1)
                        self.currentPatient = patient
                        
                    } else {
                        print("No patient found with the provided phone number.")
                        print("Doctor ID: \(doctorId)")
                        print("Phone Number: \(phoneNumber)")
                    }
                }
            }
    }
    
    
    
}
