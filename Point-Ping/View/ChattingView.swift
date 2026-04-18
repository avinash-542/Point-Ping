//
//  ChattingView.swift
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

class updatedChats: ObservableObject {
    @Published var isAccepted = false
}

struct ChattingView: View {
    @EnvironmentObject var model: AuthViewModel
    @StateObject var myChatView = ChatViewModel()
    @Binding var connectedUserID: User?
    @State private var isShowingPopup = false
    @Environment(\.dismiss) private var dismiss
    @State var allMessages: [Chats] = []
    @StateObject var update = updatedChats()
    @State var passAccepted = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Button (
                            action : {dismiss()}
                        ) {
                            Image(systemName: "arrowtriangle.backward.fill")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        .padding([.leading, .bottom])
                        
                        Spacer()
                        
                        TitleRowView(uname: connectedUserID!.uname, mail: connectedUserID!.email, uinit: connectedUserID!.initials)
                        
                        VStack (alignment: .trailing) {
                            Button(action: {

                                isShowingPopup = true
                                
                            }) {
                                HStack {
                                    Text("Decrypt")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                                .frame(width:  100, height: 40)
                            }
                            .background(Color(.systemGray3))
                            .cornerRadius(30.0)
                            .padding(.trailing, 10)
                            .padding(.bottom)
                        }
                    }
                    ScrollView {
                        ForEach(passAccepted ? myChatView.decryptedchats.indices : myChatView.encryptedchats.indices, id: \.self) { index in
                            MessageBubbleView(message: .constant(passAccepted ? myChatView.decryptedchats[index] : myChatView.encryptedchats[index]))
                                .id(UUID())
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .roundedCorner(30, corners: [.topLeft, .topRight])
                }
                .background(Color(.systemTeal))
                
                MessageField(selectedUser: connectedUserID, cUser: model.currentUser)
            }
            
            AskPassPhraseView(isShowing: $isShowingPopup, passAccepted: $passAccepted ,heading: .constant("Enter PassPhrase"), selectedUser: connectedUserID, cUser: model.currentUser)
        }
        .onAppear {
            myChatView.retriveMessages(sender: model.currentUser!, reciever: connectedUserID!)
        }
    }
    
}


extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct AskPassPhraseView: View {
    @Binding var isShowing: Bool
    @Binding var passAccepted: Bool
    @Binding var heading: String
    @State private var isDragging = false
    @State private var verificationCompleted = false
    @EnvironmentObject var authView: AuthViewModel
    @Environment(\.dismiss) var dismiss
    var selectedUser: User?
    var cUser: User?
    @State private var curHeight: CGFloat = 400
    @State var inptData: String = ""
    @State var conView  = ChatViewModel()
    @StateObject var updated = updatedChats()
    let minHeight: CGFloat = 400
    let maxHeight: CGFloat = 700
    
    let startOpacity: Double = 0.4
    let endOpacity: Double = 0.8
    
    var dragPercentage: Double {
        let res = Double((curHeight - minHeight) / (maxHeight - minHeight))
        return max(0,min(1,res))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(startOpacity + (endOpacity - startOpacity) * dragPercentage)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing = false
                    }
                
                mainView
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .onAppear{
            withAnimation(.easeInOut) {}
        }
    }
    
    var mainView: some View {
        let inputBinded = Binding<String> (
            get : {inptData},
            set : {inptData = $0}
            )
        return VStack {
            ZStack{
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            .gesture(dragGesture)
            Spacer()
            ZStack {
                VStack {
                    Text(heading)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                    Spacer()
                    inputPPView(input: inputBinded)
                        .padding([.leading, .trailing], 15)
                    Spacer()
                    Button (action : {

                        conView.verifyPassPhraseGiven(sender: cUser!, reciever: selectedUser!, passphrase: inptData)
 
                    }){
                        HStack {
                            Text("Decrypt")
                                .fontWeight(.semibold)
                                
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 250, height: 50)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(15.0)
                    .onReceive(conView.$isPassAccepted) { ispassAccepted in
                        inptData=""
                        passAccepted = ispassAccepted
                        isShowing = !ispassAccepted
                        
                    }
                }
                .padding(.bottom, 100)
                .onTapGesture {
                    
                }
            }
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                Rectangle()
                    .frame(height: curHeight / 2)
                
            }
                .foregroundColor(Color.white)
        )
        .animation(isDragging ? nil : .easeInOut)
        .onDisappear { curHeight = minHeight }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    var dragGesture : some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    isDragging = true
                }
                let dragAmount = val.translation.height - prevDragTranslation.height
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 6
                } else {
                    curHeight -= dragAmount
                }
                
                
                prevDragTranslation = val.translation
            }
            .onEnded {val in
                prevDragTranslation = .zero
                isDragging = false
                if curHeight > maxHeight {
                    curHeight = maxHeight
                } else if curHeight < minHeight {
                    curHeight = minHeight
                }
            }
    }
}
