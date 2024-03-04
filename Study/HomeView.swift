//
//  HomeView.swift
//  hoth-xi
//
//  Created by Hudson Roddy on 3/3/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = AuthViewModel()
    var body: some View {
        if(viewModel.isUserAuthenticated == false) {
            OnboardingView()
        } else if(viewModel.isUserAuthenticated == true) {
                ContentView()
        }
    }
}

#Preview {
    HomeView()
}
