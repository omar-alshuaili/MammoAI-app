//
//  NewAppointmentView.swift
//  project400
//
//  Created by Omar Alshuaili on 28/04/2023.
//

import SwiftUI
import FirebaseStorage
import UniformTypeIdentifiers
import UIKit
import MobileCoreServices



struct NewAppointmentView: View {
    @ObservedObject private var viewModel = NewPatientViewModel()
    @ObservedObject private var AppointmentviewModel = AppointmentViewModel()
    @State private var date = Calendar.current.startOfDay(for: Date())
    @State private var time = Calendar.current.startOfDay(for: Date())
    
    @AppStorage("user_id") private var doctorId: String = ""
    @State private var showPDFPicker = false
    @State private var pdfData: Data?
    
    var body: some View {
        VStack(alignment:.leading) {
            Text("Add new appointment")
                .fontWeight(.bold)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding(.top,25)
            VStack {
                TextField("Search for patient", text: $viewModel.searchText)
                    .frame(height: 70)
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                    .font(.system(size: 18))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 1))
                    .onSubmit {
                        viewModel.searchPatientByPhoneNumber(phoneNumber: viewModel.searchText)
                    }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .offset(x: -UIScreen.main.bounds.width + 200)
                }
            }
            
            if let patient = viewModel.currentPatient {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 75)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .font(.system(size: 18))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 1))
                    
                    HStack {
                        Image("avatar \(patient.avatar )")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Spacer()
                        Image(systemName: "person.fill")
                        Text(patient.name)
                        Spacer()
                        Image(systemName: "phone.fill")
                        Text(patient.phoneNumber)
                    }
                    .padding()
                }
            }
            
            Text("Choose appointment date and time")
                .fontWeight(.bold)
                .font(.system(size: 20))
            
            DatePicker("Please enter a date", selection: $date, in: Date()..., displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle())
                .environment(\.locale, Locale(identifier: "en_GB"))
                .padding()

            DatePicker("Please enter a time", selection: $time, displayedComponents: [.hourAndMinute])
                
                .environment(\.locale, Locale(identifier: "en_GB"))
                .padding()

            
            Button("Upload PDF") {
                showPDFPicker = true
            }
            .sheet(isPresented: $showPDFPicker) {
                DocumentPicker { result in
                    switch result {
                    case .success(let data):
                        pdfData = data
                    case .failure(let error):
                        print("Error picking document: \(error)")
                    }
                }
            }
            
            Button("Save Appointment") {
                if let phoneNumber = viewModel.currentPatient?.phoneNumber {
                    if let pdfData = pdfData {
                        uploadPDF(pdfData) { result in
                            switch result {
                            case .success(let pdfURL):
                                AppointmentviewModel.saveAppointment(doctorId: doctorId, patient: phoneNumber, date: date, time: time, pdfURL: pdfURL) { result in
                                    switch result {
                                    case .success:
                                        print("Appointment saved")
                                    case .failure(let error):
                                        print("Error saving appointment: \(error)")
                                    }
                                }
                            case .failure(let error):
                                print("Error uploading PDF: \(error)")
                            }
                        }
                    } else {
                        AppointmentviewModel.saveAppointment(doctorId: doctorId, patient:                         phoneNumber, date: date, time: time, pdfURL: nil) { result in
                            switch result {
                            case .success:
                                print("Appointment saved")
                                AppointmentviewModel.fetchData {
                                    
                                }
                            case .failure(let error):
                                print("Error saving appointment: \(error)")
                            }
                        }
                    }
                } else {
                    print("No patient selected")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    func uploadPDF(_ data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let pdfRef = storageRef.child("pdfs/\(UUID().uuidString).pdf")

        pdfRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                print(
                completion(.failure(error))
                )
                return
            }

            pdfRef.downloadURL { url, error in
                if let error = error {
                    print(
                    completion(.failure(error))
                    )
                } else if let url = url {
                    print(
                    completion(.success(url.absoluteString)))
                }
            }
        }
    }


}

struct NewAppointmentView_Previews: PreviewProvider {
    static var previews: some View {
        NewAppointmentView()
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    private let completionHandler: (Result<Data, Error>) -> Void
    
    init(completionHandler: @escaping (Result<Data, Error>) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completionHandler: completionHandler)
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        private let completionHandler: (Result<Data, Error>) -> Void
        
        init(completionHandler: @escaping (Result<Data, Error>) -> Void) {
            self.completionHandler = completionHandler
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                completionHandler(.failure(NSError(domain: "No document selected", code: -1, userInfo: nil)))
                return
            }
            
            // Start accessing the security scoped resource
            let shouldStopAccessing = url.startAccessingSecurityScopedResource()

            defer {
                if shouldStopAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            do {
                let data = try Data(contentsOf: url)
                completionHandler(.success(data))
            } catch {
                completionHandler(.failure(error))
            }
        }

        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completionHandler(.failure(NSError(domain: "Document picker was cancelled", code: -1, userInfo: nil)))
        }
    }
}
