//
//  homeView.swift
//  project400
//
//  Created by Omar Alshuaili on 12/12/2022.
//
import SwiftUI
import AVFoundation
import Vision
import UIKit
import PhotosUI
import CoreML
import  CoreImage


class SquareCameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate {
    let photoOutput = AVCapturePhotoOutput()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            fatalError("No back camera found.")
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            fatalError("Failed to add back camera input: \(error)")
        }
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(output)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let width:CGFloat = 400
        let height:CGFloat = 400
        previewLayer.frame = CGRect(x: view.center.x - (width / 2), y: 90, width: width, height: height)
        previewLayer.cornerRadius = 20
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.addOutput(photoOutput)
        
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Handle the video output here
    }
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // handle the captured image here, for example by converting it to a UIImage and saving it to the photo library
        if let imageData = photo.fileDataRepresentation() {
            let image = UIImage(data: imageData)
            
        }
    }
    
}

struct SquareCameraWrapperView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var result = 0
    @State private var uiImage = UIImage()
    @State private var classificationLabel: String = ""
    @State var text: String = ""
    @State private var isEditing = false
    @State private var showAddNewPatient = false
    
    var body: some View {
        ZStack{
            Color.clear
            HStack(alignment:.top) {
                VStack(alignment: .leading){
                    Text("Add new scan")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.top,25)
                    
                    ZStack {
                        
                        TextField("Search for patient" ,text: $text)
                            .frame(height: 70)
                            .foregroundColor(.gray)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                            .font(.system(size: 18))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray,lineWidth: 1))
                        
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .offset(x:150)
                        
                    }
                    ZStack{
                        Divider()
                        Text("OR")
                            .padding(.horizontal)
                            .background(.white)
                        
                        
                        
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
    
}


struct SquareCameraUIViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return SquareCameraViewController().view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}


struct homeView: View {
    @State private var isShowingScanner = true
    private var text : CGFloat = 0
    @State private var isShowingSquareCamera = false
    @EnvironmentObject var viewModel : AppointmentViewModel
    @State var viewStates: [CGSize] = Array(repeating: .zero, count: AppointmentViewModel().appointments.count)




    var body: some View {
        
        VStack(alignment: .trailing) {
            
            HStack{
                HStack {
                    Image("profile")
                        .resizable()
                        .scaledToFill()
                        .offset(y:10)
                        .frame(width: 60,height: 60)
                        .cornerRadius(15)
                    
                    VStack(alignment: .leading) {
                        Text("welcome back")
                            .foregroundColor(.gray)
                        Text("Omar")
                            .font(.title)
                        
                    }
                    .offset(x:5)
                }
                Spacer()
                
                hamburger(showDetail: $isShowingScanner)
            }
            .frame(maxWidth: .infinity)
            Spacer().frame(height: 40)
            VStack(alignment: .leading){
                Text("Quick Access")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.1803921568627451, green: 0.20784313725490197, blue: 0.4))
                
                
                ScrollView(.horizontal){
                    
                    
                    HStack(spacing:20){
                        ForEach(0..<Cards.cards.count,id: \.self) { index in
                            GeometryReader { geo in
                                quickAccessView(imageName: Cards.cards[index].image, label:  Cards.cards[index].lable)
                                    .scaleEffect(getScale(proxy: geo))
                                    .opacity(
                                        getScale(proxy: geo) > 1 ? 1:0.9
                                    )
                            }.frame(width: 140)
                        }.padding()
                    }
                    
                }.scrollIndicators(.hidden)
            }
            
            
            HStack{
                Text("Upcoming appointments")
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.1803921568627451, green: 0.20784313725490197, blue: 0.4))
                Spacer()
                Text("See all")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            
            VStack {
                        appointmentsList(viewModel: viewModel, viewStates: $viewStates)
            }
            
            
            
            
            
            
            Button(action: { self.isShowingSquareCamera.toggle() }) {
                ZStack{
                    Text("+")
                        .offset(x:8,y: -10)
                    Image(systemName: "doc.viewfinder.fill")
                }.font(.system(size: 20))
            }
            .frame(width: 60,height: 60)
            .background(Color(red: 0.3843137254901961, green: 0.48627450980392156, blue: 0.8823529411764706))
            .clipShape(Circle())
            .foregroundColor(.white)
            .shadow(radius: 5)
            .sheet(isPresented: $isShowingSquareCamera) {
                
                SquareCameraWrapperView()
                    .padding()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .ignoresSafeArea(.keyboard)
                
            }
            
        }.frame(maxWidth:.infinity)
            .padding(.horizontal)
        
        
        
    }
    
    func getScale (proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        let x = proxy.frame (in: .global).minX
        let diff = abs(x)
        
        if (diff < 100){
            scale = 1 + (100 - diff) / 950
        }
        return scale
    }
}


