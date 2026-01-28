//
//  AppFlowView.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2026-01-07.
//

import SwiftUI

struct AppFlowView: View {
    @StateObject private var auth = AuthStore()

    var body: some View {
        Group {
            switch auth.state {
            case .signedOut:
                WelcomeView()
                    .environmentObject(auth)

            case .signingIn:
                LoginView()
                    .environmentObject(auth)

            case .signedIn:
                RootTabView()
                    .environmentObject(auth) // so Home can read firstName
            }
        }
    }
}


#Preview {
    AppFlowView()
}
