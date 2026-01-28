//
//  GroupDetailsSetupView.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2026-01-16.
//

// View for finalizing group details: name, photo, description, and navigating to success.

import SwiftUI
import PhotosUI
import UIKit
// SwiftUI for views, PhotosUI for photo library picker, UIKit for camera access via UIImagePickerController

// Main screen for Step 2: collect name, optional photo, and description
struct GroupDetailsSetupView: View {
    // Dismiss handler for popping the current view
    @Environment(\.dismiss) private var dismiss

    @State private var groupName: String = ""  // Required name for the group
    @State private var groupDescription: String = ""  // Optional, short blurb shown to members
    private let descriptionLimit = 40  // Character cap for description

    // Photo picking state
    @State private var selectedPhotoItem: PhotosPickerItem?  // Result from Photos picker
    @State private var selectedUIImage: UIImage?  // Chosen image to display
    @State private var showSourceDialog = false  // Controls camera/library dialog
    @State private var showPhotoLibrary = false  // Presents Photos picker
    @State private var showCamera = false  // Presents camera sheet

    // Navigation
    @State private var goToSuccess = false  // Triggers navigation to success view

    var body: some View {
        // Background gradient + content stack
        ZStack {
            LinearGradient(
                colors: [Color(hexString: "#1A1A1A"), Color(hexString: "#0A0A0A")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea() // Extend gradient under safe areas

            VStack(spacing: 16) {
                // Top bar with back and step indicator
                header

                // Scrollable content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        titleSection  // Title + subtitle
                        nameField  // Group name input
                        photoCard  // Photo selector card
                        descriptionField  // Description with counter
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
                    .padding(.bottom, 24)
                }

                continueButton  // Primary CTA
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        // Source chooser for photo
        .confirmationDialog("Choose Photo", isPresented: $showSourceDialog, titleVisibility: .visible) {
            Button("Choose from Photo Library") { showPhotoLibrary = true }
            Button("Take Photo") { showCamera = true }
            Button("Cancel", role: .cancel) {}
        }

        // Present Photos library
        .photosPicker(isPresented: $showPhotoLibrary, selection: $selectedPhotoItem, matching: .images)

        // Load image data from selected photo
        .onChange(of: selectedPhotoItem) { _, newItem in
            guard let newItem else { return } // No selection
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedUIImage = image  // Store for preview
                }
            }
        }

        // Camera capture
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedUIImage)
                .ignoresSafeArea() // Use full screen camera UI
        }

        // Navigate to success on continue
        .navigationDestination(isPresented: $goToSuccess) {
            GroupCreationSuccessView(
                groupName: groupName,
                onInviteMembers: {
                    // Hook up invite flow here
                    // TODO: put your ShareLink screen / invite flow here
                }
            )
            .navigationBarBackButtonHidden(true)  // Prevent back navigation from success
        }
    }

    // MARK: UI Pieces

    private var header: some View {
        HStack {
            // Back button
            Button {
                dismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundStyle(.white.opacity(0.92)) // High-contrast text
                .padding(.vertical, 10)
            }

            Spacer()

            // Progress indicator
            Text("Step 2 of 2")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hexString: "#FD29A9"), Color(hexString: "#44C099")],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Headline
            Text("MAKE IT OFFICIAL!")
                .font(.system(size: 32, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.75)],
                        startPoint: .top, endPoint: .bottom
                    )
                )

            // Subheadline
            Text("Enter your group name")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
        }
    }

    private var nameField: some View {
        // Styled text field container
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )

            TextField("e.g., Weekend Trip, Esther’s Birthday", text: $groupName)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true) // Proper nouns
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .semibold))
                .tint(.white) // Caret color
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
        }
        .frame(height: 60)
    }


    private var photoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select a group photo or icon")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            // Tapping opens source dialog
            Button {
                showSourceDialog = true
            } label: {
                // Card background + content
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )

                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.05))
                                .frame(width: 118, height: 118)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color(hexString: "#FD29A9"), Color(hexString: "#44C099")],
                                                startPoint: .topLeading, endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 2
                                        )
                                )

                            // Show selected photo or camera icon
                            if let img = selectedUIImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 118, height: 118)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color(hexString: "#FD29A9"), Color(hexString: "#44C099")],
                                            startPoint: .topLeading, endPoint: .bottomTrailing
                                        )
                                    )
                            }

                            // pencil badge
                            Circle()
                                .fill(.ultraThinMaterial) // Edit badge
                                .overlay(Circle().stroke(.white.opacity(0.2), lineWidth: 0.5))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "pencil")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 48, y: 36) // Bottom-right corner
                        }

                        // Title + subtitle under avatar
                        VStack(spacing: 6) {
                            Text(selectedUIImage == nil ? "Tap to upload a photo" : "Tap to change photo")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white.opacity(0.95))

                            Text("Camera or Photo Library")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .multilineTextAlignment(.center)

                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 18)
                    .padding(.horizontal, 20)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.55))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(.trailing, 18)
                        .padding(.bottom, 16)
                }
            }
            .buttonStyle(.plain) // Remove default button chrome
            .frame(height: 220)
        }
    }

    private var descriptionField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Group description")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            // Multiline text area with placeholder
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.12), lineWidth: 1)
                    )

                TextEditor(text: $groupDescription)
                    .scrollContentBackground(.hidden) // Match custom background
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(12)
                    .frame(minHeight: 120, maxHeight: 150)
                    .onChange(of: groupDescription) { _, newValue in
                        // Enforce character limit
                        if newValue.count > descriptionLimit {
                            groupDescription = String(newValue.prefix(descriptionLimit))
                        }
                    }

                if groupDescription.isEmpty { // Manual placeholder
                    Text("Enter a brief description of your group (max 40 characters)")
                        .foregroundColor(.white.opacity(0.4))
                        .font(.system(size: 16))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                }
            }

            Text("\(groupDescription.count)/\(descriptionLimit) characters")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .padding(.top, -4)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .allowsTightening(true)
                .minimumScaleFactor(0.75)
                .layoutPriority(1)
                .foregroundColor(.white.opacity(0.5)) // Live character count
        }
    }

    private var continueButton: some View {
        Button {
            goToSuccess = true  // Trigger navigation
        } label: {
            Text("Continue")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color(hexString: "#FD29A9"), Color(hexString: "#44C099")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .opacity(groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1) // Dim when disabled
                )
        }
        .disabled(groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // Disabled until name entered
    }
}

// UIKit wrapper for camera capture
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true  // Allow crop/adjust
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    // Bridge delegate back to SwiftUI
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let edited = info[.editedImage] as? UIImage {
                parent.selectedImage = edited  // Prefer edited image
            } else if let original = info[.originalImage] as? UIImage {
                parent.selectedImage = original
            }
            parent.dismiss()  // Close sheet
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()  // Close sheet
        }
    }
}

// Utility to create Color from hex strings like "#RRGGBB"
private extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {  // Support 3, 6, or 8 hex digits
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// Preview in a NavigationStack, dark mode
#Preview {
    NavigationStack {
        GroupDetailsSetupView()
    }
    .preferredColorScheme(.dark)
}

