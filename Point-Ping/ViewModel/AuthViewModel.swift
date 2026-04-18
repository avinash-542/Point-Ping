//
//  AuthViewModel.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift


protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: Firebase.User?
    @Published var currentUser: User? = nil
    
    private var ref = Database.database().reference()
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signin(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to sign In!!")
        }
    }
    
    func createUser(withEmail email:String, password: String, fullname : String, uname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let refdb = Database.database().reference().child("Users")
            let user = User(id: result.user.uid, fullname: fullname, email: email, uname: uname)
            let jencodedUser = user.toDictionary
            try await refdb.child(result.user.uid).setValue(jencodedUser)
            try await refdb.child(result.user.uid).updateChildValues(["keywordsForLookup":user.keywordsForLookup])
            // firestore code
//            let encodedUser = try Firestore.Encoder().encode(user)
//            let doc =  Firestore.firestore().collection("Users").document(user.id)
//            try await doc.setData(encodedUser)
//            try await doc.updateData(["keywordsForLookup":user.keywordsForLookup])
            print(result.user)
            await fetchUser()
        } catch {
            print("Failed to create a user")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out!!")
        }
    }
    
    
    func fetchUser() async {
        let ref = Database.database().reference().child("Users")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let refSnap = try? await ref.child(uid).getData() else {return}
        self.currentUser = try? refSnap.data(as: User.self)
        // firestore code
//        guard let snapshot = try? await Firestore.firestore().collection("Users").document(uid).getDocument() else { return }
//        self.currentUser = try? snapshot.data(as: User.self)
        
    }
    
   
}
