//
//  uploadScanView.swift
//  project400
//
//  Created by Omar Alshuaili on 11/02/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI



struct SquareCameraWrapperView: View {
    //these  properties for search functionality
    
    @ObservedObject private var viewModel = NewPatientViewModel()

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var result = 0
    @State private var uiImage = UIImage()
    @State private var classificationLabel: String = ""
    @State var text: String = ""
    @State var opacity: Double = 0
    @State var scaleEffect: Double = 0.5
    @State private var isEditing = false
    @State private var showAddNewPatient = false
    
    var body: some View {
        ZStack{
            
            
            HStack(alignment:.top) {
                VStack(alignment: .leading){
                    Text("Add new scan")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.top,25)
                    ZStack {
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

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .offset(x: -UIScreen.main.bounds.width + 200)
                    }

                    if let patient = viewModel.patient {
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 75)
                                .fontWeight(.medium)
                                .padding(.horizontal)
                                .font(.system(size: 18))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray, lineWidth: 1))

                            HStack {
                                Image("avatar \(viewModel.patient?.avatar ?? 1)")
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



                    
                    ZStack{
                        Divider()
                        Text("OR")
                            .padding(.horizontal)
                            
                        
                        
                        
                    }.padding()
                    
                    Button {
                        showAddNewPatient.toggle()
                        
                    } label: {
                        Text("Add new Patient")
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(18)
                    .sheet(isPresented: $showAddNewPatient ){
                        AddNewPatient()
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                    .padding(.bottom)
                    
                    uploadScanView()
                    
                    
                }
                
            }.frame(minHeight: .infinity)
            
            
            
            
        }.ignoresSafeArea(.keyboard)
        
    }
    private func isEmpty(text:String) -> Bool {
        return text.isEmpty
    }
    
}


struct SquareCameraUIViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return SquareCameraViewController().view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    
    
}

struct uploadScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var uiImage = UIImage()
    @State private var result = 0
    @State private var DetailsText = ""
    
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View {

            if(selectedImageData == nil) {
                
                GeometryReader { geometry in
                    HStack() {
                        VStack(spacing:10){
                            Image(systemName: "camera.fill")
                                .resizable()
                                .aspectRatio( contentMode: .fill)
                                .frame(width: 20,height: 20)
                            Text("Scan Now")
                            
                            
                            
                        }.frame(width: geometry.size.width/2.1,height: 150)
                            .foregroundColor(.black)
                            .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.884))
                            .cornerRadius(12)
                            .shadow(radius: 7)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1.5).fill(.black)
                            )
                            .padding(.trailing)
                        
                        
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                VStack(spacing:10){
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio( contentMode: .fill)
                                        .frame(width: 20,height: 20)
                                    Text("Upload Scan")
                                    
                                    
                                    
                                    
                                }.frame(width: geometry.size.width/2.1,height: 150)
                                    .foregroundColor(.black)
                                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.884))
                                    .cornerRadius(12)
                                    .shadow(radius: 7)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1.5).fill(.black)
                                        
                                    )
                                
                                
                            }.onChange(of: selectedItem) { newItem in
                                Task {
                                    // Retrive selected asset in the form of Data
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                        if let selectedImageData,let uiImage = UIImage(data: selectedImageData) {
                                            self.uiImage = uiImage
                                        }
                                    }
                                }
                            }
                    }
                }.frame(height: 150)
                
            }
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity,maxHeight: 150)
                    .clipped()
                    .cornerRadius(12)
                
            }
            TextField("Details", text: $DetailsText)
                .frame(height: 75,alignment: .top)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1.5).fill(.gray)
                )
                .padding([.top,.bottom])
                .ignoresSafeArea(.keyboard)
            
            
            
        ClassifyButton(input: uiImage, detailsText: $DetailsText)
    }
}
struct ClassifyButton : View {
    let input : UIImage
    var classifyModel : CoreMLModel = CoreMLModel()
    @ObservedObject private var viewModel = NewPatientViewModel()
    @Environment(\.managedObjectContext) var moc
    @Binding var detailsText: String
    
    var body: some View {
        Button {
            classifyModel.classifyImage(uiImage: input)
            if( detailsText.isEmpty || input.size == CGSize.zero || viewModel.patient == nil) {
                saveScan()
            }
           
        } label: {
            Text("Save Scan")
                .frame(height: 40)
                .frame(maxWidth: .infinity)
                .padding()
                .fontWeight(.bold)
                .font(.system(size: 20))
                

        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color(hue: 0.402, saturation: 0.666, brightness: 0.647))
        .cornerRadius(18)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .disabled(detailsText.isEmpty || input.size == CGSize.zero || viewModel.patient == nil)
    }
    
    func saveScan() {
        let scan = MyScanFiles(context: moc)
        scan.imageData = input.jpegData(compressionQuality: 0.8)
        scan.details = detailsText
        scan.patinet = viewModel.patient?.name
        try? moc.save()
    }
}


struct uploadScanView_Previews: PreviewProvider {
    static var previews: some View {
        uploadScanView()
    }
}


