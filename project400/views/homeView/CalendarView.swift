//
//  CalendarView.swift
//  project400
//
//  Created by Omar Alshuaili on 25/04/2023.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
            .fill(.clear)
            .frame(height: 70)
            .fontWeight(.medium)
            .padding(.horizontal)
            .font(.system(size: 18))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray,lineWidth: 1))
            
            HStack {
                Image("avatar 1")
                    .resizable()
                    .frame(width: 60,height: 60)
                Spacer()
                Image(systemName: "person.fill")
                Text("Omar Alshuaili")
                Spacer()
                Image(systemName: "phone.fill")
                Text("99999999")
                
            }
            .padding()
            
            
        }
        .padding()
        
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
