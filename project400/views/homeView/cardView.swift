//
//  cardView.swift
//  project400
//
//  Created by Omar Alshuaili on 20/01/2023.
//

import SwiftUI

struct cardView: View {
    let app : Appointment
//    let height : CGFloat
    var body: some View {
        ZStack{
            
            VStack(alignment:.leading){
                HStack(spacing:15) {
                    Image("avatar \(Int(app.id)! + 1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70,height: 70)
                    
                    VStack(alignment: .leading){
                        Text("\(app.name)")
//                            .padding(.horizontal,20)
//                            .padding(.vertical,10)
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
//                            .padding(.horizontal,20)
//                            .padding(.vertical,10)
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
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(lineWidth: 1)
            )
            
            
            
            
        }
    }
    //    private func getScale (proxy: CGFloat) -> CGFloat {
    //        var scale : CGFloat = 0
    //        if(proxy <= 250 && proxy >= 14) {
    //            scale =   abs(120 - (proxy * 0.476))
    //        }
    //
    //        else if (proxy > 250){
    //            return 0
    //        }
    //
    //        else{
    //            scale =   120  + ( proxy * 0.476 ) - (13.99 * 0.476)
    //
    //        }
    //        return scale
    //     }
}


struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView(app: Appointment.example)
    }
}
