//
//  Connection.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import Foundation


struct Connection: Codable {
    let recieverId: String
    let senderId: String
    let passphrase: String
    let isConnected: String
    let option: String
    
}
