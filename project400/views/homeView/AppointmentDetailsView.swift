//
//  AppointmentDetailsView.swift
//  project400
//
//  Created by Omar Alshuaili on 03/02/2023.
//

import SwiftUI

struct AppointmentDetailsView: View {
    @State private var notes = ""
    let id : Appointment
    @EnvironmentObject var viewModel : AppointmentViewModel
    @State private var offset = CGSize.zero
    @State private var isDeleted = false
    @Binding var ShowDetails: Bool
    @State var drag: CGSize = .zero
    @State private var opacity: CGFloat = 0.1
    @State var currentImage = 0
    var images = [Image(systemName: "greaterthan"), Image(systemName: "greaterthan"), Image(systemName: "greaterthan")]
    
    var body: some View {
        ZStack(alignment: .bottom){
            
            
            
            VStack(alignment: .center){
                RoundedRectangle(cornerRadius: 100)
                    .frame(width: 80,height: 10)
                    .foregroundColor(Color(red: 0.523, green: 0.537, blue: 0.585))
                    .gesture (
                        DragGesture()
                            .onChanged { Value in
                                if(Value.translation.height > 0){
                                    withAnimation(.spring()) {
                                        
                                        drag = Value.translation
                                        print(drag.height)
                                        if(drag.height > 120 ){
                                            ShowDetails = false
                                            
                                            
                                        }
                                    }
                                }
                                
                            }
                            .onEnded({ _ in
                                withAnimation(.spring()) {
                                    
                                    drag = .zero
                                }
                            })
                    )
                
                VStack {
                    VStack(alignment: .leading,spacing: 25){
                        HStack(alignment: .top) {
                            Image("avatar 1")
                                .resizable()
                                .frame(width: 90,height: 90)
                            Spacer()
                            Button {
                                ShowDetails.toggle()
                                
                            } label: {
                                Text("x")
                                    .frame(width: 35,height: 35)
                                    .padding(2)
                                    .foregroundColor(.black)
                                    .background(Color(#colorLiteral(red: 0.949, green: 0.949, blue: 0.949, alpha: 1))) // #f2f2f2)
                                    .fontWeight(.semibold)
                                    .clipShape(Circle())
                                    .font(.system(size: 20,design: .rounded))
                                
                                
                                
                                
                            }
                            
                            
                        }
                        
                        VStack(alignment: .leading,spacing: 25){
                            HStack {
                                Text("\(id.name)")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .font(.system(size: 20))
                                
                                
                                Circle()
                                    .foregroundColor(Color(red: 0.408, green: 0.408, blue: 0.408)) // #686868)
                                    .frame(width: 10)
                                    .foregroundColor(.gray)
                                Text(id.details)
                                    .font(.system(.subheadline))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 0.408, green: 0.408, blue: 0.408)) // #686868)))
                                    .font(.system(size: 16))
                                Spacer()
                                Text(id.time)
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 18))
                                
                            }
                            
                            
                            HStack(spacing:30) {
                                Image(systemName: "calendar")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.408, green: 0.408, blue: 0.408)) // #686868)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .frame(width: 20,height: 15)
                                Text(id.date)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.408, green: 0.408, blue: 0.408)) // #686868)))
                                Spacer()
                                Button {
                                    print("1")
                                } label: {
                                    Text("Reschedule?")
                                        .underline()
                                        .fontWeight(.bold)
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(red: 0.408, green: 0.408, blue: 0.408))
                                    
                                }
                                
                                
                                
                            }.padding(.leading)
                            
                            
                            
                            
                            
                            VStack{
                                Button {
                                    
                                } label: {
                                    Text("Upload Doc").frame(height: 35)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .fontWeight(.bold)
                                        .font(.system(size: 20))
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(lineWidth: 1))
                                
                                ZStack{
                                    
                                    RoundedRectangle(cornerRadius: 18).stroke(lineWidth: 1)
                                        .frame(height:70)
                                    
                                    HStack {
                                        Image(systemName: "greaterthan")
                                            .resizable()
                                            .frame(width: 10, height: 20)
                                            .font(.system(size: 1, design: .rounded))
                                            .foregroundColor(.red)
                                            .opacity(opacity)
                                            .animation(
                                                Animation.linear(duration: 1.2)
                                                    .repeatForever(autoreverses: true)
                                                    .delay(0),
                                                value: opacity
                                            )
                                            .onAppear(perform: { opacity = 1 })
                                        
                                        Image(systemName: "greaterthan")
                                            .resizable()
                                            .frame(width: 10, height: 20)
                                            .font(.system(size: 1, design: .rounded))
                                            .foregroundColor(.red)
                                            .opacity(opacity)
                                            .animation(
                                                Animation.linear(duration: 1.2)
                                                    .repeatForever(autoreverses: true)
                                                    .delay(0.6),
                                                value: opacity
                                            )
                                            .onAppear(perform: { opacity = 1 })
                                        
                                        Image(systemName: "greaterthan")
                                            .resizable()
                                            .frame(width: 10, height: 20)
                                            .font(.system(size: 1, design: .rounded))
                                            .foregroundColor(.red)
                                            .opacity(opacity)
                                            .animation(
                                                Animation.linear(duration: 1.2)
                                                    .repeatForever(autoreverses: true)
                                                    .delay(1.2),
                                                value: opacity
                                            )
                                            .onAppear(perform: { opacity = 1 })
                                    }
                                    
                                    
                                    Image(systemName: "trash")
                                        .padding()
                                        .padding(.horizontal)
                                        .frame(maxWidth: offset.width < 270 ? 80 : UIScreen.main.bounds.width * 0.88 )
                                        .background(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .offset(x: -UIScreen.main.bounds.width / 2 + 55 )
                                        .offset(x: offset.width > 270 ? offset.width - 120 : offset.width + 10 )
                                        .foregroundColor(offset.width > 270  ? .black : .white)
                                        .fontWeight(.black)
                                        .gesture(
                                            withAnimation(.spring()){
                                                DragGesture()
                                                    .onChanged { gesture in
                                                        withAnimation(.spring()) {
                                                            if(gesture.translation.width > 0 ){
                                                                offset = gesture.translation
                                                                if(offset.width > 280 ){
                                                                    offset.width = 280
                                                                }
                                                            }
                                                            else{
                                                                offset = .zero
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    .onEnded {_ in
                                                        withAnimation(.spring()) {
                                                            if(offset.width >= 280){
                                                                
                                                                isDeleted = true
                                                                AppointmentViewModel().delete(doc: id.id) {
                                                                    offset = .zero
                                                                    viewModel.appointments.remove(at: viewModel.appointments.firstIndex(of:id)!)
                                                                    ShowDetails.toggle()
                                                                    
                                                                }
                                                                
                                                            }
                                                            else{
                                                                
                                                                offset = .zero
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                            
                                                        }
                                                    }
                                                
                                            })
                                    
                                    
                                    
                                    
                                    Image(systemName: "checkmark")
                                    
                                        .padding()
                                        .padding(.horizontal)
                                        .foregroundColor(.white)
                                        .fontWeight(.black)
                                        .opacity(isDeleted && offset.width > 270 ? 1 : 0)
                                        .offset(x:10)
                                        .offset(x: isDeleted ? -10 : 0)
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                            }
                            
                        }
                    }.padding()
                        .frame(maxWidth: .infinity,
                               maxHeight: UIScreen.main.bounds.height * 0.44 ,
                               alignment: .top)
                        .background(.white)
                        .cornerRadius(20)
                    
                }
                
                
                
                
            }
            .offset(y: 5 )
            .offset(y: drag.height - 5)
            
            
            
            
            
            
            
            
            
            
        }
        .frame(maxHeight: .infinity,alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
        
        
        
        
    }
    
    
}


struct AppointmentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentDetailsView(id: Appointment.example,ShowDetails: .constant(true))
    }
}
