//
//  PrimaryButton.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var color = AppColor.primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.bold(16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(color, in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Create New Budget Item", action: {})
        PrimaryButton(title: "Go back to Home", color: AppColor.secondary, action: {})
    }
    .padding()
}
