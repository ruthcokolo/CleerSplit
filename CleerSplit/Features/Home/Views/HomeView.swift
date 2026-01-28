//
//  HomeView.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2025-12-29.
//

import UIKit
import SwiftUI

// MARK: - Root with Tabs

/// RootTabView hosts the app's main tab bar and global overlays.
/// It configures UITabBar appearance and presents the Add Expense sheet.
struct RootTabView: View {
    // Profile data source shared with child tabs
    @StateObject private var profileStore = ProfileStore()
    
    // Authentication store for user identity and auth state
    @StateObject private var authStore = AuthStore()
    
    // Toggles the presentation of the Add Expense bottom sheet
    @State private var showAddExpenseSheet: Bool = false
    
    // Controls navigation to the Group Expense Details screen
    @State private var navigateToGroupExpenseDetails: Bool = false
    
    // Controls navigation to Group Type Selection View
    @State private var navigateToGroupTypeSelection: Bool = false
    
    /// Configures the UIKit tab bar with blur, colors, and selected state styling.
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Apply a subtle blur effect to the tab bar background
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        // Semi-transparent black background color for tab bar
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.82)
        
        // Custom teal color for selected tab icons and titles
        let tealColor = UIColor(red: 68/255, green: 192/255, blue: 153/255, alpha: 1)
        
        // Set selected tab icon and title colors
        appearance.stackedLayoutAppearance.selected.iconColor = tealColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: tealColor]
        
        // Set unselected tab icon and title colors with some transparency
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.8)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        
        // Apply the customized appearance to all tab bars in the app
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Make sure the tab bar is visible
        UITabBar.appearance().isHidden = false
    }
    
    // Supported tabs with title and icon
    enum Tab: Hashable, CaseIterable {
        case home, groups, balances, cleer, profile
        
        var title: String {
            switch self {
            case .home: "Home"
            case .groups: "Groups"
            case .balances: "Balances"
            case .cleer: "Cleer"
            case .profile: "Profile"
            }
        }
        
        var icon: String {
            switch self {
            case .home: "house"
            case .groups: "person.2"
            case .balances: "dollarsign"
            case .cleer: "sparkles"
            case .profile: "person"
            }
        }
    }
    
    // Currently selected tab
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // SwiftUI TabView hosting the five sections
                TabView(selection: $selectedTab) {
                    HomeView(
                        onCreateGroupTap: {
                            // TODO: navigate to GroupTypeSelectionView
                            navigateToGroupTypeSelection = true
                        },
                        onAddFirstExpenseTap: {
                                showAddExpenseSheet = true
                            }
                    )
                        .tag(Tab.home)
                        .tabItem {
                            Image(systemName: Tab.home.icon)
                            Text(Tab.home.title)
                        } // Home tab
                    
                    PlaceholderView(title: "Groups")
                        .tag(Tab.groups)
                        .tabItem {
                            Image(systemName: Tab.groups.icon)
                            Text(Tab.groups.title)
                        } // Groups tab
                    
                    PlaceholderView(title: "Balances")
                        .tag(Tab.balances)
                        .tabItem {
                            Image(systemName: Tab.balances.icon)
                            Text(Tab.balances.title)
                        } // Balances tab
                    
                    PlaceholderView(title: "Cleer")
                        .tag(Tab.cleer)
                        .tabItem {
                            Image(systemName: Tab.cleer.icon)
                            Text(Tab.cleer.title)
                        } // Cleer tab
                    
                    PlaceholderView(title: "Profile")
                        .tag(Tab.profile)
                        .tabItem {
                            Image(systemName: Tab.profile.icon)
                            Text(Tab.profile.title)
                        } // Profile tab
                }
                // Inject shared stores into subtree
                .environmentObject(profileStore)
                .environmentObject(authStore)
                
                // Keep tab bar fixed when keyboard appears
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                // Apply UIKit appearance once the view appears
                .onAppear { configureTabBarAppearance() }
                
                // Floating Add Expense CTA shown only on Home tab
                if selectedTab == .home {
                    VStack {
                        
                        Spacer()
                        // Tapping the CTA opens the Add Expense sheet
                        AddExpenseCTA(title: "Add New Expense", action: {
                            showAddExpenseSheet = true
                        })
                        .padding(.bottom, 55)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    .animation(.easeInOut, value: selectedTab)
                    
                }
            }
            // Blur main content while the Add Expense sheet is visible
            .blur(radius: showAddExpenseSheet ? 10 : 0)
            
            // Dim the background when the sheet is presented
            .overlay(
                Group {
                    if showAddExpenseSheet {
                        Color.black.opacity(0.25)
                            .ignoresSafeArea()
                            .transition(.opacity)
                    }
                }
            )
            
            // Animate blur/dimming transitions
            .animation(.easeInOut(duration: 0.2), value: showAddExpenseSheet)
            
            
            // Present the Add Expense flow as a bottom sheet
            .sheet(isPresented: $showAddExpenseSheet) {
                AddExpenseSheetView(
                    onGroupExpense: {
                        // Later: route to Group Expense creation
                        navigateToGroupExpenseDetails = true
                    },
                    onPersonalExpense: {
                        // Later: route to Personal Expense creation
                    }
                )
                // Matches the height shown in your design
                .presentationDetents([.height(325)])
                
                // Displays the grab handle at the top
                .presentationDragIndicator(.visible)
                
                // Rounded sheet corners
                .presentationCornerRadius(28)
                
                // Allows custom dimming behind the sheet
                .presentationBackground(.clear)
                
                // Make sheet content fill horizontally and ignore bottom safe area insets
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.container, edges: .bottom)
            }
            
            // Navigates to the Group Type Selection screen when the state becomes true
            .navigationDestination(isPresented: $navigateToGroupExpenseDetails) {
                SelectGroup()
                // Hide SwiftUI’s automatic back button (top-left)
                .navigationBarBackButtonHidden(true)
                
            }
            .navigationDestination(isPresented: $navigateToGroupTypeSelection) {
                GroupTypeSelectionView()
                // Hide SwiftUI’s automatic back button (top-left)
                .navigationBarBackButtonHidden(true)
                
            }
        }
    }
    
    
    /// Bottom sheet that lets the user choose between Group and Personal expenses.
    struct AddExpenseSheetView: View {
        
        // Allows dismissing the sheet programmatically
        @Environment(\.dismiss) private var dismiss
        
        // Actions invoked when an option is selected
        let onGroupExpense: () -> Void
        let onPersonalExpense: () -> Void
        
        var body: some View {
            ZStack {
                // Sheet background gradient
                LinearGradient(
                    colors: [Color(hex: "#1A1A1A"), Color(hex: "#0A0A0A")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Bubble container content
                VStack(spacing: 14) {
                    
                    // Drag handle for visual affordance
                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 52, height: 5)
                        .padding(.top, 10)
                        .padding(.bottom, 12)
                    
                    // Title and close button
                    HStack {
                        Text("Add Expense")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.9))
                                .frame(width: 34, height: 34)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }
                    }
                    
                    // Thin divider between header and content
                    Divider()
                        .overlay(Color.white.opacity(0.15))
                    
                    // Section header
                    Text("Choose expense type")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white.opacity(0.65))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Expense type options
                    VStack(spacing: 14) {
                        
                        // Add Group Expense option
                        AddExpenseOptionRow(
                            title: "Group Expense",
                            subtitle: "Split with your group members",
                            icon: "person.2.fill",
                            iconGradient: [
                                Color(hex: "#FD29A9"),
                                Color(hex: "#44C099")
                            ]
                        ) {
                            dismiss()
                            onGroupExpense()
                            
                        }
                        
                        // Add Personal Expense option
                        AddExpenseOptionRow(
                            title: "Personal Expense",
                            subtitle: "Track your individual bills",
                            icon: "person.fill",
                            iconGradient: [
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.12)
                            ]
                        ) {
                            dismiss()
                            onPersonalExpense()
                        }
                    }
                    
                    Spacer(minLength: 6)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 18)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity, alignment: .bottom)
                // Bubble card background with gradient fill and thin stroke
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#1A1A1A"), Color(hex: "#0A0A0A")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        // Thin white stroke at low opacity for glass edge
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    }
                )
                // Rounded shape and layered shadows for depth
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .shadow(color: Color.black.opacity(0.45), radius: 24, x: 0, y: 18)
                .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 2)
                .ignoresSafeArea(.container, edges: .bottom)
            }
        }
    }
    
    
    /// A tappable row representing an expense type with icon tile and labels.
    struct AddExpenseOptionRow: View {
        
        // Title text displayed prominently
        let title: String
        // Subtitle text describing the option
        let subtitle: String
        // System icon name shown on tile
        let icon: String
        // Gradient colors used behind icon tile
        let iconGradient: [Color]
        // Action executed on tap
        let action: () -> Void
        
        // Press state for tap animation
        @GestureState private var isPressed = false
        
        var body: some View {
            // Whole row is a button triggering the provided action
            Button(action: action) {
                HStack(spacing: 14) {
                    
                    // Icon tile with gradient glass and inner highlight
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#44C099").opacity(0.55), Color(hex: "#FD29A9").opacity(0.55)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.28), Color.white.opacity(0.06)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            )
                            .shadow(color: Color(hex: "#FD29A9").opacity(0.18), radius: 10, x: 0, y: 6)
                            .shadow(color: Color(hex: "#44C099").opacity(0.14), radius: 8, x: 0, y: 3)
                            .frame(width: 56, height: 56)
                        
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 1)
                    }
                    
                    // Title and subtitle
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(subtitle)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    
                    Spacer()
                }
                .padding(14)
                
                // Glass card background with fill and stroke
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    }
                )
                // Press interaction feedback
                .shadow(color: Color.black.opacity(isPressed ? 0.25 : 0.35), radius: isPressed ? 6 : 12, x: 0, y: isPressed ? 2 : 8)
                .scaleEffect(isPressed ? 0.98 : 1.0)
                .animation(.spring(response: 0.28, dampingFraction: 0.85), value: isPressed)
            }
            .buttonStyle(.plain)
            // Gesture to set isPressed during touch-down
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in state = true }
            )
        }
    }
    
    
    /// Simple placeholder used for non-implemented tabs.
    struct PlaceholderView: View {
        let title: String
        var body: some View {
            ZStack {
                // Black background filling entire safe area
                Color.black.ignoresSafeArea()
                // Centered title text in white
                Text(title).foregroundStyle(.white)
            }
        }
    }
    
    // MARK: - Home Screen
    
    /// The Home tab showing welcome header and getting-started cards.
    struct HomeView: View {
        
        // Controls presentation of the notifications sheet
        @State private var showNotifications = false
        // Access to authenticated user's info (e.g., first name)
        @EnvironmentObject private var auth: AuthStore
        
        let onCreateGroupTap: () -> Void
        let onAddFirstExpenseTap: () -> Void
        
        
        var body: some View {
            ZStack {
                // Full-screen dark gradient background
                LinearGradient(
                    colors: [Color.black, Color.black.opacity(0.90), Color.black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Scrollable content section
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        
                        // Top header with title and profile/notifications
                        header
                        
                        // Getting started card
                        FrostCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Let’s get started!")
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.white)
                                
                                Text("To kick things off, create your first group and expenses.")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.70))
                                
                                GlassCTAButton(title: "Create your first group", systemImage: "arrow.right", color: Color(hex: "#FD29A9")) {
                                    
                                    
                                    // TODO: navigate to SelectGroupView
                                    onCreateGroupTap()
                                    
                                }
                                .padding(.top, 6)
                            }
                        }
                        
                        // Section label
                        Text("Today’s Priority")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.top, 6)
                        
                        // Empty state for Today's Priority
                        FrostCard {
                            VStack(alignment: .center, spacing: 10) {
                                Text("No Current priority items yet.")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.white)
                                
                                Text("Start by creating a new group or\nadding an expense.")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white.opacity(0.70))
                                
                                GlassCTAButton(title: "Add your first expense", systemImage: "arrow.right", color: Color(hex: "#FD29A9")) {
                                    
                                    // TODO: navigate to showAddExpenseSheet
                                    onAddFirstExpenseTap()
                                }
                                .padding(.top, 6)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.top, 1)
                        
                        // Section label
                        Text("Last Group Expense Visited")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.top, 6)
                        
                        // Last visited group expense placeholder
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
                        .padding(.top, 1)
                        
                        // Extra space to make room for floating CTA
                        Spacer().frame(height: 170)
                        
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 14)
                    .padding(.bottom, 200)
                }
            }
            
            // Present notifications as a sheet
            .sheet(isPresented: $showNotifications) {
                NotificationsView()
            }
            
        }
        
        /// Header with "Home" title, welcome message, profile photo, and notifications button.
        private var header: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Home")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Welcome to CleerSplit, \(auth.firstName)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.65))
                }
                
                Spacer()
                
                // Profile photo with notification icon attached (tap → notifications)
                ZStack(alignment: .bottomTrailing) {
                    
                    // Profile photo circle with subtle stroke
                    Image("profile_photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    
                    // Notification bell button attached to profile photo
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
                    .offset(x: -2, y: 2) // tiny nudge for alignment
                }
                
            }
            .padding(.bottom, 6)
            .padding(.trailing, 6)
            
            
        }
    }
}


