//
//  CircularBottomTabBarView.swift
//  Point-Ping
//
//  Created by Avinash Reddy Nuthalapati on 1/31/25.
//

import SwiftUI


public struct CircularBottomTabBarView<Content: View>: View {
    public var content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            Circle().stroke(Color.gray, lineWidth: 1)
        }
    }
}


#Preview {
    CircularBottomTabBarView(content:   { Text("Hello") })
}
