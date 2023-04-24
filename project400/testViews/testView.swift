//
//  testView.swift
//  project400
//
//  Created by Omar Alshuaili on 05/02/2023.
//

import SwiftUI

struct DragRectangle: View {
    @Binding var offset: CGFloat
    @Binding var scale: Double
    let rotation: Angle
    
    var body: some View {
        Rectangle()
            .fill(Color.red)
            .cornerRadius(12)
            .frame(width: 250, height: 300)
            .offset(x: offset)
            .offset(y:scale)
            .rotationEffect(rotation)
    }
}

struct xxx: View {
    @State private var offset1: CGSize = .zero
    @State private var rotat1: Double = -5
    @State private var rotat2: Double = 0
    @State private var rotat3: Double = 5
    @State private var offset2: CGSize = .zero
    @State private var offset3: CGSize = .zero
    @State private var activeRectangle: Int = 2
    @State private var scal1 : Double = 0
    @State private var scal2 : Double = -50
    @State private var scal3 : Double = 0

    
    var body: some View {
        ZStack {
            HStack(spacing: 30) {
                
                DragRectangle(offset: $offset1.width, scale: $scal1 , rotation: Angle(degrees: rotat1))
                    .gesture(
                        DragGesture()
                            
                        
                    )
                    .disabled(activeRectangle != 1)
                
                
                
                
                DragRectangle(offset: $offset2.width, scale: $scal2 , rotation: Angle(degrees: rotat2))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                withAnimation {
                                    if(value.translation.width > 0){
                                        offset2.width = value.translation.width + 1
                                        offset1.width = offset2.width
                                        offset3.width = offset1.width
                                        rotat1 = min(0,rotat1 + value.translation.width / 360)
                                        
                                        rotat2 = max(1 + value.translation.width / 360, 5)
                                        scal1 = max(scal1 -  0.6,-50)
                                        scal2 = max(scal2 - 0.6,-50)
                                        
                                    }
                                    else {
                                        offset2.width = value.translation.width - 1
                                        offset1.width = value.translation.width - 1
                                        offset3.width = value.translation.width - 1
                                        rotat3 = max(value.translation.width / 360 - 1, 0)
                                        rotat2 = min(value.translation.width / 360 - 1, -5)
                                        scal3 = max(scal3 - 0.6,-50)
                                       
                                    }
                                    
                                    scal2  = min(0, scal2 + 0.6)
                                    
                                    
                                }
                            })
                            .onEnded({ _ in
                                print(offset3.width)
                                withAnimation(.spring()) {
                                    if(offset2.width < -20 ) {
                                        offset2.width = -UIScreen.main.bounds.width / 2 - 80
                                        offset3.width = offset2.width
                                        activeRectangle = 3
                                        rotat2 = -5
                                        rotat3 = 0
                                    
                                    }
                                    else if (offset2.width > 20){
                                        offset2.width = UIScreen.main.bounds.width / 2 + 80
                                        offset1.width = offset2.width
                                        activeRectangle = 1
                                        rotat1 = 0
                                        rotat2 = 5
                                        
                                    }
                                    else{
                                        activeRectangle = 2
                                        offset2.width = .zero
                                        offset1.width = .zero
                                        offset3.width = .zero
                                        rotat1 = -5
                                        rotat2 = 0
                                        rotat3 = 5
                                        scal2  = -50
                                        scal1 = 0
                                        scal3 = 0
                                    }
                                }
                              
                            })
                        
                        
                        
                    )
                    .disabled(activeRectangle != 2)
                
                DragRectangle(offset: $offset3.width, scale: $scal3  , rotation: Angle(degrees: rotat3))
                    .gesture(
                        DragGesture()
                           
                        
                        
                        
                    )
                    .disabled(activeRectangle != 3)
                
            }
        }
    }
}
struct testView_Previews: PreviewProvider {
    static var previews: some View {
        xxx()
    }
}
