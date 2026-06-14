import Foundation

enum ChatRole: String, Codable, Sendable {
    case system, user, assistant
}

/// 한 번의 발화. 스트리밍 중에는 `isStreaming == true`이고 `text`가 점점 길어진다.
struct ChatMessage: Identifiable, Sendable {
    let id = UUID()
    var role: ChatRole
    var text: String
    var isStreaming: Bool = false
    var tokensPerSecond: Double? = nil
    var tokenCount: Int? = nil
}
