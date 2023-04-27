//
//  cardView.swift
//  project400
//
//  Created by Omar Alshuaili on 20/01/2023.
//\(Int.random(in: 1..<7))

import SwiftUI

struct cardView: View {
    let app : Appointment
    @State private var show : Bool = false
    @Namespace var namespace
    @EnvironmentObject var viewModel : AppointmentViewModel
    var body: some View {
        
        ZStack{
            
            
            
            
            VStack(alignment:.leading){
                HStack(alignment:.top, spacing: 15){
                    
                    
                    Image("avatar 2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60,height: 60)
                    
                    
                    VStack(alignment: .leading,spacing: 5){
                        Text("\(app.name)")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        HStack {
                            Text("27yo")
                                
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.3568627450980392, green: 0.34901960784313724, blue: 0.39215686274509803))
                            
                            Circle()
                                .frame(width: 4)
                                .foregroundColor(Color(red: 0.3568627450980392, green: 0.34901960784313724, blue: 0.39215686274509803))
                            Text(app.details)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 0.3568627450980392, green: 0.34901960784313724, blue: 0.39215686274509803))
                            
                        }

                        Spacer()
                            Text(app.time + " - 12:30")
                                .fontWeight(.bold)
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.3568627450980392, green: 0.34901960784313724, blue: 0.39215686274509803))
                            
                            
                        

                    }
                    
                    Spacer()
                    ZStack{
                       
                        RoundedRectangle(cornerRadius: 12)
                            .fill(app.isDone ?
                                  Color(red: 0.34901960784313724, green: 0.8549019607843137, blue: 0.43529411764705883) :
                                    Color(red: 0.23921568627450981, green: 0.23529411764705882, blue: 0.2549019607843137) )
                            .frame(width: 45,height: 45)
                            
                        
                        
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 19, height: 19)
                            .opacity(app.isDone ? 1 : 0)
                            .foregroundColor( .white)
                            
                    }.onTapGesture {
                        
                        viewModel.toggleDone(item: app)
                    }
                    
                    
                }
                Spacer()
                
                
            }
            .frame(height: 130)
            .padding()
            .background(Color(red: 0.8509803921568627, green: 0.8509803921568627, blue: 0.8509803921568627, opacity: 0.1))
            

            
            .cornerRadius(12)
            
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(lineWidth: 0)
            )
            

            
            
        }
    }
}


struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView(app: Appointment.example)
    }
}
