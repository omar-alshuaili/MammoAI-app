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
    var body: some View {
        ZStack{
            

                
                
                VStack(alignment:.leading){
                    HStack(spacing:15) {
                        Image("avatar 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70,height: 70)
                        
                        
                        VStack(alignment: .leading){
                            Text("\(app.name)")
                            
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            Text(app.details)
                                .font(.system(.subheadline))
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                            
                        }
                        Spacer()
                        VStack(alignment: .leading){
                            Text(app.date)
                                .font(.system(size: 16))
                                .font(.system(.subheadline))
                                .foregroundColor(.gray)
                            Text(app.time)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                            Spacer()
                            
                        }
                        
                    }.frame(maxWidth: .infinity)
                    
                    
                    
                }
                .padding()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                
                

               

                
                .frame(height: 80)
                .padding(.vertical)
            
             .background(.white)
             .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(lineWidth: 1)
                )
            
              
                
        }
    }
}


struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView(app: Appointment.example)
    }
}
