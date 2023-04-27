//
//  ScanView.swift
//  project400
//
//  Created by Omar Alshuaili on 25/04/2023.
//
import SwiftUI
import UIKit

//        VStack {
//            List(scans) { scan in
//                let image : UIImage = UIImage(data: scan.imageData!)!
//
//                Text(scan.details ?? "")
//                Image( uiImage: image)
//            }
//        }
import SwiftUI
import UIKit


struct ScanView: View {
    @FetchRequest(sortDescriptors: []) var scans: FetchedResults<MyScanFiles>
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Scans")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity,alignment: .leading)
            Divider()
                
            
            if scans.isEmpty {
                VStack(spacing: 25){
                    
                    Image("no-result")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                    Text("No scans yet !")
                        .fontWeight(.bold)
                        .offset(x:15)
                    
                }.frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                    .offset(x:-15,y:-65)
                
            } else {
                ForEach(scans) { scan in
                    let image : UIImage = UIImage(data: scan.imageData!)!
                    ScanCard(imageData: image, details: scan.details ?? "", prediction: scan.prediction ?? "", patient: scan.patinet ?? "" , selectedImage: $selectedImage)
                        .swipeActions(edge: .trailing) {
                            Button(action: {
                                deleteScan(scan: scan)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.all)
        .padding()
        .background(Color(red: 0.09019607843137255, green: 0.08627450980392157, blue: 0.10588235294117647))
        .overlay(
            Group {
                if let image = selectedImage {
                    ExpandedImageView(image: image, selectedImage: $selectedImage)
                }
            }
        )
    }
    
    private func deleteScan(scan: MyScanFiles) {
        let context = ScanCoreData().container.viewContext
        context.delete(scan)
        try? context.save()
    }
}


struct ScanCard: View {
    let imageData: UIImage
    let details: String
    let prediction : String
    let patient : String
    @Binding var selectedImage: UIImage?
    @State private var isSheetPresented: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 15) {
                
                
                Button(action: {
                    selectedImage = imageData
                }) {
                    Image(uiImage: imageData)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 70)
                        .cornerRadius(10)
                }.padding()
                Spacer()
                HStack(spacing:15){
                    Text("97%")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 60,height: 120)
                        .background(Color(red: 0.050980392156862744, green: 0.047058823529411764, blue: 0.058823529411764705))
                        
                        
                }
                .onTapGesture {
                    isSheetPresented = true

                }
                
            }
        }
        .frame(maxWidth: .infinity)
        
        .background(Color(red: 0.8509803921568627, green: 0.8509803921568627, blue: 0.8509803921568627, opacity: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
        .sheet(isPresented: $isSheetPresented) {
                    VStack {
                        Image(uiImage: imageData)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                        
                        // Add other details here
                        Text(details)
                            .font(.title)
                            .padding()
                        
                        Spacer()
                    }.padding()
                }
       
        
        
        
    }
}

struct ExpandedImageView: View {
    let image: UIImage
    

    @Binding var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        selectedImage = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .padding()
                    }
                }
                
                Spacer()
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
            }
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
