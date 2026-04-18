//
//  MainScreenView.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import SwiftUI

struct MainScreenView: View {
    
    var body: some View {
        TabView {
            
            ChatListView()
                .tabItem { Image(systemName: "message")}
            
            UserSearchView()
                .tabItem { Image(systemName: "magnifyingglass") }
            
            ProfileView()
                .tabItem { Image(systemName: "person") }
            
        }
        .background(Color.white)
    }
    
}

#Preview {
    MainScreenView()
}
