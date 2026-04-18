//
//  ConnectionsViewModel.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift


protocol selfIdentifyProtocol2 {
    var isSelf: Bool { get }
}

class ConnectionsViewModel: ObservableObject {
    @Published var connectData: [Connection] = []
    @Published var establishedData: [Connection] = []
    @Published var pendingData: [Connection] = []
    @Published var sendedPending: [User] = []
    @Published var recievedPending: [User] = []
    @Published var establishedUsers: [User] = []
    @Published var getUser: User?
    @Published var isShowing: Bool = false
    @Published var imgName: String = "person.wave.2.fill"
    @Published var checkUser: User?
    @Published var checkConnectionUser: Connection?
    @Published var senderList: [String] = []
    @Published var recieverList: [String] = []
    @Published var connStatus:[String] = []
    @Published var acceptIsShown:Bool = false
    @Published var encryptedChats: [Chats] = []
    @Published var decryptedChats: [Chats] = []
    
    func getconnectionUserDetails(uid: String) async  {
        let connRef = Database.database().reference().child("Users").child(uid)
        
        guard let data = try? await connRef.getData() else {
            return
        }
        self.getUser = try? data.data(as: User.self)
    }
    
    
    func checkConnection(cuid: String) {
        let ref = Database.database().reference().child("Connections")
        
        ref.child(cuid).observe(.value) { checkSnapshot in
            guard let children = checkSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.senderList = children.compactMap { queryDocumentSnapshot in
                return try? queryDocumentSnapshot.data(as: Connection.self).senderId != cuid && ((try? queryDocumentSnapshot.data(as: Connection.self).recieverId == cuid) != nil) ? try? queryDocumentSnapshot.data(as: Connection.self).senderId : nil
            }
            self.recieverList = children.compactMap { queryDocumentSnapshot in
                return try? queryDocumentSnapshot.data(as: Connection.self).recieverId != cuid && ((try? queryDocumentSnapshot.data(as: Connection.self).senderId == cuid) != nil) ? try? queryDocumentSnapshot.data(as: Connection.self).recieverId : nil
            }
            self.connStatus = children.compactMap { queryDocumentSnapshot in
                return try? queryDocumentSnapshot.data(as: Connection.self).isConnected
            }
        }
    }
    

    func getEstablishedConnections(cUser: User?) {
        let ref = Database.database().reference()
        guard let cUser = cUser else { return }
        ref.child("Connections").child(cUser.id).observe(.value) { parentsnapshot in
            guard let children = parentsnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.establishedData = children.compactMap { queryDocumentSnapshot in
                guard let user = try? queryDocumentSnapshot.data(as: Connection.self) else {
                    return nil
                }
                
                if  user.isConnected == "accepted" {
                    return user
                } else {
                    return nil
                }
            }
            print(self.establishedData)
            for connect in self.establishedData {
                let retrieveuid = connect.senderId == cUser.id ? connect.recieverId : connect.senderId
                var user1: User?
                
                ref.child("Users").child(retrieveuid).observeSingleEvent(of: .value) { snapshot in
                    do {
                        user1 = try snapshot.data(as: User.self)
                        print(user1)
                        self.establishedUsers.append(user1!)
                    } catch {
                        print()
                    }
                }
                
                
            }
            print(self.establishedUsers)
            
        }

    }
    
    func getPendingConnections(uid: String) {
        let ref = Database.database().reference()
        ref.child("Connections").child(uid).observe(.value) { [self] parentsnapshot in
            guard let children = parentsnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.pendingData = children.compactMap { queryDocumentSnapshot in
                guard let user = try? queryDocumentSnapshot.data(as: Connection.self) else {
                    return nil
                }
                
                if  user.isConnected == "pending" {
                    return user
                } else {
                    return nil
                }
            }
            
            for connect in self.pendingData {
                let retrieveuid = connect.senderId == uid ? connect.recieverId : connect.senderId
                var user1: User?
                var user2: User?
                if connect.option == "decline" {
                    ref.child("Users").child(retrieveuid).observeSingleEvent(of: .value) { snapshot in
                        do {
                            user1 = try snapshot.data(as: User.self)
                            print(user1)
                            self.recievedPending.append(user1!)
                        } catch {
                            print("Error")
                        }
                    }
                } else if connect.option == "withdraw" {
                    ref.child("Users").child(retrieveuid).observeSingleEvent(of: .value) { snapshot in
                        do {
                            user2 = try snapshot.data(as: User.self)
                            print(user2)
                            self.sendedPending.append(user2!)
                        } catch {
                            print("Error")
                        }
                    }
                }
                
            }
            
        }
    }
    
    func sendConnectionRequest(sender: User,  reciever: User, passphrase: String, isConnected: String) {
        let sendref = Database.database().reference().child("Connections").child(sender.id).child(reciever.id)
        let recieveref = Database.database().reference().child("Connections").child(reciever.id).child(sender.id)
        
        let connect1 = Connection(recieverId: reciever.id, senderId: sender.id, passphrase: passphrase, isConnected: isConnected, option: "withdraw")
        let connect2 = Connection(recieverId: reciever.id, senderId: sender.id, passphrase: passphrase, isConnected: isConnected, option: "decline")
        
        let encodeData1 = connect1.toDictionary
        let encodeData2 = connect2.toDictionary
        
        sendref.setValue(encodeData1)
        recieveref.setValue(encodeData2)
        
        
    }
    
    func acceptConnectionRequest(sender: User,  reciever: User, passphrase: String) {
        let senderref = Database.database().reference().child("Connections").child(sender.id).child(reciever.id)
        let recieveref = Database.database().reference().child("Connections").child(reciever.id).child(sender.id)
        
        var passdata: String = ""
        
        senderref.child("passphrase").observeSingleEvent(of: .value) { snapshot in
            passdata = snapshot.value as? String ?? "Error in retreiving pass"
            print(passdata.count)
            print(passphrase.count)
            if passphrase == passdata {
                print(passdata)
                print(passphrase)
                senderref.child("isConnected").setValue("accepted")
                recieveref.child("isConnected").setValue("accepted")
                self.acceptIsShown = false
            } else {
                print(passdata)
                print(passphrase)
                print("condition failed")
                self.acceptIsShown = true
            }
        }
        
        
        
    }
    
    

}
