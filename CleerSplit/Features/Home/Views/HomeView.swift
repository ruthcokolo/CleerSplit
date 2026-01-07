//
//  HomeView.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2025-12-29.
//


import UIKit
import SwiftUI
import PhotosUI

// MARK: - Root with Tabs

struct AttachedCTA: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(hex: "#FD29A9"))
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
        .shadow(color: .black.opacity(0.40), radius: 18, x: 0, y: 10)
    }
}

struct RootTabView: View {
    @StateObject private var profileStore = ProfileStore()
    
    init() {
        UITabBar.appearance().isHidden = true // backup
    }

    enum Tab: Hashable, CaseIterable {
        case home, groups, balances, search, profile

        var title: String {
            switch self {
            case .home: "Home"
            case .groups: "Groups"
            case .balances: "Balances"
            case .search: "Search"
            case .profile: "Profile"
            }
        }

        var icon: String {
            switch self {
            case .home: "house"
            case .groups: "person.2"
            case .balances: "dollarsign"
            case .search: "magnifyingglass"
            case .profile: "person"
            }
        }
    }

    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tag(Tab.home)
            PlaceholderView(title: "Groups").tag(Tab.groups)
            PlaceholderView(title: "Balances").tag(Tab.balances)
            PlaceholderView(title: "Search").tag(Tab.search)
            PlaceholderView(title: "Profile").tag(Tab.profile)
        }
        // Hide the system TabView tab bar (we’re using a custom one)
        .toolbar(.hidden, for: .tabBar)
        .environmentObject(profileStore)
        
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomDock(
                selectedTab: selectedTab,
                onHomeCTA: { print("Add expense") },
                onGroupsCTA: { print("Create group") },
                onSelectTab: { selectedTab = $0 }
            )
            
            .safeAreaPadding(.bottom)
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}



struct BottomDock: View {
    let selectedTab: RootTabView.Tab
    let onHomeCTA: () -> Void
    let onGroupsCTA: () -> Void
    let onSelectTab: (RootTabView.Tab) -> Void

    private let plateHeight: CGFloat = 124
    private let corner: CGFloat = 28

    var body: some View {
        VStack(spacing: 12) {

            // CTA only for Home + Groups (NOT profile)
            if selectedTab == .home || selectedTab == .groups {
                ZStack {
                    // “layer blur 20” behind CTA
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.black.opacity(0.85))
                        .blur(radius: 20)
                        .frame(height: 70)

                    AttachedCTA(title: selectedTab == .home ? "Add new expense" : "Create Group") {
                        selectedTab == .home ? onHomeCTA() : onGroupsCTA()
                    }
                }

                .padding(.top, 12)
            } else {
                // keeps spacing consistent when no CTA
                Spacer().frame(height: 6)
            }

            // Icons row
            HStack {
                ForEach(RootTabView.Tab.allCases, id: \.self) { tab in
                    Button {
                        onSelectTab(tab)
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 18, weight: .semibold))
                            Text(tab.title)
                                .font(.caption2.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(
                            selectedTab == tab ? Color(hex: "#44C099") : Color.white.opacity(0.65)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)

        }
        .frame(maxWidth: .infinity)
        .frame(height: plateHeight)
        .background(
            ZStack {
                
                BlurView(style: .systemUltraThinMaterialDark)
                    .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))

            
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(Color(hex: "#000000").opacity(0.92))

            
            }
        )
        .padding(.horizontal, 18)
        .padding(.bottom, 10) // sits on bottom safe area, not floating randomly
        .shadow(color: .black.opacity(0.75), radius: 24, x: 0, y: 18)
    }
    
  
}



struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}



struct PlaceholderView: View {
    let title: String
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text(title).foregroundStyle(.white)
        }
    }
}

// MARK: - Home Screen

struct HomeView: View {
    
    @State private var showNotifications = false
    @EnvironmentObject private var profileStore: ProfileStore


    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.black, Color.black.opacity(0.90), Color.black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {

                    header

                    // Card 1
                    FrostCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Let’s get started!")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.white)

                            Text("To kick things off, create your first group and expenses.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.70))

                            PrimaryPillButton(title: "Create your first group", systemImage: "arrow.right") {
                                // TODO: navigate
                            }
                            .padding(.top, 6)
                        }
                    }

                    // Section label
                    Text("Today’s Priority")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.top, 6)

                    // Card 2
                    FrostCard {
                        VStack(alignment: .center, spacing: 10) {
                            Text("No Current priority items yet.")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.white)

                            Text("Start by creating a new group or\nadding an expense.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.70))

                            PrimaryPillButton(title: "Add your first expense", systemImage: "arrow.right") {
                                // TODO: navigate
                            }
                            .padding(.top, 6)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    // Section label
                    Text("Last Group Expense Visited")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.top, 6)

                    // Card 3
                    FrostCard {
                        HStack(alignment: .center, spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.08))
                                    .frame(width: 54, height: 54)

                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 26))
                                    .foregroundStyle(Color.white.opacity(0.9))
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("No activity yet.")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.white)

                                Text("Get started by creating your first group.")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.70))
                            }

                            Spacer()
                        }
                    }

                   
                    .padding(.top, 10)

                    Spacer().frame(height: 170)

                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
                .padding(.bottom, 200)
            }
        }
        
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }

    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Home")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)

                Text("Welcome to CleerSplit, \(profileStore.firstName)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.65))
            }

            Spacer()

            // Profile photo with notification icon attached (tap → notifications)
            ZStack(alignment: .bottomTrailing) {

                // Profile photo
                Image("profile_photo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )

                // Notification icon attached to the photo
                Button {
                    // Navigate / present notifications
                    showNotifications = true
                } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.black.opacity(0))
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                }
                .offset(x: -2, y: 2) // tiny nudge
            }

        }
        .padding(.bottom, 6)
        .padding(.trailing, 6)
        
       
    }
}


// MARK: - Components

struct FrostCard<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 10)

            content
                .padding(18)
        }
    }
}

struct PrimaryPillButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                    .font(.headline.weight(.semibold))
                Image(systemName: systemImage)
                    .font(.headline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .background(
                LinearGradient(colors: [Color(hex: "#FD29A9"), Color(hex: "#FD29A9").opacity(0.75)],
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}


struct NotificationsView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Notifications")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)

                Text("This is a placeholder screen.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
}


// MARK: - Helpers

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}



// MARK: - Preview

#Preview {
    RootTabView()
}
