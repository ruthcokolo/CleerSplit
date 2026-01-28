//
//  GroupTypeSelectionView.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2026-01-16.
//

import SwiftUI

struct GroupTypeSelectionView: View {
    // Environment-provided dismiss action to close this view (e.g., pop or dismiss sheet)
    @Environment(\.dismiss) private var dismiss
    
    // Currently selected group type from the grid; nil until user selects
    @State private var selectedType: GroupType? = nil
    
    // Controls presentation of the centered custom name popup
    @State private var showingCustomType = false
    
    // Holds the custom group name input when the user chooses Custom
    @State private var customGroupName: String = ""
    
    // Controls navigation to Group Details Setup View
    @State private var navigateToGroupDetailsSetup: Bool = false
    
    // Controls navigation to Group Creation Success View
    @State  private var navigatetoGroupCreationSuccess: Bool = false

    // Brand colors used for CTAs and accents (pink and teal) and their gradient
    private var brandPink: Color { Color(red: 253/255, green: 41/255, blue: 169/255) } // #FD29A9
    private var brandTeal: Color { Color(red: 68/255, green: 192/255, blue: 153/255) }  // #44C099
    private var brandGradient: LinearGradient {
        LinearGradient(colors: [brandPink, brandTeal], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var body: some View {
        
        NavigationStack {
            ZStack {
                // App background gradient (dark) spanning full screen
                LinearGradient(
                    colors: [Color(hex: "#1A1A1A"), Color(hex: "#0A0A0A")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main content: header, titles, grid, and continue button
                content
                
                // Centered popup overlay for entering a custom group name
                if showingCustomType {
                    // Dimmed, blurred backdrop to focus attention on the popup
                    Rectangle()
                        .fill(Color.black.opacity(0.35))
                        .ignoresSafeArea()
                        .background(.ultraThinMaterial)
                        .blur(radius: 4)
                        .transition(.opacity)
                        .onTapGesture { /* tap outside does not dismiss to avoid accidental closes */ }
                    
                    // The popup card itself (title, text field, and Continue button)
                    CustomGroupNamePopup(
                        name: $customGroupName,
                        onCancel: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showingCustomType = false
                                if selectedType == .custom { selectedType = nil }
                            }
                        },
                        onSave: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showingCustomType = false
                            }
                        }
                    )
                    .frame(maxWidth: 340)
                    .transition(.scale.combined(with: .opacity))
                }
                
            }
            
            .navigationDestination(isPresented: $navigateToGroupDetailsSetup) {
                GroupDetailsSetupView()
                    // Hide SwiftUI's back icon
                    .navigationBarBackButtonHidden(true)
            }
            
            
        }
    }

    private var content: some View {
        // Vertical stack composing the screen's sections
        VStack(spacing: 24) {
            header
            titles
            grid
            Spacer(minLength: 0)
            continueButton
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var header: some View {
        // Navigation header with Back button and step indicator
        HStack {
            // Back button to dismiss this view
            Button(action: { dismiss() }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundStyle(Color.white.opacity(0.9))
            }
            Spacer()
            // Progress indicator for the flow
            Text("Step 1 of 2")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.6))
        }
    }

