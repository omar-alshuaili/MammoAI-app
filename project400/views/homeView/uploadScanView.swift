//
//  uploadScanView.swift
//  project400
//
//  Created by Omar Alshuaili on 11/02/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct uploadScanView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var uiImage = UIImage()
    @State private var result = 0
    @State private var DetailsText = ""
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
            
            
            
        ClassifyButton(input: uiImage)
    }
}

struct ClassifyButton : View {
    let input : UIImage
    var classifyModel : CoreMLModel = CoreMLModel()
    
    var body: some View {
        
        Button {
            classifyModel.classifyImage(uiImage: input)
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
    }
}


struct uploadScanView_Previews: PreviewProvider {
    static var previews: some View {
        uploadScanView()
    }
}


