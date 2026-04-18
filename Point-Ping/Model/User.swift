//
//  User.swift
//  Point-Ping
//
//  Created by Avinash Nuthalapati on 11/30/23.
//

import Foundation

struct User:Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let uname: String
    
    
    var keywordsForLookup: [String] {
        [self.uname.generateStringSequence(), self.fullname.generateStringSequence(), self.email.generateStringSequence()]
            .flatMap { $0 }
    }
    
    
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
    
    var listElement: [String: String] {
        return ["id":self.id, "fullname":self.fullname, "email":self.email, "uname":self.uname]
    }
    
}

extension String {
    func generateStringSequence() -> [String] {
        // "Hello" => ["H","He","Hel","Hell","Hello"]
        guard self.count > 0 else { return [] }
        var sequences: [String] = []
        for i in 1...self.count {
            sequences.append(String(self.prefix(i)))
        }
        
        return sequences
    }
}

extension Encodable {
    var toDictionary : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