/// Reusable frosted card container with rounded corners and subtle border.
struct FrostCard<Content: View>: View {
    // Content to display inside the frosted card
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


/// Primary button styled as a pill with gradient background and icon.
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


/// Simple notifications screen placeholder.
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


/// Convenience initializer for Color from a hex string.
///
/// Supports 3, 6, or 8 character hex values with optional alpha.
extension Color {
    init(hex: String) {
        // Remove any non-alphanumeric characters (like '#')
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        // Parse the hex string into an integer
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit), e.g. "F0A"
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit), e.g. "FF00AA"
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit), e.g. "FF112233"
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            // Default to opaque black if format is unknown
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

// MARK: - GlassCTAButton

/// Glassy call-to-action button with blur, highlights, and press animation.
struct GlassCTAButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @GestureState private var isPressed = false

    var body: some View {
        // Outer spring animation for press/release
        let pressGesture = DragGesture(minimumDistance: 0)
            .updating($isPressed) { _, state, _ in state = true }
            .onEnded { _ in action() }
        
        ZStack {
            // 1. Glassy blurred background
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.94)

            // 2. Top highlight gradient for curvature
            Capsule(style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.white.opacity(colorScheme == .dark ? 0.27 : 0.22), .clear],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .blur(radius: 0.5)

            // 3. Specular "glass" edge stroke, stronger at top-left
            Capsule(style: .continuous)
                .strokeBorder(
                    AngularGradient(gradient:
                        Gradient(stops: [
                            .init(color: Color.white.opacity(0.45), location: 0.00), // top-left
                            .init(color: Color.white.opacity(0.16), location: 0.30),
                            .init(color: Color.white.opacity(0.08), location: 0.55),
                            .init(color: color.opacity(0.20), location: 0.75), // bottom-right accent
                            .init(color: Color.white.opacity(0.45), location: 1.00)
                        ]), center: .center), lineWidth: 1.5
                )
                .blendMode(.plusLighter)

            // Button content: icon and title horizontally arranged
            HStack(spacing: 11) {
                Image(systemName: systemImage)
                    .font(.headline.weight(.semibold))
                Text(title)
                    .font(.headline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .shadow(color: Color.black.opacity(0.12), radius: 0.5, x: 0, y: 1)
            .padding(.vertical, 15)
            .padding(.horizontal, 32)
        }
        .frame(minHeight: 52)
        // Scale down slightly when pressed
        .scaleEffect(isPressed ? 0.965 : 1.0)
        // Shadow intensifies on press for feedback
        .shadow(
            color: color.opacity(isPressed ? 0.21 : 0.15),
            radius: isPressed ? 18 : 10,
            x: 0, y: isPressed ? 4 : 2
        )
        .animation(.spring(response: 0.32, dampingFraction: 0.78, blendDuration: 0.22), value: isPressed)
        .gesture(pressGesture)
        .padding(.horizontal, 16)
        .contentShape(Capsule())
        .accessibilityLabel(Text(title))
    }
}

