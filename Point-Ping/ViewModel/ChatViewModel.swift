//
//  ChatViewModel.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import FirebaseAuth
import Foundation
import Firebase
import FirebaseCore
import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift
import CryptoKit

protocol selfIdentifyProtocol4 {
    var isSelf: Bool { get }
}

class ChatViewModel: ObservableObject {
    @Published var encryptedchats: [Chats] = []
    @Published var decryptedchats: [Chats] = []
    @Published var isPassAccepted: Bool = false
    @Published var connVerify: Connection? = nil
    @Published var pass: String = ""


    
    func retriveMessages(sender: User,  reciever: User) {
        let ref = Database.database().reference()
        
        ref.child("Messages").child(sender.id).child(reciever.id).observe(.value) { parentsnapshot in
            guard let children = parentsnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.encryptedchats = children.compactMap {childsnap in
                do {
                    return try childsnap.data(as: Chats.self)
                } catch {
                    print("Error messages")
                    return nil
                }
            }
            
            
            var pass = ""
            Database.database().reference().child("Connections").child(sender.id).child(reciever.id).observeSingleEvent(of: .value) {snap in
                do {
                    let object = try snap.data(as: Connection.self)
                    pass = object.passphrase
                    self.encryptedchats.sort {$0.timeStamp < $1.timeStamp}
                    for chat in self.encryptedchats {
                        let key =  self.generateDynamicKey(passphrase: pass, date: chat.date, time: chat.time)
                        let decryptedText = try self.decryptMessage(encryptedMessage: chat.text, key: key)
                        self.decryptedchats.append(Chats(text: decryptedText, isReceived: chat.isReceived, date: chat.date, time: chat.time, timeStamp: chat.timeStamp))
                    
                    }
                    print("displayyy -- ",self.decryptedchats)
                } catch {
                    
                }
            }
        }
        
    }
    
    func sendMessage(sender: User,  reciever: User, message: String) {
        let senderref = Database.database().reference().child("Messages").child(sender.id).child(reciever.id)
        let recieveref = Database.database().reference().child("Messages").child(reciever.id).child(sender.id)
        
        var passPhrase = ""
        Database.database().reference().child("Connections").child(sender.id).child(reciever.id).observeSingleEvent(of: .value) {snap in
            do {
                let object = try snap.data(as: Connection.self)
                passPhrase = object.passphrase
                print(passPhrase, " === testing retriveal")
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                let timeFormatter = DateFormatter()
                let timeStamp = DateFormatter()
                dateFormatter.dateFormat = "yyMMdd"
                timeFormatter.dateFormat = "HHmmss"
                timeStamp.dateFormat = "yyMMddHHmmss"
                
                let formattedDate = dateFormatter.string(from: currentDate)
                let formattedTime = timeFormatter.string(from: currentDate)
                let formattedTimeStamp = timeStamp.string(from: currentDate)
                
                print(formattedDate," -- ", formattedTime)
                
                let key = self.generateDynamicKey(passphrase: passPhrase, date: formattedDate, time: formattedTime)
                print("Key while encrypting === ",self.displayKeyContents(key: key))
                let encryptedMessage = try self.encryptMessage(message: message, key: key)
                
                let sentMessage = Chats(text: encryptedMessage, isReceived: false, date: formattedDate, time: formattedTime, timeStamp: formattedTimeStamp)
                let receivedMessage = Chats(text: encryptedMessage, isReceived: true, date: formattedDate, time: formattedTime, timeStamp: formattedTimeStamp)
                
                senderref.child(formattedDate+formattedTime).setValue(sentMessage.toDictionary)
                recieveref.child(formattedDate+formattedTime).setValue(receivedMessage.toDictionary)
                
                print(sentMessage)
                
                self.encryptedchats.append(sentMessage)
                if self.isPassAccepted {
                    let decryptedNewMessage = Chats(text: message, isReceived: false, date: formattedDate, time: formattedTime, timeStamp: formattedTimeStamp)
                    self.decryptedchats.append(decryptedNewMessage)
                } else {
                    self.decryptedchats.append(sentMessage)
                }
            } catch {
                print("Unable to get passphrase")
            }
        }
        
        
    }
    

    
    func verifyPassPhraseGiven(sender: User,  reciever: User, passphrase: String) {
        let senderref = Database.database().reference().child("Connections").child(sender.id).child(reciever.id)
        var connStatus = ""
        var passdata = ""
        
        //self.retriveMessages(sender: sender, reciever: reciever)
        print("verification ------- ",self.encryptedchats)
        senderref.child("isConnected").observeSingleEvent(of: .value) { snapshot in
            connStatus = snapshot.value as? String ?? "Error in retreiving pass"
            if connStatus == "accepted" {
                senderref.child("passphrase").observeSingleEvent(of: .value) { snapshot2 in
                    passdata = snapshot2.value as? String ?? "Error with passdata"
                    if passdata == passphrase {
                        self.isPassAccepted = true
//                        //self.decryptedchats = []
//                        print("encrypted chats === > ",self.encryptedchats)
//                        for chat in self.encryptedchats {
//                            print("for verification -- ",chat.text)
//                            let key = self.generateDynamicKey(passphrase: passphrase, date: chat.date, time: chat.time)
//                            print("Key for decryption ====== ", key)
//                            let decryptedText = try self.decryptMessage(encryptedMessage: chat.text, key: key)
//                            print("decrypted chat ======== ", decryptedText)
//                            let decryptedChat = Chats(text: decryptedText, isReceived: chat.isReceived, date: chat.date, time: chat.time, timeStamp: chat.timeStamp)
//                            self.decryptedchats.append(decryptedChat)
//                        }
//                        self.decryptedchats.sort {$0.timeStamp < $1.timeStamp}
//                        print("dispay decrypted ----> ", self.decryptedchats)
                    } else {
                        self.isPassAccepted = false
                    }
                }
                } else {
                print("not connected")
                
            }
        }
    }


    
    
    func displayKeyContents(key: SymmetricKey) {
        let keyData = key.withUnsafeBytes { Data($0) }
        let hexString = keyData.map { String(format: "%02hhx", $0) }.joined()
        print("Hexadecimal representation of the key: \(hexString)")
    }
    
    
    // Generate Dynamic Key
    func generateDynamicKey(passphrase: String, date: String, time: String) -> SymmetricKey {
        print(date," === ", time, " === ==== ", passphrase)
        var hasher = SHA256()
        let combinedString = date + passphrase + time
        let inputData = Data(combinedString.utf8)
        hasher.update(data: inputData)
        return SymmetricKey(data: hasher.finalize())
    }

    // Encrypt Message
    func encryptMessage(message: String, key: SymmetricKey) throws -> String {
        let data = Data(message.utf8)
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!.base64EncodedString()
    }

    // Decrypt Message
    func decryptMessage(encryptedMessage: String, key: SymmetricKey) throws -> String {
        let encryptedData = Data(base64Encoded: encryptedMessage)!
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(decoding: decryptedData, as: UTF8.self)
    }
    
}
