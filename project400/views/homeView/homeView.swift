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



struct homeView: View {
    @State private var isShowingScanner = true
    @State var isShowAppointmentDetails = false
    @State var isShowing = false
    @State var offset : CGSize = .zero
    private var text : CGFloat = 0
    @State private var isShowingSquareCamera = false
    @EnvironmentObject var viewModel : AppointmentViewModel
    @State var index = "0"
    @State private var currentAppointment : Appointment = Appointment.example
    @State var isRefreshing = false
    @State var isShowingFullList = false
    @State var searchTerm = ""
    var lastHour: String? = nil
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            Color(red: 0.09019607843137255, green: 0.08627450980392157, blue: 0.10588235294117647)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    
                    
                    HStack{
                        HStack {
                            Image("profile")
                                .resizable()
                                .scaledToFill()
                            
                                .frame(width: 60,height: 60)
                                .cornerRadius(60)
                            
                            VStack(alignment: .leading,spacing: 5) {
                                Text(Calendar.current.component( .hour, from:Date() ) > 11 ? "Good Afternoon, " : "Good Morning, " + "Omar")
                                    .font(Font.custom("Poppins Medium", size: 20))
                                    .foregroundColor(.white)
                                
                                
                                Text("You have \(viewModel.todaysAppointment()) patient today"  )
                                    .font(Font.custom("Poppins Medium", size: 16))
                                    .foregroundColor(.white).opacity(37/100)
                                
                                
                            }
                            .offset(x:5)
                        }
                        Spacer()
                        
                        //hamburger(showDetail: $isShowingScanner)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .fill(Color(red: 0.1568627450980392, green: 0.15294117647058825, blue: 0.17254901960784313))
                                .frame(width: 57,height: 57)
                            
                            Circle()
                                .fill(Color(red: 0.5725490196078431, green: 0.5764705882352941, blue: 0.8980392156862745))
                                .frame(width: 20, height: 20)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color(red: 0.09019607843137255, green: 0.08627450980392157, blue: 0.10588235294117647), lineWidth: 4)
                                )
                                .offset(x:22,y:-22)
                            
                            
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            
                        }
                        
                        
                        
                        
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    Spacer().frame(height: 40)
                    VStack(alignment: .leading){
                        
                        
                        
                        ScrollView(.horizontal){
                            
                            
                            HStack{
                                ForEach(0..<Cards.cards.count,id: \.self) { index in
                                    GeometryReader { geo in
                                        quickAccessView(imageName: Cards.cards[index].image, label:  Cards.cards[index].lable)
                                            .scaleEffect(getScale(proxy: geo))
                                            .opacity(
                                                getScale(proxy: geo) > 1 ? 1:0.9
                                            )
                                        
                                        
                                    }
                                    
                                    .frame(width: 190)
                                    .frame(minHeight: 0, maxHeight: .infinity)
                                    
                                    
                                }.padding()
                            }
                            
                        }.scrollIndicators(.hidden)
                        
                    }.frame(height: 150)
                        .padding(.bottom,10)
                    //
                    ZStack(alignment:.leading){
                        
                        HStack {
                            if(searchTerm.isEmpty) {
                                Text("Search patinas...")
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.3))
                            
                        }.padding()
                        
                        TextField("Search patinas...", text: $searchTerm)
                            .padding()
                            .foregroundColor(.white.opacity(0.5))
                            .background(.opacity(0.2))
                            .cornerRadius(13)
                    } .padding(.bottom,10)
                    
                    
                    
                    
                    HStack(){
                        Text("Appointments")
                            .font(Font.custom("Poppins-SemiBold", size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image("filter")
                                .resizable()
                                .frame(width:25,height:25)
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
                if(viewModel.appointments.count != 0 ){
                    
                    List {
                        
                        ForEach(viewModel.appointments.sorted(), id: \.id) { appointment in
                            
                            HStack(alignment: .top,spacing: 0){
                                
                                let currentTime = appointment.time.split(separator: ":").first! + ":00"
                                
                                
                                if !viewModel.isSameTime(time:String(currentTime)) {
                                    Text(currentTime)
                                        .font(Font.custom("Poppins-SemiBold", size: 16))
                                        .foregroundColor(.white)
                                        .frame(width: 50, alignment: .leading)
                                    
                                }
                                else{
                                    Text(appointment.time)
                                        .font(Font.custom("Poppins-SemiBold", size: 16))
                                        .foregroundColor(.white)
                                        .frame(width: 60, alignment: .leading)
                                }
                                
                                
                                
                                Spacer()
                                
                                cardView(app: appointment)
                                    .listRowInsets(EdgeInsets())
                                    .padding(.bottom,15)
                                
                                    .onTapGesture {
                                        index = appointment.id
                                        currentAppointment = appointment
                                        withAnimation {
                                            let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                                            impactHeavy.impactOccurred()
                                            isShowAppointmentDetails.toggle()
                                        }
                                    }
                                
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        .listRowBackground(Color.clear)
                        
                        
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .padding(5)
                        .animation(.easeInOut)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .scrollContentBackground(.hidden)
                        
                        
                    }
                    //MARK: style the list here
                    .listRowSeparator(.hidden)
                    
                    .padding(0)
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    
                    
                    
                    
                }
                else{
                    List {
                        ForEach(0..<4) {_ in
                            
                            HStack() {
                                
                                LoadingCardView()
                            }
                            
                            
                        } .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .padding(5)
                        
                    }
                    .listStyle(PlainListStyle())
                    .listRowSeparator(.hidden)
                    
                }
                
                
            }.frame(maxWidth:.infinity)
                .padding()
                .blur(radius: isShowAppointmentDetails ? 1 : 0 )
            
            
            
            
                
            
            if(isShowAppointmentDetails){
                Color(.black).opacity(isShowAppointmentDetails ? 0.59 : 0)
                
                AppointmentDetailsView(id:currentAppointment,ShowDetails: $isShowAppointmentDetails)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
                    .zIndex(3)
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    func isSameTime(time: String) -> Bool {
        return lastHour == time
    }
    
    func printIndex(id:String){
        print(id)
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
    
    static let cards = [Cards(image: "scans-quick-action", lable: "Scans"),Cards(image: "patients-quick-action", lable: "Patients"),Cards(image: "doc.viewfinder", lable: "Scans")]
}

struct quickAccessView: View {
    let imageName : String
    let label : String
    var body: some View {
        VStack{
            Button {
                
            } label: {
                HStack(alignment:.top){
                    
                    Text(label)
                        .font(Font.custom("Poppins-SemiBold", size: 20))
                    Spacer()
                    
                }.padding()
                    .frame(width: 190,height: 125,alignment: .top)
                
                    .overlay(content: {
                        Image(imageName)
                            .resizable()
                            .aspectRatio( contentMode: .fit)
                            .frame(width: 190,height: 125)
                            .offset(x:15,y:15)
                    })
                
                
                
            }
            
            
        }.frame(width: 190,height: 125)
            .background(.white.opacity(0.1))
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 5)
        
        
    }
}






