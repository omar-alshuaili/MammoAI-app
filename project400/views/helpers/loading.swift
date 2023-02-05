//
//  loading.swift
//  project400
//
//  Created by Omar Alshuaili on 03/02/2023.
//

import SwiftUI


    
struct LoadingCardView: View {
    @State private var loadingAnimation = true
    @State private var opacity: CGFloat = 0.1
private var forgroundColor = Color(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.9333333333333333)
    var body: some View {
        ZStack{
            
            VStack(alignment:.leading){
                HStack(spacing:15) {
                    Rectangle()
                        .frame(width: 70, height: 70)
                        .foregroundColor(forgroundColor)
                        .cornerRadius(5)
                                    
                    VStack(alignment: .leading){
                        Rectangle()
                            .frame(width: 100, height: 20)
                            .foregroundColor(forgroundColor)
                            .cornerRadius(5)

                        Rectangle()
                            .frame(width: 100, height: 20)
                            .foregroundColor(forgroundColor)
                            .cornerRadius(5)

                            
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Rectangle()
                            .frame(width: 70, height: 20)
                            .foregroundColor(forgroundColor)
                            .cornerRadius(5)
                        Rectangle()
                            .frame(width: 70, height: 20)
                            .foregroundColor(forgroundColor)
                            .cornerRadius(5)
                        Spacer()
                        
                    }
                    
                }.frame(maxWidth: .infinity)
                    .opacity(opacity)
                    .animation(
                        .easeInOut(duration: 0.6).repeatForever(),
                                    value: opacity
                                )
                    .onAppear(perform: { opacity = 1 })
                
                
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(lineWidth: 1).fill(forgroundColor)
            )
        }
    }
}




struct loading_Previews: PreviewProvider {
    static var previews: some View {
        LoadingCardView()
    }
}
