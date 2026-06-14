import Foundation

/// 추론 파라미터. 채팅 툴바의 파라미터 팝오버와 양방향 바인딩된다.
struct GenerationParameters: Sendable, Equatable {
    var temperature: Double = 0.7
    var topP: Double = 0.9
    var maxTokens: Int = 2048
}
