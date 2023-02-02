//
//  AddNewPatient.swift
//  project400
//
//  Created by Omar Alshuaili on 01/02/2023.
//

import SwiftUI

struct AddNewPatient: View {
    @FocusState var isInputActive: Bool
    var body: some View {
        
        HStack {
            VStack(alignment: .leading,spacing: 20){
                avatarSelection()
                PatientName()
                PatientAge()
                PatientPhone()
                
                Button {
                    
                } label: {
                    Text("Save")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(18)
            }
            Spacer()
            
            
            
            
        }.frame(maxWidth: .infinity)
            .padding()
            . onTapGesture {
                  self.hideKeyboard()
            }
        
    }
}

struct AddNewPatient_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPatient()
    }
}




struct avatarSelection: View {
    @State private var selectedImage :Int =  0
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Choose avatar")
                .font(.system(size: 30))
                .fontWeight(.bold)
            HStack{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(0..<6) { index in
                            Button{
                                selectedImage = index
                            } label: {
                                ZStack{
                                    Image( "avatar \(index+1)")
                                        .resizable()
                                        .frame(width: 82,height: 82)
                                        .opacity(selectedImage == index ? 0.3 : 1)
                                    if(selectedImage == index){
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 30,height: 30)
                                            .font(.system(size: 25))
                                            .fontWeight(.medium)
                                            .foregroundColor(.black)
                                            .opacity(0.8)
                                        
                                            .rotationEffect(Angle(degrees: 10))
                                            .padding(8)
                                    }
                                }
                            }
                            
                        }
                    }
                }.scrollIndicators(.hidden)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(.gray,lineWidth: 1)
                    )
                
                
                
                
            }
            
        }
    }
}

struct PatientName: View {
    @State private var PatientName : String = ""
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment:.leading){
            Text("Patient's name")
                .font(.system(size: 25))
                .fontWeight(.bold)
                . onTapGesture {
                      self.hideKeyboard()
                }
            TextField("Enter Patient's Full Name" ,text: $PatientName)
                .frame(height: 80)
                .foregroundColor(.gray)
                .fontWeight(.medium)
                .padding(.horizontal)
                .font(.system(size: 18))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray,lineWidth: 1))
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
            
            
        }
    }
}


struct PatientAge: View {
    @State private var PatientAge : String = ""
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment:.leading){
            Text("Patient's Phone Number")
                .font(.system(size: 25))
                .fontWeight(.bold)
                . onTapGesture {
                      self.hideKeyboard()
                }
            TextField("Enter Patient's Age" ,text: $PatientAge)
                .keyboardType(.numberPad)
                .frame(height: 80)
                .foregroundColor(.gray)
                .fontWeight(.medium)
                .padding(.horizontal)
                .font(.system(size: 18))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray,lineWidth: 1))
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
            
            
        }
    }
}


struct PatientPhone: View {
    @State private var PatientPhone : String = ""
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment:.leading){
            Text("Patient's Age")
                .font(.system(size: 25))
                .fontWeight(.bold)
                . onTapGesture {
                      self.hideKeyboard()
                }
            TextField("Enter Patient's Phone Number" ,text: $PatientPhone)
                .keyboardType(.numberPad)
                .frame(height: 80)
                .foregroundColor(.gray)
                .fontWeight(.medium)
                .padding(.horizontal)
                .font(.system(size: 18))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray,lineWidth: 1))
                .focused($isFocused)
                
        }
    }
}


#if canImport(UIKit)
extension View {
    func HideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
