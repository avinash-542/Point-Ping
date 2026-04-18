//
//  ProfileHeadView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct ProfileHeadView: View {
    @Binding var uname: String
    @Binding var mail: String
    @Binding var uinit: String
    
    
    var body: some View {
        Section {
            HStack {
                Text(uinit)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(Color(.systemGray3))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                VStack(alignment: .leading, spacing: 4) {
                    Text(uname)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 4)
                    
                    Text(mail)
                        .font(.footnote)
                        .accentColor(.gray)
                }
            }
        }
    }
}



#Preview {
    ProfileHeadView(uname: .constant("User Name"), mail: .constant("test123@gmail.com"), uinit: .constant("UN"))
}
