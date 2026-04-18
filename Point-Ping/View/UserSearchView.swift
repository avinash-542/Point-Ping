//
//  UserSearchView.swift
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

struct UserSearchView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var userLookup = UserSearchViewModel()
    @StateObject var connView = ConnectionsViewModel()
    @State var keyword: String = ""
    @State private var selectedUser: User?
    @State private var cUser: User?
    @State private var isShowingPopup = false
    @State private var imgName = ""
    var body: some View {
        let keywordBinding = Binding<String> (
            get : {keyword},
            set : {
                keyword = $0
                userLookup.fetchUsers(from: keyword)
                connView.checkConnection(cuid: Auth.auth().currentUser!.uid)
            }
            
        )
        
            ZStack {
                VStack {
                    
                    SearchBarView(keyword: keywordBinding)
                        .padding([.leading, .trailing], 5)
                    ScrollView {
                        ForEach(userLookup.queriedUsers, id: \.id) { user in
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
                                    
                                    Button(action: {
                                        selectedUser = user; cUser = viewModel.currentUser!;
                                        
                                        isShowingPopup = !(connView.senderList.contains(user.id) || connView.recieverList.contains(user.id))
                                        
                                        print(isShowingPopup, imgName)
                                        
                                    }) {
                                        Image(systemName: (connView.senderList.contains(user.id) || connView.recieverList.contains(user.id)) ? "" : "person.wave.2.fill")
                                            .imageScale(.large)
                                            .foregroundColor(.blue)
                                    }
                                    
                                }
                                .padding([.leading, .trailing], 10)
                            }

                            
                            
                        }
                    }
                    
                    
                    
                }
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                SendRequestPopupView(isShowing: $isShowingPopup, heading: .constant("Send Connection request!") ,selectedUser: selectedUser, cUser: cUser)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}


struct SearchBarView: View {
    @Binding var keyword: String

    var body: some View {
        ZStack {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.5))
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Searching for...", text: $keyword)
                        .autocapitalization(.none)
                    }
                    .padding(.leading, 13)
                }
                .frame(height: 40)
                .cornerRadius(13)
                .padding()
    }
}


