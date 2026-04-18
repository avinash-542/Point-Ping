//
//  TitleRowView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct TitleRowView: View {
    @State var uname: String
    @State var mail: String
    @State var uinit: String
    var body: some View {
        HStack(spacing : 20) {
            Text(uinit)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color(.systemGray3))
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

            VStack(alignment: .leading, spacing: 4) {
                Text(uname)
                    .font(.title).bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        
            
        }
        .padding([.leading,.trailing,.bottom])
    }
}

#Preview {
    TitleRowView(uname: "avi.n", mail: "", uinit: "AN")
        .background(Color(.systemTeal))
        
}
