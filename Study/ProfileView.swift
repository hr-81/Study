//
//  ProfileView.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import SwiftUI
import SwiftData
import Firebase

struct ProfileView: View {
    
    @StateObject var viewModel = AuthViewModel()
    @State private var usersData: [String: Any]? = nil
    
    func fetchUserData(username: String) {
        let db = Firestore.firestore()
        db.collection("users").whereField("userName", isEqualTo: username)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else if querySnapshot!.documents.isEmpty {
                    print("No such user")
                } else {
                    self.usersData = querySnapshot!.documents.first?.data()
                }
            }
    }
        
        var body: some View {
            ZStack {
                Color(.init(red: 254/255, green: 229/255, blue: 200/255, alpha: 1.0)).ignoresSafeArea(edges: .all)
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    if let profile = viewModel.profile {
                        HStack {Text("Hello,").foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0)).padding(.top).font(.custom("Inter-Regular", size: 56.0))
                            Text("\(profile.userName)!").foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0)).padding(.top).fontWeight(.black).font(.custom("Inter-Black", size: 56.0))}
                    } else {
                        RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.ultraThickMaterial).frame(width: 200, height: 40).padding(.top)
                    }
                    
                    ZStack {
                        Image("cat-border").scaleEffect(1.2)
                        VStack {
                            if let profile3 = viewModel.profile {
                                VStack {
                                    Text("Current Streak:")
                                    Text(String(profile3.streakData)).foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0)).fontWeight(.black).font(.custom("Inter-Black", size: 72))
                                }
                            } else {
                                Text("0").foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0)).fontWeight(.black).font(.custom("Inter-Black", size: 72))
                            }
                            
                        }
                        
                    }.padding(.vertical)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Friends:").font(.custom("Inter-Bold", size: 24)).padding(.leading).foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0))
                        if let profile2 = viewModel.profile {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0).foregroundColor(Color(red: 236/255, green: 183/255, blue: 121/255, opacity: 0.8))
                                ScrollView {
                                    VStack {
                                        ForEach(profile2.friends, id: \.self) { item in
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Circle().foregroundStyle(.ultraThickMaterial).frame(width: 30, height: 30)
                                                    Text(item).foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0)).padding(.trailing).font(.custom("Inter-Regular", size: 20))
                                                }.padding(.vertical)
                                                Divider().padding(.horizontal)
                                            }.padding(.horizontal)
                                        }
                                    }
                                }
                            }.padding(.all)
                        } else {
                            RoundedRectangle(cornerRadius: 25.0).padding(.all).foregroundColor(Color(red: 236/255, green: 183/255, blue: 121/255, opacity: 0.8))
                        }}.padding(.horizontal)
                    Spacer()
                }.onAppear {
                    viewModel.fetchUserProfile(uid: Auth.auth().currentUser?.uid ?? "nil")
                    
                }
            }
        }
        
        func fetchUserProfile(uid: String, completion: @escaping (UserData?, Error?) -> Void) {
            let db = Firestore.firestore()
            db.collection("users").document(uid).getDocument { (document, error) in
                if let document = document, document.exists {
                    let userData = document.data()
                    let userName = userData?["userName"] as? String ?? ""
                    let friends = userData?["friends"] as? [String] ?? [""]
                    let streakData = userData?["streakData"] as? Int ?? 0
                    let userProfile = UserData(id: uid, userName: userName, friends: friends, streakData: streakData)
                    completion(userProfile, nil)
                } else {
                    completion(nil, error)
                }
            }
        }
    

}

#Preview {
    ProfileView()
}
