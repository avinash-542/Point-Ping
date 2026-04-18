//
//  UserHeadView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/19/23.
//

import SwiftUI

struct UserHeadView: View {
    @State var user: User
    @State var condition: String
    @State private var isShowingPopup = false
    @State private var selectedUser: User?
    var body: some View {
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
                    
                    Button(action: {isShowingPopup = true}) {
                        if condition == "accepted" {
                            Image(systemName: "person.badge.shield.checkmark.fill")
                                .imageScale(.large)
                                .foregroundColor(.green)
                        } else if condition == "pending" {
                            Image(systemName: "person.badge.clock.fill")
                                .imageScale(.large)
                                .foregroundColor(Color(.systemGray))
                        } else if condition == "none" {
                            Image(systemName: "person.wave.2.fill")
                                .imageScale(.large)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    
                    //                } label: {
                    //                    if condition == "accepted" {
                    //                        Image(systemName: "person.badge.shield.checkmark.fill")
                    //                            .imageScale(.large)
                    //                            .foregroundColor(.green)
                    //                    } else if condition == "pending" {
                    //                        Image(systemName: "person.badge.clock.fill")
                    //                            .imageScale(.large)
                    //                            .foregroundColor(Color(.systemGray))
                    //                    } else if condition == "none" {
                    //                        Image(systemName: "person.wave.2.fill")
                    //                            .imageScale(.large)
                    //                            .foregroundColor(.blue)
                    //                    }
                    //                }
                    //                Button() {
                    //                    if condition == "none" {
                    //                        CustomPopupView(user: user, isShowingPopup: .constant(true))
                    //                    }
                    //                }  label: {
                    //                    if condition == "accepted" {
                    //                        Image(systemName: "person.badge.shield.checkmark.fill")
                    //                            .imageScale(.large)
                    //                            .foregroundColor(.green)
                    //                    } else if condition == "pending" {
                    //                        Image(systemName: "person.badge.clock.fill")
                    //                            .imageScale(.large)
                    //                            .foregroundColor(Color(.systemGray))
                    //                    } else if condition == "none" {
                    //                        Image(systemName: "person.wave.2.fill")
                    //                            .imageScale(.large)
                    //                            .foregroundColor(.blue)
                    //                    }
                    //                }
                    
                }
            }
            
            //CustomPopupView(isShowing: .constant(isShowingPopup))

    }
}