    private var titles: some View {
        // Screen title and supportive subtitle
        VStack(alignment: .leading, spacing: 8) {
            Text("What kind of group\nare you setting up?")
                .font(.system(size: 32, weight: .heavy))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
            Text("Choose one to personalize your\nCleerSplit experience")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.white.opacity(0.7))
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var grid: some View {
        // Two-column grid of selectable group type cards
        let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
        return LazyVGrid(columns: columns, spacing: 16) {
            card(.friends, title: "Friends", icon: "person.2.fill", accent: Color.pink) // Friends card
            card(.family, title: "Family", icon: "figure.2.and.child.holdinghands", accent: Color.green) // Family card
            card(.roommates, title: "Roommates", icon: "key.fill", accent: Color.cyan) // Roommates card
            card(.students, title: "Students", icon: "graduationcap.fill", accent: Color.orange) // Students card
            card(.coworkers, title: "Coworkers", icon: "person.3.fill", accent: Color.purple) // Coworkers card
            card(.custom, title: "Custom", icon: "plus", accent: Color.gray) // Custom card
        }
    }

    /// Builds a selectable card for a group type with icon, title, and selection styling.
    private func card(_ type: GroupType, title: String, icon: String, accent: Color) -> some View {
        let isSelected = selectedType == type
        return Button(action: {
            // Update the selection to the tapped type
            selectedType = type
            if type == .custom {
                // Show the custom name popup when Custom is chosen
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    showingCustomType = true
                }
            }
        }) {
            // Card content: circular icon and title centered
            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.18))
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(accent)
                }
                .frame(height: 56)

                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 116, alignment: .center)
            // Card background (translucent dark) with rounded corners
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.black.opacity(0.35))
            )
            // Selection ring: accent color when selected, subtle stroke otherwise
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? accent.opacity(0.9) : Color.white.opacity(0.12), lineWidth: isSelected ? 2 : 1)
            )
            // Elevation shadow for depth
            .shadow(color: Color.black.opacity(0.6), radius: 12, x: 0, y: 8)
            // Gentle top highlight for glassy feel
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(
                        LinearGradient(colors: [Color.white.opacity(isSelected ? 0.08 : 0.04), Color.clear], startPoint: .top, endPoint: .bottom)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    /// Primary action to proceed after selecting a type; disabled until a selection is made.
    private var continueButton: some View {
        Button(action: {
            /* handle continue */
            navigateToGroupDetailsSetup = true
        }) {
            Text("Continue")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                // Uses brand gradient when enabled; dimmed gradient when disabled
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(selectedType == nil ? LinearGradient(colors: [brandPink.opacity(0.35), brandTeal.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing) : brandGradient)
                )
                .foregroundStyle(.white)
        }
        // Disable until a type is selected
        .disabled(selectedType == nil)
    }

    /// Supported group categories for this flow.
    private enum GroupType: Equatable {
        case friends, family, roommates, students, coworkers, custom
    }
}

/// Centered modal popup to capture a custom group name with a headline and Continue CTA.
private struct CustomGroupNamePopup: View {
    // Two-way binding for the custom group name text field
    @Binding var name: String
    // Callback when the user cancels/closes the popup
    var onCancel: () -> Void
    // Callback when the user taps Continue to confirm the name
    var onSave: () -> Void

    // Focus state to auto-focus the text field on appear
    @FocusState private var focused: Bool

    private var brandPink: Color { Color(red: 253/255, green: 41/255, blue: 169/255) } // #FD29A9
    private var brandTeal: Color { Color(red: 68/255, green: 192/255, blue: 153/255) }  // #44C099

    var body: some View {
        VStack(spacing: 16) {
            // Close (X) button aligned to the top-right
            HStack {
                Spacer()
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.12)))
                }
                .accessibilityLabel("Close")
            }

            // Popup title label
            Text("CUSTOM")
                .font(.system(size: 22, weight: .heavy))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 10) {
                // Single-line input with an underline style
                TextField("Enter group type (e.g., Trip, Project)", text: $name)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(false)
                    .focused($focused)
                    .padding(.vertical, 12)
                    .foregroundStyle(.white)
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.7))
                            .frame(height: 1)
                            .padding(.top, 36)
                            .alignmentGuide(.bottom) { d in d[.bottom] }
                        , alignment: .bottom
                    )
            }

            // Confirm action; enabled only when input is non-empty
            Button(action: onSave) {
                Text("Continue")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? LinearGradient(colors: [brandPink.opacity(0.35), brandTeal.opacity(0.35)], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [brandPink, brandTeal], startPoint: .topLeading, endPoint: .bottomTrailing))
                    )
                    .foregroundStyle(.white)
            }
            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

        }
        .padding(16)
        // Popup background with requested gradient (#1A1A1A → #0A0A0A)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#1A1A1A"), Color(hex: "#0A0A0A")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        // Subtle frosted border to match glass aesthetic
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        // Drop shadow to lift the card from the background
        .shadow(color: .black.opacity(0.5), radius: 24, x: 0, y: 12)
        // Delay focus slightly so the keyboard presents smoothly
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { focused = true } }
    }
}

#Preview {
    GroupTypeSelectionView()
}

