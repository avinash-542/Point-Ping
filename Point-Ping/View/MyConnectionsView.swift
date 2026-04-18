//
//  MyConnectionsView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

struct MyConnectionsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var myConnView = ConnectionsViewModel()
    //@StateObject var myMsgView = ChatViewModel()
    @State private var selectedUser: User?
    @State private var cUser: User?
    @State private var isShowingPopup = false
    @State private var imgName = ""
    @State private var isShowingSecondView = false
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(myConnView.establishedUsers, id: \.id) { user in
                        Section {
                            HStack {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 48, height: 48)
                                    .background(Color(.systemGray3))
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.uname)
                                        .font(.system(size: 20))
                                        .fontWeight(.semibold)
                                        .padding(.top, 3)
                                }
                                
                                
                                Spacer()
                                
                                
                                
                            }
                            .padding(.leading, 20)
                        }
                        
                    }
                    
                }
                
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("My Connections")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {myConnView.establishedData = []; myConnView.establishedUsers = []; myConnView.getEstablishedConnections(cUser: viewModel.currentUser!)}
        
    }
    
}


