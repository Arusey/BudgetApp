//
//  OutlinedField.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct OutlinedField<Content: View>: View {
    private let title: String
    private let isFocused: Bool
    private let error: String?
    private let content: Content

    init(_ title: String, isFocused: Bool = false, error: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isFocused = isFocused
        self.error = error
        self.content = content()
    }

    private var borderColor: Color {
        if error != nil { return AppColor.expense }
        return isFocused ? AppColor.primary : AppColor.border
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppFont.regular(14, relativeTo: .subheadline))
                .foregroundStyle(.secondary)
            content
                .font(AppFont.regular(16))
                .padding(.horizontal, 14)
                .frame(minHeight: 52)
                .background(AppColor.surface, in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(borderColor, lineWidth: isFocused ? 1.5 : 1))
            if let error {
                Text(error)
                    .font(AppFont.regular(12, relativeTo: .caption))
                    .foregroundStyle(AppColor.expense)
            }
        }
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }
}

#Preview {
    VStack(spacing: 20) {
        OutlinedField("Item Name") {
            TextField("e.g. Lunch at KFC", text: .constant(""))
        }
        OutlinedField("Allocation", isFocused: true) {
            TextField("0", text: .constant("2000"))
        }
        OutlinedField("Item Name", error: "Enter an item name") {
            TextField("e.g. Lunch at KFC", text: .constant(""))
        }
    }
    .padding()
    .background(AppColor.background)
}
