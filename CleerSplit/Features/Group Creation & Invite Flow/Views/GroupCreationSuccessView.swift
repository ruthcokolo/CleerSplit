//
//  GroupCreationSuccessView.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2026-01-16.
//

import SwiftUI

/// A glassmorphic success prompt shown after creating a group.
/// Displays a title, description, and primary/secondary actions
/// with Apple-inspired glass/blur, vibrant gradient, and accessibility.
struct GroupCreationSuccessView: View {
    
    let inviteURL = URL(string: "https://cleersplit.app/invite/ABC123")! // replace later

    
    // Name of the group to display in the headline (e.g., "Girl’s night")
    var groupName: String
    
    // Callback invoked when the primary CTA (Invite Members) is tapped
    var onInviteMembers: () -> Void
    
    // Used to adapt strokes, shadows, and opacity for light/dark mode
    @Environment(\.colorScheme) private var colorScheme
    
    // Used to respect Dynamic Type sizing for accessibility
    @Environment(\.dynamicTypeSize) private var dynamicType
    
    // Controls navigation to Home View
    @State private var navigateToHome: Bool = false
    
    
    

    var body: some View {
       // NavigationStack {
            ZStack {
                // Ambient background with brand accent blobs and radial falloff
                backgroundGradient
                    .ignoresSafeArea()
                
                // Centered glass card with icon, title, description, and actions
                VStack(spacing: 20) {
                    headerIcon
                    
                    VStack(spacing: 8) {
                        Text("\(groupName) is Ready!")
                            .font(.system(.title2, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)
                            .accessibilityAddTraits(.isHeader)
                        
                        Text("Your group is ready, but you need members to start splitting expenses")
                            .font(.system(.callout, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 6)
                    
                    VStack(spacing: 12) {
                        inviteButton
                        skipButton
                    }
                }
                // Glassmorphism: frosted material with rounded shape
                .padding(22)
                .frame(maxWidth: 360)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                // Frosted edge highlight to define card boundaries
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(glassStroke, lineWidth: 1)
                        .blendMode(.overlay)
                        .opacity(colorScheme == .dark ? 0.8 : 0.6)
                )
                // Soft drop shadow for depth and separation from background
                .shadow(color: shadowColor.opacity(colorScheme == .dark ? 0.45 : 0.25), radius: 24, x: 0, y: 16)
                .padding(.horizontal, 24)
                // Treat card contents as a grouped accessibility element
                .accessibilityElement(children: .contain)
            }
            // Subtle transition when switching appearance (e.g., dark/light)
            .animation(.smooth(duration: 0.3), value: colorScheme)
            .animation(.easeInOut(duration: 0.25), value: navigateToHome)
            .fullScreenCover(isPresented: $navigateToHome) {
                RootTabView()
                    .transition(.opacity)
            }
            
        }
    }
//}

// MARK: - Subviews
private extension GroupCreationSuccessView {
    /// Full-screen decorative background with subtle brand blobs.
    var backgroundGradient: some View {
        ZStack {
            // Base radial gradient for gentle vignette
            RadialGradient(colors: [baseBG.opacity(0.85), baseBG.opacity(0.95)], center: .center, startRadius: 2, endRadius: 800)
            // Brand-colored blurred blob to add depth and vibrancy
            Circle()
                .fill(LinearGradient(colors: [brandPink.opacity(0.35), brandTeal.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: -140, y: -260)
                .accessibilityHidden(true)
            // Brand-colored blurred blob to add depth and vibrancy
            Circle()
                .fill(LinearGradient(colors: [brandTeal.opacity(0.35), brandPink.opacity(0.15)], startPoint: .bottomTrailing, endPoint: .topLeading))
                .frame(width: 280, height: 280)
                .blur(radius: 70)
                .offset(x: 160, y: 260)
                .accessibilityHidden(true)
        }
    }

    /// Leading icon tile with frosted backdrop and symbolic glyph.
    var headerIcon: some View {
        ZStack {
            // Frosted tile background behind the symbol
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(glassStroke.opacity(0.9), lineWidth: 1)
                )
                .shadow(color: shadowColor.opacity(0.18), radius: 12, x: 0, y: 8)

            // Symbol icon with palette styling and glow
            Image(systemName: "sparkle")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .mint)
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .shadow(color: brandPink.opacity(0.35), radius: 12, x: 0, y: 8)
        }
        .frame(width: 64, height: 64)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(LinearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .blendMode(.overlay)
        )
        .accessibilityHidden(true)
    }

    /// Primary CTA: Invite Members with vibrant brand gradient and haptics.
    var inviteButton: some View {
        ShareLink(
            item: inviteURL,
            subject: Text("Join my CleerSplit group"),
            message: Text("Join “\(groupName)” on CleerSplit: \(inviteURL.absoluteString)")
        ) {
            HStack(spacing: 10) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text("Invite Members")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(inviteGradient)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(.white.opacity(0.15), lineWidth: 1)
                    .blendMode(.overlay)
            )
            .shadow(color: brandTeal.opacity(0.35), radius: 18, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }


    /// Secondary action: Skip for now with thin material and frosted stroke.
    var skipButton: some View {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation(.easeInOut(duration: 0.25)) {
                    navigateToHome = true
                }
            } label: {
                Text("Skip for now")
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(glassStroke.opacity(0.7), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Skip for now")
    }
}

// MARK: - Styling helpers
private extension GroupCreationSuccessView {
    // Brand colors
    var brandPink: Color { Color(red: 253/255, green: 41/255, blue: 169/255) } // #FD29A9
    var brandTeal: Color { Color(red: 68/255, green: 192/255, blue: 153/255) }  // #44C099

    // Brand gradient used for the primary CTA
    var inviteGradient: LinearGradient {
        LinearGradient(colors: [brandPink, brandTeal], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    // Frosted stroke used on card and controls
    var glassStroke: LinearGradient {
        LinearGradient(colors: [Color.white.opacity(0.7), Color.white.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    // Semantic base background color
    var baseBG: Color { Color(.systemBackground) }

    // Base shadow color (tuned per color scheme)
    var shadowColor: Color { Color.black }
}

// MARK: - Preview for design iteration and dark mode
#Preview("GroupReady_InviteMembersPrompt") {
    GroupCreationSuccessView(
        groupName: "Girl’s night",
        onInviteMembers: {}
    )
    .preferredColorScheme(.dark) // Preview in dark mode
}