extension View {
    func stacked(at position : Int, in total : Int) -> some View {
        let offset = Double (total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}




struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView().environmentObject(AppointmentViewModel())
    }
}

struct sideMenu: View {
    @State private var homeview = homeView()
    @ObservedObject  var SinginVM = SinginViewModel()
    @State var starting0ffsetY: CGFloat = UIScreen.main.bounds.width * 0.60
    var body: some View {
        GeometryReader{ metric in
            Rectangle()
                .fill(Color(hue: 1.0, saturation: 0.0, brightness: 0.934))
                .shadow(radius: 100)
            
        }
        
        
        
        VStack(alignment: .leading){
            Spacer()
            
            
            
            
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 20,height: 20)
                Text("Profile")
                    .foregroundColor(Color(hue: 0.592, saturation: 0.741, brightness: 0.212))
                    .padding()
                    .font(Font.custom("Gilroy-Bold", size: 30))
            }
            HStack {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 20,height: 20)
                Text("Calnder")
                    .foregroundColor(Color(hue: 0.592, saturation: 0.741, brightness: 0.212))
                    .padding()
                    .font(Font.custom("Gilroy-Bold", size: 30))
            }
            HStack {
                Image(systemName: "stethoscope")
                    .resizable()
                    .frame(width: 20,height: 20)
                Text("Patients")
                    .foregroundColor(Color(hue: 0.592, saturation: 0.741, brightness: 0.212))
                    .padding()
                    .font(Font.custom("Gilroy-Bold", size:30))
            }
            HStack {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 20,height: 20)
                Text("Setting").foregroundColor(Color(hue: 0.592, saturation: 0.741, brightness: 0.212))
                    .padding()
                    .font(Font.custom("Gilroy-Bold", size: 30))
            }
            
            
            Spacer()
            
            Button{
                SinginVM.logOut()
                
            }label: {
                Image("logout-rounded")
                    .resizable()
                    .frame(width: 30,height: 30)
                
                    .rotationEffect(Angle(degrees: 180))
            }
            
            Spacer().frame(height: 100)
            
        }.padding()
        
        
    }
}

struct hamburger: View {
    @Binding var showDetail : Bool
    
    var body: some View {
        Button {
            withAnimation{
                showDetail.toggle()
                
            }
        }
    label: {
        Image(systemName: "slider.vertical.3")
            .resizable()
            .aspectRatio( contentMode: .fit)
            .frame(width: 25, height: 25)
            .rotationEffect(Angle(degrees: showDetail ? 0 : 90))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                
            )
            .foregroundColor(.black)
            .padding()
        
    }
    }
}



struct topMenu: View {
    var body: some View {
        HStack() {
            
            
            
            Spacer()
            Image(systemName: "bell")
                .resizable()
                .aspectRatio( contentMode: .fit)
                .frame(width: 25, height: 25)
            
            Spacer().frame(width: 20)
            Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y:10)
                .frame(width: 60,height: 60)
                .clipShape(
                    Circle()
                    
                )
            
        }.frame(maxWidth:  .infinity)
    }
}


struct Cards {
    let image: String
    let lable: String
    
    static let cards = [Cards(image: "doc.text.magnifyingglass", lable: "Requests"),Cards(image: "person", lable: "Patients"),Cards(image: "doc.viewfinder", lable: "Scans")]
}

