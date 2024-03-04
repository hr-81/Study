//
//  AuthView.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import SwiftUI
import SwiftData
import Firebase

struct AuthView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        VStack {
            TextField("Username", text:$email).textContentType(.username)
            TextField("Password", text:$password).textContentType(.password)
            Button(action: {
                registerUser()
            }) {
                Text("Register")
            }
            Button(action: {
                loginUser()
            }) {
                Text("Login")
            }
        }
    }
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
}

#Preview {
    AuthView()
}
