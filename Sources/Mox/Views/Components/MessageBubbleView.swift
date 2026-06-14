import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .top) {
            if message.role == .user {
                Spacer(minLength: 60)
                userBubble
            } else {
                assistantBlock
                Spacer(minLength: 50)
            }
        }
    }

    private var userBubble: some View {
        Text(message.text)
            .font(.system(size: 14))
            .textSelection(.enabled)
            .padding(.vertical, 9)
            .padding(.horizontal, 13)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
    }

    private var assistantBlock: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 7) {
                Text("M")
                    .font(.system(size: 10, weight: .medium))
                    .frame(width: 18, height: 18)
                    .background(Color.accentColor.opacity(0.18), in: Circle())
                Text("Mox").font(.system(size: 12)).foregroundStyle(.secondary)
            }

            Text(message.text + (message.isStreaming ? "▍" : ""))
                .font(.system(size: 14))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 10)
                .padding(.horizontal, 13)
                .background(.background, in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(.quaternary, lineWidth: 0.5))

            footer
        }
    }

    @ViewBuilder
    private var footer: some View {
        if let tps = message.tokensPerSecond, let count = message.tokenCount {
            Label(String(format: "%.1f tok/s · %d tokens", tps, count), systemImage: "bolt")
                .font(.system(size: 12)).foregroundStyle(.tertiary)
        } else if message.isStreaming {
            Label("생성 중…", systemImage: "bolt")
                .font(.system(size: 12)).foregroundStyle(.tertiary)
        }
    }
}
