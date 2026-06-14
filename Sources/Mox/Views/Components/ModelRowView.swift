import SwiftUI

struct ModelRowView: View {
    let model: ModelInfo
    let onDownload: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "shippingbox")
                    .font(.system(size: 17))
                    .foregroundStyle(.secondary)
                    .frame(width: 34, height: 34)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 3) {
                    Text(model.displayName)
                        .font(.system(size: 14, weight: .medium))
                    HStack(spacing: 8) {
                        Text(model.author)
                        Text("·")
                        Text(String(format: "%.1f GB", model.sizeGB))
                        Badge(model.parameters)
                        Badge(model.quantization)
                        if !model.fitsInMemory {
                            Badge("RAM 부족 가능", tint: .orange)
                        }
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                }

                Spacer()
                actionView
            }

            if case let .downloading(progress, downloaded, speed) = model.state {
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: progress)
                    Text(String(format: "%.1f / %.1f GB · %.0f MB/s · 이어받기 지원",
                                downloaded, model.sizeGB, speed))
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.quaternary, lineWidth: 0.5))
    }

    @ViewBuilder
    private var actionView: some View {
        switch model.state {
        case .available:
            Button(action: onDownload) {
                Label("받기", systemImage: "arrow.down.circle")
            }
            .glassAction()
        case .downloading:
            Button(action: {}) {
                Image(systemName: "pause.fill")
            }
            .glassAction()
        case .installed:
            HStack(spacing: 10) {
                Label("설치됨", systemImage: "checkmark.circle.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(.green)
                Button(role: .destructive, action: onDelete) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

private struct Badge: View {
    let text: String
    var tint: Color? = nil

    init(_ text: String, tint: Color? = nil) {
        self.text = text
        self.tint = tint
    }

    var body: some View {
        Text(text)
            .font(.system(size: 11))
            .padding(.vertical, 1)
            .padding(.horizontal, 7)
            .foregroundStyle(tint ?? .secondary)
            .background((tint ?? .gray).opacity(0.15), in: Capsule())
    }
}
