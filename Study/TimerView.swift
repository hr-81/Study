//
//  TimerView.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import SwiftUI
import Firebase

struct TimerView: View {
    @StateObject var viewModel = AuthViewModel()
    
    @State private var hours = 00.0
    @State private var minutes = 00.0
    @State private var seconds = 00.0
    @State private var timertimer = Date()
    @State private var temporaryTimer = Date()
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil
    @State var buttonDisabled = false
    
    func logOutUser() {
        do {
            try Auth.auth().signOut()
            viewModel.isUserAuthenticated = false
            print("User logged out successfully")
        } catch let signOutError as NSError {
            print("Error during sign out", signOutError)
        }
    }
    
    func startTimer() {
        timerIsPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1.0), repeats: true) { tempTimer in
            if ((self.seconds == 59) && (self.minutes != 59)) {
                
                self.seconds = 0
                self.minutes += 1
                
            } else if((self.minutes == 59) && (self.seconds == 59)) {
                self.seconds = 0
                self.minutes = 0
                self.hours += 1
            }else {
                self.seconds += 1
            }
        }
        timer?.tolerance = 0
    }
    func pauseTimer() {
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        minutes = 0
        seconds = 0
        pauseTimer()
        buttonDisabled = false
    }
    var body: some View {
        ZStack {
            Color(.init(red: 254/255, green: 229/255, blue: 200/255, alpha: 1.0)).ignoresSafeArea(edges: .all)
            VStack(alignment: .center){
                if let profile = viewModel.profile {
                    HStack {Text("Hello,").foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0)).padding(.top).font(.custom("Inter-Regular", size: 56.0))
                        Text("\(profile.userName)!").foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0)).padding(.top).fontWeight(.bold).font(.custom("Inter-Black", size: 56.0))}
                } else {
                    RoundedRectangle(cornerRadius: 25.0).foregroundStyle(.ultraThickMaterial).frame(width: 200, height: 40).padding(.vertical)
                }
                
                ZStack {
                    Image("cat-border").scaleEffect(1.2)
                    VStack {
                        Text("\(String(format: "%02i",Int(hours))):\(String(format:"%02i",Int(minutes))):\(String(format: "%02i",Int(seconds)))").font(.custom("Inter-Bold", size: 36)).foregroundColor(Color(red: 66/255, green: 133/255, blue: 161/255, opacity: 1.0))
                        
                    }
                    
                }.padding(.vertical)
                
                HStack {
                    
                    Button(action: {resetTimer()}, label: {
                        ZStack {
                            Image("yarn").blur(radius: 2.0)
                            Image(systemName: "arrow.counterclockwise").foregroundStyle(.white).scaleEffect(3.0).bold()
                        }
                    }).buttonStyle(.borderless)
                    ZStack {
                        Image("yarn-orange").blur(radius: 1.0).padding(.horizontal).scaleEffect(1.1)
                            Text("0").font(.system(size: 64.0)).bold().foregroundStyle(.white)
                        
                    }
                    Button(action: {startTimer()}, label: {
                        ZStack {
                            Image("yarn").blur(radius: 2.0)
                            Image(systemName: "play.fill").foregroundStyle(.white).scaleEffect(3.0)
                        }
                    }).buttonStyle(.borderless)
                    
                }.padding(.all)
                
                //Spacer()
                
                    ZStack {
                        RoundedRectangle(cornerRadius: 20.0).padding(.all).foregroundStyle(.thickMaterial)
                        HStack(alignment: .center, spacing: 20) {
                            VStack {
                                Circle().foregroundColor(.orange).frame(width: 5, height: 5)
                                Text("26").foregroundColor(.gray).font(.custom("Inter-Regular", size: 20))
                            }
                            VStack {
                                Circle().foregroundColor(.orange).frame(width: 5, height: 5)
                                Text("27").foregroundColor(.gray).font(.custom("Inter-Regular", size: 20))
                            }
                            VStack {
                                Circle().foregroundColor(.clear).frame(width: 5, height: 5)
                                Text("28").foregroundColor(.gray).font(.custom("Inter-Regular", size: 20))
                            }
                            VStack {
                                Circle().foregroundColor(.orange).frame(width: 5, height: 5)
                                Text("29").foregroundColor(.gray).font(.custom("Inter-Regular", size: 20))
                            }
                            VStack {
                                Circle().foregroundColor(.clear).frame(width: 5, height: 5)
                                Text("1").foregroundColor(.gray).font(.custom("Inter-Regular", size: 20))
                            }
                            VStack {
                                Circle().foregroundColor(.orange).frame(width: 5, height: 5)
                                Text("2").foregroundColor(.gray).font(.custom("Inter-Regular", size: 20))
                            }
                            VStack {
                                Circle().foregroundColor(.orange).frame(width: 5, height: 5)
                                Text("3").foregroundColor(.gray).font(.custom("Inter-Regular", size: 20))
                            }
                            
                        }.padding(.horizontal)
                    }.frame(width: 350, height: 150)
                .padding(.horizontal)
                
                
                
            }.padding(.bottom)
                .buttonStyle(.bordered)
            .onAppear {
                    viewModel.fetchUserProfile(uid: Auth.auth().currentUser?.uid ?? "nil")
            }
        }
    }
}

#Preview {
    TimerView()
}
