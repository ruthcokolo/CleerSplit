//
//  WelcomeView.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2026-01-03.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 253/255, green: 41/255, blue: 169/255), // pink
                    Color(red: 68/255, green: 192/255, blue: 153/255)  // teal
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Everything on top
            VStack(spacing: 24) {

                // Title
                Text("Welcome to CleerSplit")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)

                // Subtitle
                Text("The easiest way to manage shared expenses with friends, family and teams.")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)

             

                // Cards
                VStack(spacing: 18) {
                    FeatureCard(
                        title: "Split bills, not friendships.",
                        bodyText: "CLEERSPLIT keeps your relationships strong by handling shared payments with kindness.\nNo more awkward reminders, just smooth, automatic accountability"
                    )

                    FeatureCard(
                        title: "Plan together, stress less.",
                        bodyText: "Whether it’s a family goal, trip or group project, CLEERSPLIT helps everyone stay organized and focused on what really matters, the experience."
                    )

                    FeatureCard(
                        title: "Celebrate your wins.",
                        bodyText: "Track your group’s progress, see who paid, and enjoy achieving goals together. Finances made joyful, transparent and fair."
                    )
                }

       
                // Buttons
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Text("Log In")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.pink)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }

                    Button(action: {}) {
                        Text("Sign Up")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.black.opacity(0.85))
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
}

struct FeatureCard: View {
    let title: String
    let bodyText: String

    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(bodyText)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.18))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.25), lineWidth: 1)
        )
    }
}

#Preview {
    WelcomeView()
}
