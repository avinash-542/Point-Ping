//
//  PendingRequestsView.swift
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

struct PendingRequestsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var userLookup = UserSearchViewModel()
    @StateObject var pendConnView = ConnectionsViewModel()
    @State var keyword: String = ""
    @State private var selectedUser: User?
    @State private var cUser: User?
    @State private var isShowingPopup = false
    @State private var imgName = ""
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    ForEach(pendConnView.recievedPending, id: \.id) { user in
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
                                    Button(action: {
                                        selectedUser = user; cUser = viewModel.currentUser!;
                                        
                                        isShowingPopup = true
                                        
                                    }) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .imageScale(.large)
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                VStack(alignment: .trailing) {
                                    Button(action: {
                                        selectedUser = user; cUser = viewModel.currentUser!;
                                        
                                        isShowingPopup = false
                                        
                                    }) {
                                        HStack {
                                            Image(systemName: "xmark.circle.fill")
                                                .imageScale(.large)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                                
                            }
                            .padding([.leading, .trailing], 10)
                        }

                        
                        
                    }
                    ForEach(pendConnView.sendedPending, id:\.id) { user in
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
                                    Button(action: {
                                        selectedUser = user; cUser = viewModel.currentUser!;
                                        
                                        isShowingPopup = false
                                        
                                    }) {
                                        HStack {
                                            Image(systemName: "arrowshape.turn.up.left.circle.fill")
                                                .imageScale(.large)
                                                .foregroundColor(.orange)
                                            Text ("Withdraw")
                                        }
                                    }
                                    
                                }
                                
                            }
                            .padding([.leading, .trailing], 10)
                        }
                    }
                    
                }
                
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pending Requets")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            AcceptRequestPopupView(isShowing: $isShowingPopup, heading: .constant("Enter decided Passphrase!") ,selectedUser: selectedUser, cUser: cUser)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {pendConnView.pendingData = []; pendConnView.recievedPending = []; pendConnView.sendedPending = []; pendConnView.getPendingConnections(uid: Auth.auth().currentUser!.uid)}
    }
}

#Preview {
    PendingRequestsView()
}
