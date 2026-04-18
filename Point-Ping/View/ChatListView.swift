//
//  ChatListView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift

struct ChatListView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var conView = ConnectionsViewModel()
    @State private var selectedUser: User?
    @State private var cUser: User?
    @State private var isShowingPopup = false
    @State private var imgName = ""
    @State private var isShowingSecondView = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        ForEach(conView.establishedUsers, id: \.id) { user in
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
                                    
                                    VStack(alignment: .trailing) {
                                        NavigationLink {
                                            
                                            ChattingView(connectedUserID: .constant(user))
                                                .toolbar(.hidden, for: .tabBar)
                                                .navigationBarBackButtonHidden(true)
                                                
                                        } label: {
                                            HStack {
                                                Image(systemName: "message.fill")
                                                    .imageScale(.large)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    }
                                    .padding([.leading, .trailing], 20)
                                    
                                    
                                }
                                .padding(.leading, 20)
                            }
                            .padding(.top, 10)
                            
                        }
                        
                    }
                    
                    
                    
                }
                .navigationBarTitle("CHATS", displayMode: .large)
                .navigationBarBackButtonHidden(false)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { conView.establishedData = []; conView.establishedUsers = []; conView.getEstablishedConnections(cUser: viewModel.currentUser)}
        }
        
        
    }
}

//#Preview {
//    ChatListView()
//}
