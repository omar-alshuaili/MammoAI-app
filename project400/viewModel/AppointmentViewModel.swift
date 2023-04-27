import Foundation
import FirebaseFirestore
import UserNotifications

class AppointmentViewModel: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var searchText = ""
    
    private var db = Firestore.firestore()
    init(){
        
                fetchData()
        
        
//        if let fileLocation = Bundle.main.url(forResource: "data", withExtension: "json") {
//
//            // do catch in case of an error
//            do {
//                let data = try Data(contentsOf: fileLocation)
//                let dataFromJson = try JSONDecoder().decode([Appointment].self,from: data)
//
//                self.appointments = dataFromJson
//            } catch {
//                print(error)
//            }
//        }
        
        
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
                            let isDone = data["isDone"] as? Bool ?? false
    
                            let appointment = Appointment(id: doc.documentID, name: name, date: date, time:time, phoneNo: phoneNo, details: details, isDone: isDone)
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
    
    func todaysAppointment() -> Int {
        let todaysDate = Date.now
        var count = 0
        
        for appointment in appointments {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
            let date = dateFormatter.date(from: appointment.date)
            if   Calendar.current.isDate(todaysDate, equalTo: date!, toGranularity: .day) {
                count += 1
            }
        }
        return count
    }
    
    
    
    func isSameTime(time:String) -> Bool {
      return true
    }
    
    
    func toggleDone(item: Appointment) {
        let docRef = db.collection("appointments").document(item.id)
        docRef.updateData([
            "isDone": !item.isDone
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                
                // Find the index of the updated appointment in the local list
                if let index = self.appointments.firstIndex(where: { $0.id == item.id }) {
                    
                    // Create a new appointment object with updated isDone value
                    let updatedAppointment = Appointment(
                        id: item.id,
                        name: item.name,
                        date: item.date,
                        time: item.time,
                        phoneNo: item.phoneNo,
                        details: item.details,
                        isDone: !item.isDone
                    )
                    
                    // Replace the old appointment with the updated one
                    self.appointments[index] = updatedAppointment
                }
            }
        }
    }
    
    func searchByName(_ appointment: Appointment) -> Bool {
            guard !searchText.isEmpty else { return true }
            return appointment.name.localizedCaseInsensitiveContains(searchText)
        }

        var filteredAppointments: [Appointment] {
            appointments.filter(searchByName)
        }

    
    
    
}
