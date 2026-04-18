//
//  LoginView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
      
    var body: some View {
        NavigationStack {
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
                    InputBoxView(text: $password, placeholder: "Password", isSecureField: true)
                }.padding([.leading, .trailing], 27.5)
                    .padding(.bottom, 30)
                
                Button {
                    Task {
                        try await viewModel.signin(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
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
                
                
                NavigationLink {
                    RegisterView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 14))
                }
            }
            
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}


#Preview {
    LoginView()
}
