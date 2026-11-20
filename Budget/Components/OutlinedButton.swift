//
//  OutlinedButton.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct OutlinedButton: View {
    let title: String
    var color = AppColor.secondary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.bold(16))
                .foregroundStyle(color)
                .frame(maxWidth: .infinity, minHeight: 54)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(color, lineWidth: 1.5))
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OutlinedButton(title: "Rate your Experience", action: {})
        .padding()
}
