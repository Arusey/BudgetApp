//
//  RatingSheet.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct RatingSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var rating = 0

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Rate your Experience")
                    .font(AppFont.bold(20, relativeTo: .title3))
                Text("How was adding your budget item?")
                    .font(AppFont.regular(14, relativeTo: .subheadline))
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        rating = star
                    } label: {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 32))
                            .foregroundStyle(star <= rating ? AppColor.primary : Color.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(star) of 5 stars")
                    .accessibilityAddTraits(star == rating ? .isSelected : [])
                }
            }
            PrimaryButton(title: "Submit") {
                dismiss()
            }
            .disabled(rating == 0)
            .opacity(rating == 0 ? 0.5 : 1)
            .accessibilityIdentifier("submitRatingButton")
        }
        .padding(24)
        .presentationDetents([.height(300)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            RatingSheet()
        }
}
