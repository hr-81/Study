//
//  ContentView.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import SwiftUI
import SwiftData
import Firebase

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = AuthViewModel()
    
    @Query private var items: [Item]
    @State private var userName = ""
    @State private var userFriends = [""]
    @State private var userStreakData = 0

    let db = Firestore.firestore()
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            viewModel.isUserAuthenticated = false
            print("User logged out successfully")
        } catch let signOutError as NSError {
            print("Error during sign out", signOutError)
        }
    }
    
    func saveUserDataIfNeeded(userName: String, userFriends: [String], streakData: Int) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No signed-in user available.")
            return
        }
        
        let userData = UserData(id: Auth.auth().currentUser?.uid ?? "nil", userName: userName, friends: userFriends, streakData: userStreakData)
        saveUserData(user: currentUser, userData: userData)
    }
  
    var body: some View {
            TabView {
                TimerView().tabItem { VStack {
                    Image(systemName: "timer.circle")
                    Text("Timer")
                }
                }
                ProfileView().tabItem { VStack {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                }
                StreakView().tabItem { VStack {
                    Image(systemName: "gear.circle.fill")
                    Text("Settings")
                }
                }
            }
       
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
