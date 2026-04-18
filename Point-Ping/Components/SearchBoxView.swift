//
//  SearchBoxView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/13/23.
//

import SwiftUI

struct SearchBoxView: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(placeholder, text: $text)
                .font(.system(size: 14))
                
        }
        .padding()
        .background(Color.themeTextField)
        .cornerRadius(20.0)
    }
}

#Preview {
    SearchBoxView(text: .constant(""),placeholder: "Search ....")
}
