//
//  UserData.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Firebase


struct UserData {
    var id: String
    var userName: String
    var friends: [String]
    var streakData: Int
}

func saveUserData(user: User, userData: UserData) {
    let db = Firestore.firestore()
    let data: [String: Any] = [
        "userName": userData.userName,
        "friends": userData.friends,
        "streakData": userData.streakData
    ]
    
    db.collection("users").document(user.uid).setData(data) { error in
        if let error = error {
            print("Error writing document: \(error)")
        } else {
            print("Document successfully written!")
        }
    }
}

