//
//  SocialButton.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2025-12-29.
//

import SwiftUI

struct SocialButton: View {
    let title: String
    let systemIcon: String?
    let imageName: String?
    let action: () -> Void

    init(title: String, systemIcon: String, action: @escaping () -> Void) {
        self.title = title
        self.systemIcon = systemIcon
        self.imageName = nil
        self.action = action
    }

    init(title: String, imageName: String, action: @escaping () -> Void) {
        self.title = title
        self.systemIcon = nil
        self.imageName = imageName
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let imageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                } else if let systemIcon {
                    Image(systemName: systemIcon)
                        .frame(width: 18, height: 18)
                }

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.95))
            .cornerRadius(14)
        }
    }
}


//#Preview {
    //SocialButton()
//}
