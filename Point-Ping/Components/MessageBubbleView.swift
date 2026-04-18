//
//  MessageBubbleView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct MessageBubbleView: View {
    @Binding var message : Chats
    var body: some View {
        VStack(alignment: message.isReceived ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.isReceived ? Color(.systemGray2) : Color(.systemTeal))
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.isReceived ? .leading : .trailing)
        }
        .frame(maxWidth: .infinity, alignment: message.isReceived ? .leading : .trailing)
        .padding(message.isReceived ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

#Preview {
    MessageBubbleView(message: .constant(Chats(text: "", isReceived: false, date: "", time: "", timeStamp: "")))
}
