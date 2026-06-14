//
//  Glass.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func softGlass<S: Shape>(in shape: S) -> some View {
        if #available(macOS 26.0, *) {
            glassEffect(.regular, in: shape)
        } else {
            background(.ultraThinMaterial, in: shape)
        }
    }
    
    @ViewBuilder
    func chipGlass(active: Bool) -> some View {
        if #available(macOS 26.0, *) {
            glassEffect(
                active ? .regular.tint(.accentColor.opacity(0.55)).interactive() : .regular.interactive(),
                in: Capsule()
            )
        } else {
            background(
                active ? AnyShapeStyle(Color.accentColor.opacity(0.18)) : AnyShapeStyle(.ultraThinMaterial),
                in: Capsule()
            )
        }
    }
    
    @ViewBuilder
    func glassAction(prominent: Bool = false) -> some View {
        if #available(macOS 26.0, *) {
            if prominent {
                buttonStyle(.glassProminent)
            } else {
                buttonStyle(.glass)
            }
        } else {
            if prominent {
                buttonStyle(.borderedProminent)
            } else {
                buttonStyle(.bordered)
            }
        }
    }
}

struct GlassGroup<Content: View>: View {
    var spacing: CGFloat = 8
    @ViewBuilder var content: Content
    
    var body: some View {
        if #available(macOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) {
                content
            }
        } else {
            content
        }
    }
}
