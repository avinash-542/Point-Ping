//
//  UserSearchViewModel.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import FirebaseAuth
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

protocol selfIdentifyProtocol {
    var isSelf: Bool { get }
}

class UserSearchViewModel: ObservableObject {
    @Published var queriedUsers : [User] = []
    @Published var finalresults : [User] = []
    
    
    func fetchUsers(from keyword: String) {
        let ref = Database.database().reference().child("Users")
        let uid = Auth.auth().currentUser?.uid
        ref.observe(.value) { parentsnapshot in
            guard let children = parentsnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            self.queriedUsers = children.compactMap { queryDocumentSnapshot in
                guard let user = try? queryDocumentSnapshot.data(as: User.self) else {
                    return nil
                }
                
                if user.keywordsForLookup.contains(keyword) && user.id != uid {
                    return user
                } else {
                    return nil
                }
            }
            
        }
        
    }
    
}