// MARK: - AddExpenseCTA (Gradient Border, Glow, Breathing)

/// Floating call-to-action button with gradient border and breathing glow animation.
struct AddExpenseCTA: View {
    // Button title to display
    let title: String
    // Action triggered on tap
    let action: () -> Void

    // Gesture state tracking press status for interactive animation
    @GestureState private var isPressed = false
    // Controls breathing animation state
    @State private var breathe = false

    // Gradient used for the border stroke
    private let borderGradient = LinearGradient(
        colors: [Color(hex: "#44C099"), Color(hex: "#FD29A9")],
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        // Gesture for press down and release to trigger action
        let pressGesture = DragGesture(minimumDistance: 0)
            .updating($isPressed) { _, state, _ in state = true }
            .onEnded { _ in action() }

        ZStack {
            // Background capsule with semi-transparent black fill
            Capsule(style: .continuous)
                .fill(Color.black.opacity(0.75))
                // Gradient border stroke around capsule
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(borderGradient, lineWidth: 2)
                )
                // Shadow glow that softly pulses (breathes)
                .shadow(color: Color(hex: "#FD29A9").opacity(breathe ? 0.38 : 0.16), radius: breathe ? 28 : 14, x: 0, y: 8)
                .shadow(color: Color(hex: "#44C099").opacity(breathe ? 0.28 : 0.12), radius: breathe ? 22 : 10, x: 0, y: 4)
                // Slight blur during breathing animation for softness
                .blur(radius: breathe ? 0.2 : 0)

            // Button content: plus icon and title text
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 17, weight: .bold))
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 44)
        .padding(.horizontal, 16)

        .gesture(pressGesture)
        .accessibilityLabel(Text(title))
        .contentShape(Capsule())
     
  }
     
}

// Preview RootTabView with AuthStore environment object injected
#Preview {
    RootTabView()
        .environmentObject(AuthStore())
}

