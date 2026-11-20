//
//  CustomTabBar.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selection: AppTab
    let onAdd: () -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            tabButton(.home)
            tabButton(.budgets)
            addButton
            tabButton(.reports)
            tabButton(.account)
        }
        .padding(.top, 10)
        .padding(.horizontal, 8)
        .background {
            AppColor.surface
                .shadow(color: .black.opacity(0.08), radius: 8, y: -2)
                .ignoresSafeArea(edges: .bottom)
        }
    }

    private var addButton: some View {
        Button(action: onAdd) {
            Image("add_button")
                .resizable()
                .frame(width: 64, height: 64)
                .shadow(color: AppColor.secondary.opacity(0.3), radius: 6, y: 4)
        }
        .buttonStyle(.plain)
        .offset(y: -18)
        .frame(maxWidth: .infinity)
        .accessibilityLabel("Add new budget item")
        .accessibilityIdentifier("addButton")
    }

    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = selection == tab
        return Button {
            selection = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .symbolVariant(isSelected ? .fill : .none)
                    .font(.system(size: 22))
                Text(tab.title)
                    .font(AppFont.regular(11, relativeTo: .caption2))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? AppColor.primary : Color.secondary)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("tab.\(tab.rawValue)")
    }
}

#Preview {
    @Previewable @State var selection = AppTab.home

    VStack {
        Spacer()
        CustomTabBar(selection: $selection, onAdd: {})
    }
    .background(AppColor.background)
}
