//
//  OnboardingView.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import SwiftUI
import SwiftData
import Firebase


public class AuthViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var profile: UserData?
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.isUserAuthenticated = user != nil
        }
    }
    func fetchUserProfile(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists, let data = document.data() else { return }
            
            let userName = data["userName"] as? String ?? "Unknown User"
            let friends = data["friends"] as? [String] ?? ["No Friends"]
            let streakData = data["streakData"] as? Int ?? 0
            
            DispatchQueue.main.async {
                self.profile = UserData(id: uid, userName: userName, friends: friends, streakData: streakData)
            }
        }
    }
}


struct OnboardingView: View {
    @State private var isSignIn = true
    @State private var email = ""
    @State private var password = ""

    func registerUser() {
          Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
              if let error = error {
                  print(error.localizedDescription)
              } else {
                  print("User registered successfully")
              }
          }
      }
      
      func loginUser() {
          Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              if let error = error {
                  print(error.localizedDescription)
              } else {
                  print("User logged in successfully")
              }
          }
      }
    
    var body: some View {
        ZStack {
            Color(.green).ignoresSafeArea(.all)
            if(isSignIn == true) {
                VStack {
                    Text("Sign In")
                    Spacer()
                    TextField("Username", text:$email).textContentType(.username).textFieldStyle(.roundedBorder).padding(.bottom)
                    TextField("Password", text:$password).textContentType(.password).textFieldStyle(.roundedBorder).padding(.bottom)
                    Button(action: {
                        loginUser()
                    }) {
                        Text("Login")
                    }
                    Spacer()
                    Button(action:
                            {
                        isSignIn = false
                    }) {
                        Text("Sign up instead")
                    }
                    
                    
                }.padding(.all)
            } else if(isSignIn == false) {
                VStack(alignment: .center, spacing: 15) {
                    Text("Create an Account")
                    VStack(alignment: .center, spacing: 5) {
                        TextField("Username", text:$email).textContentType(.username).textFieldStyle(.roundedBorder)
                        TextField("Password", text:$password).textContentType(.password).textFieldStyle(.roundedBorder)
                        Button(action: {
                            registerUser()
                        }) {
                            Text("Register")
                        }.buttonStyle(.bordered)

                    }.padding(.all)
                    Button(action: {
                        email = ""
                        password = ""
                        isSignIn = true
                    }) {
                        Text("Return to Sign In")
                    }.buttonStyle(.bordered)
                }.padding(.all)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
