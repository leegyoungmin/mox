import SwiftUI

/// Liquid Glass 헬퍼. macOS 26+에서는 실제 `glassEffect`를 쓰고,
/// 그 이하에서는 `ultraThinMaterial`로 자연스럽게 폴백한다.
/// 글래스는 "콘텐츠 위에 떠 있는 컨트롤 레이어"에만 사용한다.
extension View {
    /// 떠 있는 패널/바에 쓰는 기본 글래스.
    @ViewBuilder
    func softGlass<S: Shape>(in shape: S) -> some View {
        if #available(macOS 26.0, *) {
            glassEffect(.regular, in: shape)
        } else {
            background(.ultraThinMaterial, in: shape)
        }
    }

    /// 탭 가능한 알약형 칩에 쓰는 인터랙티브 글래스. 활성 시 틴트.
    @ViewBuilder
    func chipGlass(active: Bool) -> some View {
        if #available(macOS 26.0, *) {
            glassEffect(
                active
                    ? .regular.tint(.accentColor.opacity(0.55)).interactive()
                    : .regular.interactive(),
                in: Capsule()
            )
        } else {
            background(
                active ? AnyShapeStyle(Color.accentColor.opacity(0.18))
                       : AnyShapeStyle(.ultraThinMaterial),
                in: Capsule()
            )
        }
    }

    /// 글래스 버튼 스타일. 폴백은 bordered(Prominent).
    @ViewBuilder
    func glassAction(prominent: Bool = false) -> some View {
        if #available(macOS 26.0, *) {
            if prominent { buttonStyle(.glassProminent) } else { buttonStyle(.glass) }
        } else {
            if prominent { buttonStyle(.borderedProminent) } else { buttonStyle(.bordered) }
        }
    }
}

/// 여러 글래스 요소를 한 컨테이너로 묶어 서로 블렌딩/모핑되게 한다(macOS 26+).
struct GlassGroup<Content: View>: View {
    var spacing: CGFloat = 8
    @ViewBuilder var content: Content

    var body: some View {
        if #available(macOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) { content }
        } else {
            content
        }
    }
}
