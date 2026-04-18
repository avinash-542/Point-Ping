//
//  AskPassPhraseView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import FirebaseAuth
import Foundation
import Firebase
import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

//struct AskPassPhraseView: View {
//    @Binding var isShowing: Bool
//    @Binding var heading: String
//    @State private var isDragging = false
//    @State private var verificationCompleted = false
//    @EnvironmentObject var authView: AuthViewModel
//    @Environment(\.dismiss) var dismiss
//    var selectedUser: User?
//    var cUser: User?
//    //@State private var passphrase: String
//    @State private var curHeight: CGFloat = 400
//    @State var inptData: String = ""
//    @State var conView  = ChatViewModel()
//    @StateObject var updated = updatedChats()
//    let minHeight: CGFloat = 400
//    let maxHeight: CGFloat = 700
//    
//    let startOpacity: Double = 0.4
//    let endOpacity: Double = 0.8
//    
//    var dragPercentage: Double {
//        let res = Double((curHeight - minHeight) / (maxHeight - minHeight))
//        return max(0,min(1,res))
//    }
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            if isShowing {
//                Color.black
//                    .opacity(startOpacity + (endOpacity - startOpacity) * dragPercentage)
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        isShowing = false
//                    }
//                
//                mainView
//                .transition(.move(edge: .bottom))
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//        .ignoresSafeArea()
//        .onAppear{
//            withAnimation(.easeInOut) {}
//        }
//    }
//    
//    var mainView: some View {
//        let inputBinded = Binding<String> (
//            get : {inptData},
//            set : {inptData = $0}
//            )
//        return VStack {
//            ZStack{
//                Capsule()
//                    .frame(width: 40, height: 6)
//            }
//            .frame(height: 60)
//            .frame(maxWidth: .infinity)
//            .background(Color.white.opacity(0.00001))
//            .gesture(dragGesture)
//            Spacer()
//            ZStack {
//                VStack {
//                    Text(heading)
//                        .font(.system(size: 20))
//                        .fontWeight(.bold)
//                        .foregroundColor(.black)
//                        .padding(.bottom, 10)
//                    Spacer()
//                    inputPPView(input: inputBinded)
//                        .padding([.leading, .trailing], 15)
//                    Spacer()
//                    Button (action : {
//                        
//                        conView.verifyPassPhraseGiven(sender:cUser!, reciever:selectedUser!, passphrase:inptData)
//
//                    }){
//                        HStack {
//                            Text("Decrypt")
//                                .fontWeight(.semibold)
//                                
//                        }
//                        .foregroundColor(.white)
//                        .frame(width: UIScreen.main.bounds.width - 250, height: 50)
//                    }
//                    .background(Color(.systemBlue))
//                    .cornerRadius(15.0)
//                    .onReceive(conView.$isPassAccepted) { passAccepted in
//                        inptData=""
//                        updated.isAccepted = passAccepted
//                        isShowing = !passAccepted
//                        
//                    }
//                }
//                .padding(.bottom, 100)
//                .onTapGesture {
//                    
//                }
//            }
//        }
//        .frame(height: curHeight)
//        .frame(maxWidth: .infinity)
//        .background(
//            ZStack {
//                RoundedRectangle(cornerRadius: 30)
//                Rectangle()
//                    .frame(height: curHeight / 2)
//                
//            }
//                .foregroundColor(Color.white)
//        )
//        .animation(isDragging ? nil : .easeInOut)
//        .onDisappear { curHeight = minHeight }
//    }
//    
//    @State private var prevDragTranslation = CGSize.zero
//    var dragGesture : some Gesture {
//        DragGesture(minimumDistance: 0, coordinateSpace: .global)
//            .onChanged { val in
//                if !isDragging {
//                    isDragging = true
//                }
//                let dragAmount = val.translation.height - prevDragTranslation.height
//                if curHeight > maxHeight || curHeight < minHeight {
//                    curHeight -= dragAmount / 6
//                } else {
//                    curHeight -= dragAmount
//                }
//                
//                
//                prevDragTranslation = val.translation
//            }
//            .onEnded {val in
//                prevDragTranslation = .zero
//                isDragging = false
//                if curHeight > maxHeight {
//                    curHeight = maxHeight
//                } else if curHeight < minHeight {
//                    curHeight = minHeight
//                }
//            }
//    }
//}



//#Preview {
//    AskPassPhraseView(isShowing: .constant(false), heading: .constant(""))
//}

