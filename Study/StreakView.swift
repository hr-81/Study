//
//  StreakView.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import SwiftUI
import Firebase

struct StreakView: View {
    @StateObject var viewModel = AuthViewModel()
    
    @State private var temporaryUserName = ""
    @State private var userStreakData = 0
    @State private var temporaryFriends = [""]
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            viewModel.isUserAuthenticated = false
            print("User logged out successfully")
        } catch let signOutError as NSError {
            print("Error during sign out", signOutError)
        }
    }
    func resetPassword() {
        do {
            try Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser?.email ?? "")
            print("Password reset email sent successfully")
        } catch let passwordResetError as NSError {
            print("Error during password reset", passwordResetError)
        }
    }
    func saveUserDataIfNeeded(userName: String, userFriends: [String], streakData: Int) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No signed-in user available.")
            return
        }
        
        let userData = UserData(id: Auth.auth().currentUser?.uid ?? "nil", userName: userName, friends: userFriends, streakData: streakData)
        saveUserData(user: currentUser, userData: userData)
    }
    var body: some View {
        List {
            Section {
                TextField("User Name", text:$temporaryUserName)
                Button(action: {
                    /*userStreakData = 0
                    saveUserDataIfNeeded(userName: temporaryUserName, userFriends: viewModel.profile?.friends ?? [""], streakData: viewModel.profile?.streakData ?? 0)*/
                }) {
                    Text("Reset Streak")
                }
            }.onSubmit {
                //saveUserDataIfNeeded(userName: temporaryUserName, userFriends: viewModel.profile?.friends ?? [""], streakData: viewModel.profile?.streakData ?? 0)
            }.onAppear {
               /* userStreakData = viewModel.profile?.streakData ?? 0
                temporaryUserName = viewModel.profile?.userName ?? "Unknown"
                temporaryFriends = viewModel.profile?.friends ?? [""]*/
            }
            Section {
                Button(action:{
                    logOutUser()
                }) {
                    Text("Log out")
            }
            }
        }.navigationTitle("Settings")
    }
}

#Preview {
    StreakView()
}
