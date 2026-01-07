//
//  ProfileStore.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2026-01-06.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI
import Combine

@MainActor
final class ProfileStore: ObservableObject {

    // MARK: - Public UI state
    @Published var firstName: String = "Alex"
    @Published var email: String = ""
    @Published var avatarImage: UIImage? = nil

    /// Bind this to PhotosPicker(selection:)
    @Published var selectedPhotoItem: PhotosPickerItem? = nil {
        didSet { Task { await loadAvatarFromPicker() } }
    }

    // MARK: - Auth -> Profile (call this after sign-in)
    /// Call this right after login (Email / Google / Apple).
    /// Pass the displayName you get from the provider (e.g. "Ruth Okolo").
    func applyAuthenticatedUser(displayName: String?, email: String?) {
        self.email = email ?? ""

        // Take only the first name for: "Welcome to CleerSplit, <firstName>"
        let extracted = Self.extractFirstName(from: displayName)
        if let extracted, !extracted.isEmpty {
            self.firstName = extracted
        } else if let email, let fallback = Self.extractFirstNameFromEmail(email) {
            self.firstName = fallback
        } else {
            self.firstName = "Friend"
        }
    }

    // MARK: - Profile photo (user changes from Profile screen later)
    func setAvatar(_ image: UIImage?) {
        self.avatarImage = image
    }

    // MARK: - Private
    private func loadAvatarFromPicker() async {
        guard let item = selectedPhotoItem else { return }

        do {
            // iOS 16+: PhotosPickerItem -> Data
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                self.avatarImage = uiImage
            }
        } catch {
            // You can log this later if needed
        }
    }

    private static func extractFirstName(from displayName: String?) -> String? {
        guard let displayName, !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        // Split by whitespace and take first token
        let parts = displayName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(whereSeparator: { $0.isWhitespace })
        return parts.first.map(String.init)
    }

    private static func extractFirstNameFromEmail(_ email: String) -> String? {
        // "ruthokolo@example.com" -> "Ruth"
        let prefix = email.split(separator: "@").first.map(String.init) ?? ""
        guard !prefix.isEmpty else { return nil }

        // Split by common separators and take first
        let parts = prefix.split(whereSeparator: { $0 == "." || $0 == "_" || $0 == "-" })
        guard let first = parts.first, !first.isEmpty else { return nil }

        return first.prefix(1).uppercased() + first.dropFirst().lowercased()
    }
}
