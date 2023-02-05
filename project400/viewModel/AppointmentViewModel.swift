import Foundation
import FirebaseFirestore

class AppointmentViewModel: ObservableObject {
  @Published var appointments = [Appointment]()
  
  private var db = Firestore.firestore()
    init(){
        fetchData()
    }
    func fetchData() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.appointments.removeAll()
            let db = Firestore.firestore()
            let ref = db.collection("appointments")
            ref.getDocuments { snapshot, error in
                guard error == nil else{
                    print(error!.localizedDescription)
                    return
                }
                if let snapshot = snapshot {
                    for doc in snapshot.documents{
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let phoneNo = data["phoneNo"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let date = data["date"] as? String ?? ""
                        let time = data["time"] as? String ?? ""
                        let details = data["details"] as? String ?? ""
                        
                        let appointment = Appointment(id: doc.documentID, name: name, date: date, time:time, phoneNo: phoneNo, details: details)
                        self.appointments.append(appointment)
                    }
                }
            }
            
//        }

        
    }
    
    func delete(doc:String, completion: @escaping () -> Void) {
        let docRef = db.collection("appointments").document(doc)
        docRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully")
                completion()

            }
        }
    }

    
}
