import Foundation
import FirebaseFirestore
import UserNotifications
import Combine
import SwiftUI
import FirebaseStorage

class AppointmentViewModel: ObservableObject {
    @Published var appointments = [Appointment]()
    @Published var todaysAppointments = [Appointment]()
    @Published var searchText = ""
    @Published var onlyDone: Bool = false
    @AppStorage("user_id") private var doctorId: String = ""
    @Published var stillLoading = true
    private var db = Firestore.firestore()
    init(){
        
        fetchData {
                // Call GettodaysAppointments() after data has been loaded
                self.GettodaysAppointments()
            self.stillLoading = false
            }
        
        //for testing
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
    
    func fetchData(completion: @escaping () -> Void) {
        self.appointments.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("doctors").document(doctorId).collection("appointments")
        print("fetchData called")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if(snapshot!.documents.count == 0 ){
                completion()
                return
            }
            if let snapshot = snapshot {
                var count = 0
                for doc in snapshot.documents {
                    let data = doc.data()
                    let id = doc.documentID
                    let date = data["date"] as? String ?? ""
                    let time = data["time"] as? String ?? ""
                    let phoneNo = data["patient"] as? String ?? ""
                    let details = data["details"] as? String ?? ""
                    let isDone = data["isDone"] as? Bool ?? false
                    
                    // Fetch the patient with the corresponding phone number
                    let patientsRef = db.collection("doctors").document(self.doctorId).collection("patients").whereField("phone", isEqualTo: phoneNo)
                    patientsRef.getDocuments { snapshot, error in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            return
                        }
                        
                        if let snapshot = snapshot {
                            for doc in snapshot.documents {
                                print(doc.data())
                                let data = doc.data()
                                let name = data["name"] as? String ?? ""
                                let age = data["age"] as? String ?? ""
                                let phoneNumber = data["phone"] as? String ?? ""
                                let avatar = data["avatar"] as? Int ?? 1
                                let patient = Patient(name: name, age: age, phoneNumber: phoneNumber, avatar: avatar)
                                
                                let appointment = Appointment(
                                    id: id,
                                    date: date,
                                    time: time,
                                    phoneNo: patient.phoneNumber,
                                    details: details,
                                    isDone: isDone,
                                    patient: patient
                                )
                                
                                self.appointments.append(appointment)
                            }
                            print("fetchData finished")
                        }
                        count += 1
                        if count == snapshot!.documents.count {
                            completion()
                        }
                    }
                }
            }
        }
    }

    
    
    func delete(doc: String, completion: @escaping () -> Void) {
        let docRef = db.collection("doctors").document(doctorId).collection("appointments").document(doc)
        docRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document deleted successfully")
                self.fetchData {
                    self.GettodaysAppointments()
                    completion()
                }
            }
        }
    }

    
    func todaysAppointment() -> Int {
        let todaysDate = Date.now
        var count = 0
        
        for appointment in appointments {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd'/'MM'/'yyyy'"
            let date = dateFormatter.date(from: appointment.date)
            if   Calendar.current.isDate(todaysDate, equalTo: date ?? Date.now, toGranularity: .day) {
                
                count += 1
            }
        }
        return count
    }
    
    func GettodaysAppointments() {
        print("GettodaysAppointments called")
        let todaysDate = Date.now
        
        for appointment in appointments {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd'/'MM'/'yyyy'"
            let date = dateFormatter.date(from: appointment.date)
            if   Calendar.current.isDate(todaysDate, equalTo: date ?? Date.now, toGranularity: .day) {
               
                todaysAppointments.append(appointment)
            }
        }
        self.stillLoading = false
        
    }
    
    
    
    func isSameTime(time:String) -> Bool {
        return true
    }
    
    
    func toggleDone(item: Appointment) {
        let docRef = db.collection("doctors").document(doctorId).collection("appointments").document(item.id)
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
    
    
    
    
    
    
    
    
    var sortedAppointments: [Appointment] {
        
        print("sorted appointment called")
        var appointments = onlyDone ? self.todaysAppointments.filter { !$0.isDone } : self.todaysAppointments
        print("appointments: " ,appointments.count)
        if !searchText.isEmpty {
            appointments = appointments.filter { $0.patient!.name.localizedCaseInsensitiveContains(searchText) }
        }
        return appointments.sorted()
    }
    
    
    func saveAppointment(doctorId: String, patient: String, date: Date, time: Date, pdfURL: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let appointmentsRef = db.collection("doctors").document(doctorId).collection("appointments")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: time)
        
        var appointmentData: [String: Any] = [
            "patient": patient,
            "date": dateString,
            "time": timeString,
            "pdfURL" : pdfURL,
            "isDone" : false
        ]
        
        if let pdfURL = pdfURL {
            appointmentData["pdfURL"] = pdfURL
        }
        
        appointmentsRef.addDocument(data: appointmentData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
        self.fetchData {
                self.GettodaysAppointments()
            }
    }
    
    
    
}
