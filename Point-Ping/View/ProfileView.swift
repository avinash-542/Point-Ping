//
//  ProfileView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var selection: String? = nil
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                List {
                    
                    ProfileHeadView(uname: .constant(user.fullname), mail: .constant(user.email), uinit: .constant(user.initials))
                    
                    
                    Section("Connections") {
                        
                        NavigationLink {
                            MyConnectionsView()
                                
                        } label: {
                            SettingsRowView(imageName: "person.badge.shield.checkmark.fill", title: "My Connections", tintColor: Color(.systemGray))
                        }
                        
                        
                        
                        NavigationLink {
                            PendingRequestsView()
                        } label: {
                            SettingsRowView(imageName: "person.badge.clock.fill", title: "Pending request", tintColor: Color(.systemGray))
                        }
                        
                    }
                    
                    Section("Account") {
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                        }
                        

                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
