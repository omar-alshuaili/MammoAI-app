//
//  AddNewPatient.swift
//  project400
//
//  Created by Omar Alshuaili on 01/02/2023.
//

import SwiftUI

struct AddNewPatient: View {
    @FocusState var isInputActive: Bool
        
        // Add this line to create an instance of the view model
        @StateObject private var viewModel = NewPatientViewModel()
        
        // Replace this with the doctor's ID
        @AppStorage("user_id") private var doctorId: String = ""

        
        // Add these state properties to hold the patient's data
        @State private var avatar: Int = 0
        @State private var name: String = ""
        @State private var age: String = ""
        @State private var phone: String = ""
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading,spacing: 20){
                avatarSelection(avatar: $avatar)
                            PatientName(name: $name)
                            PatientAge(age: $age)
                            PatientPhone(phone: $phone)
                
                Button {
                    viewModel.addPatient(doctorId: doctorId, avatar: avatar, name: name, age: age, phone: phone)
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
    @Binding var avatar: Int
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
                                avatar = index + 1
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
    @Binding var name: String
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment:.leading){
            Text("Patient's name")
                .font(.system(size: 25))
                .fontWeight(.bold)
                . onTapGesture {
                      self.hideKeyboard()
                }
            TextField("Enter Patient's Full Name" ,text: $name)
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
    @Binding var age: String
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment:.leading){
            Text("Patient's Age")
                .font(.system(size: 25))
                .fontWeight(.bold)
                . onTapGesture {
                      self.hideKeyboard()
                }
            TextField("Enter Patient's Age" ,text: $age)
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
    @Binding var phone: String
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment:.leading){
            Text("Patient's Age")
                .font(.system(size: 25))
                .fontWeight(.bold)
                . onTapGesture {
                      self.hideKeyboard()
                }
            TextField("Enter Patient's Phone Number" ,text: $phone)
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