struct quickAccessView: View {
    let imageName : String
    let label : String
    var body: some View {
        VStack{
            Button {
                
            } label: {
                VStack{
                    Image(systemName: imageName)
                        .padding()
                        .background(Color(red: 0.4392156862745098, green: 0.5372549019607843, blue: 0.8941176470588236))
                        .clipShape(Circle())
                        .font(.system(size: 18))
                        .fontWeight(.medium)
                    
                    Text(label)
                        .font(Font.custom("Gilroy-Bold", size: 16))
                }.frame(width: 170,height: 170)
            }
            
            
        }.frame(width: 170,height: 170)
            .background(Color(red: 0.3843137254901961, green: 0.48627450980392156, blue: 0.8823529411764706))
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 5)
        
        
    }
}

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
        
        
        
        
        Button {
            classifyImage()
            result =  classifyImage()
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
    
    private func classifyImage() -> Int {
        var result = 0
        do{
            
            
            let multiArray = try? convertToMultiArray(uiImage)
            print(uiImage)
            
            let config = MLModelConfiguration()
            let model = try BreastCancerDetection(configuration:config)
            let prediction = try model.prediction(conv2d_input: multiArray!)
            print("\(prediction.Identity[0].doubleValue * 100.0)")
            result =  Int(prediction.Identity[0].doubleValue * 100.0)
        }
        catch{
            
        }
        
        return result
    }
    func convertToMultiArray(_ image: UIImage) -> MLMultiArray? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(cgImage, in: rect)
        
        guard let pixelBuffer = context.data else {
            return nil
        }
        
        // Change the shape of multiArray to [1, 50, 50, 3]
        let multiArray = try? MLMultiArray(shape: [1, 50, 50, 3], dataType: MLMultiArrayDataType.float32)
        
        let dataPointer = multiArray?.dataPointer.bindMemory(to: Float.self, capacity: width * height * 3)
        let pixelBufferPointer = pixelBuffer.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        // Resize the image to 50 x 50
        let resizedImage = resizeImage(image: uiImage, targetSize: CGSize(width: 50, height: 50))
        let resizedCgImage = resizedImage.cgImage
        
        for y in 0..<50 {
            for x in 0..<50 {
                for c in 0..<3 {
                    let offset = y * 50 * 4 + x * 4 + c
                    dataPointer?[y * 50 * 3 + x * 3 + c] = Float(pixelBufferPointer[offset]) / 255.0
                }
            }
        }
        return multiArray
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    
    func pixelBuffer(forImage image: UIImage) -> CVPixelBuffer? {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}


func appointmentsList(viewModel: AppointmentViewModel, viewStates: Binding<[CGSize]>) -> some View {
    return List {
        ForEach(viewModel.appointments.indices, id: \.self) { index in
            HStack {
                cardView(app: viewModel.appointments[index])
                    .offset(x: viewStates[index].width)
                    .gesture(
                        DragGesture().onChanged { value in
                            withAnimation {
                                viewStates[index] = value.translation
                                if viewStates[index].width <= -50 && viewStates[index].width <= -60  {
                                    let feedbackGenerator = UINotificationFeedbackGenerator()
                                    feedbackGenerator.notificationOccurred(.success)
                                }
                            }
                        }
                        
                    )
                    .overlay(
                                        HStack {
                                            let checkmarkOpacity = viewStates[index].width >= 55 && viewStates[index] != .zero ? 1 : 0
                                            Image(systemName: "checkmark")
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(.green)
                                                .clipShape(Circle())
                                                .opacity(checkmarkOpacity)
                                            
                                            Spacer()
                                            
                                            let trashOpacity = viewStates[index].width <= -55 && viewStates[index] != .zero ? 1 : 0
                                            Image(systemName: "trash")
                                                .padding()
                                                .foregroundColor(.white)
                                                .background(.red)
                                                .clipShape(Circle())
                                                .opacity(trashOpacity)
                                        }
                                    )
                                    
                                    .onEnded { value in
                                        withAnimation(.spring()) {
                                            viewStates[index] = .zero
                                        }
                                    }
                                }
                            }
                        }
                    }
