//
//  LoginView.swift
//  CleerSplit
//
//  Created by Chidinma on 2025-12-29.
//

import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 253/255, green: 41/255, blue: 169/255), //magenta
                    Color(red: 68/255, green: 192/255, blue: 153/255)  //teal green
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Card
            VStack(spacing: 20) {

                // Title
                HStack(spacing: 0) {
                    Text("CLEER")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)

                    Text("SP")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color(red: 68/255, green: 192/255, blue: 153/255))

                    Text("LIT")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color(red: 253/255, green: 41/255, blue: 169/255))
                }
                

                // Email
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    TextField("you@example.com", text: $email)
                        .font(.system(size: 14))
                        .foregroundStyle(.black) // typed text color
                        .tint(.black)            // cursor + selection
                        .padding(.horizontal, 15)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                

                // Password
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Forgot?")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    SecureField("••••••••••", text: $password)
                        .foregroundStyle(.black) //typed text
                        .tint(.black) //cursor color
                        .padding()
                        .frame(height: 52)
                        .background(Color.white)
                        .cornerRadius(15)
                }

                // Remember me
                Toggle("Remember me", isOn: $rememberMe)
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 253/255, green: 41/255, blue: 169/255)))
                    .foregroundColor(.white)
                    .font(.caption)

                // Sign in button
                Button(action: {}) {
                    Text("Sign In")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 253/255, green: 41/255, blue: 169/255))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }

                Divider().background(.white.opacity(0.5))

                // Social login
                HStack(spacing: 16) {
                    SocialButton(title: "Google", imageName: "google_logo") {
                        // TODO: Google sign-in
                    }

                    SocialButton(title: "Apple", imageName: "apple_logo")
                    {

                        // TODO: Apple sign-in
                    }
                }

                // Sign up
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                    Text("Sign Up")
                        .font(.caption)
                        .fontWeight(.bold)
                        .underline()
                        .foregroundColor(.white)
                }

            }
            .padding()
            .frame(width: 323, height: 613)
            .background(.ultraThinMaterial)
            .cornerRadius(35)
        }
    }
}


#Preview {
    LoginView()
}
