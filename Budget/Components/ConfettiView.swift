//
//  ConfettiView.swift
//  Budget
//
//  Created by Kevin Lagat on 20/11/2026.
//

import SwiftUI

struct ConfettiView: View {
    private struct Piece: Identifiable {
        let id: Int
        let x: CGFloat
        let size: CGFloat
        let color: Color
        let rotation: Double
        let delay: Double
        let duration: Double
    }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pieces = ConfettiView.makePieces()
    @State private var isFalling = false

    var body: some View {
        GeometryReader { proxy in
            if !reduceMotion {
                ForEach(pieces) { piece in
                    Rectangle()
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 0.6)
                        .rotationEffect(.degrees(isFalling ? piece.rotation : 0))
                        .position(
                            x: piece.x * proxy.size.width,
                            y: isFalling ? proxy.size.height + 40 : -40)
                        .animation(.easeIn(duration: piece.duration).delay(piece.delay), value: isFalling)
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            isFalling = true
        }
    }

    private static func makePieces() -> [Piece] {
        let colors = [AppColor.primary, AppColor.secondary] + ExpenseCategory.allCases.map(\.color)
        return (0..<70).map { index in
            Piece(
                id: index,
                x: .random(in: 0...1),
                size: .random(in: 8...14),
                color: colors[index % colors.count],
                rotation: .random(in: 360...1080),
                delay: .random(in: 0...0.8),
                duration: .random(in: 1.8...3.2))
        }
    }
}

#Preview {
    ConfettiView()
}
