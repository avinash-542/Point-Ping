//
//  MessageField.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct MessageField: View {
//    @EnvironmentObject var messagesManager: MessagesManager
    var selectedUser: User?
    var cUser: User?
    @State var messageView = ChatViewModel()
    @State private var message = ""

    var body: some View {
        NavigationStack {
            HStack {
                    // Custom text field created below
                    CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                        .frame(height: 52)
                        .disableAutocorrection(true)
                    
                    Button {
                        messageView.sendMessage(sender: cUser!, reciever: selectedUser!, message: message)
                        message = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(.systemTeal))
                            .cornerRadius(50)
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.systemGray3))
            .cornerRadius(50)
            .padding()
        }
    }
}

#Preview {
    MessageField()
}


struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                
        }

    }
}
