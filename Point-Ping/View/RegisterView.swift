//
//  RegisterView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var uname = ""
    @State private var password = ""
    @State private var confirm_pass = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack() {
            Image("logo-alone")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.bottom, 2)
                .padding(.top, 40)
            Text("Point-Ping")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.title).foregroundColor(Color.blue)
                .padding([ .bottom], 60)
            
            VStack() {
                InputBoxView(text: $email, placeholder: "Email")
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputBoxView(text: $uname, placeholder: "User Name")
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                InputBoxView(text: $name, placeholder: "Name")
                
                InputBoxView(text: $password, placeholder: "Password", isSecureField: true)
                
                ZStack(alignment: .trailing) {
                    InputBoxView(text: $confirm_pass, placeholder: "Confirm Password", isSecureField: true)
                    
                    
                    if !password.isEmpty && !confirm_pass.isEmpty {
                        if password == confirm_pass {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                                .padding(.trailing, 4)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                                .padding(.trailing, 4)
                        }
                    }
                }
            }.padding([.leading, .trailing], 27.5)
                .padding(.bottom, 30)
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: name, uname: uname)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 250, height: 50)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(15.0)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .font(.system(size: 14))
            }
        }
    }
}

extension RegisterView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirm_pass == password
        && !name.isEmpty
        && !uname.isEmpty
    }
}

#Preview {
    RegisterView()
}
