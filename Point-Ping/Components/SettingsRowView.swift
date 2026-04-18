//
//  SettingsRowView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName:String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(tintColor)
                .symbolEffect(.bounce, options: .repeat(2), value: 10)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.black)
        }
    }
}


#Preview {
    SettingsRowView(imageName: "message.fill", title: "version", tintColor: Color(.blue))
}
