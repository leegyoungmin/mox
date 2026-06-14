import Foundation
import Observation

/// 채팅 화면의 상태. 지금은 mock 토큰 스트림을 흘리지만,
/// `startGeneration`의 루프를 `InferenceEngine.generate(...)`의
/// `AsyncThrowingStream`으로 교체하면 그대로 실모델에 연결된다.
@MainActor
@Observable
final class ChatViewModel {
    var messages: [ChatMessage]
    var input: String = ""
    var params = GenerationParameters()
    var loadedModelName: String = "Llama-3.2-3B-Instruct-4bit"
    var isGenerating: Bool = false

    /// 설치되어 바로 로드 가능한 모델들. 추후 ModelStore의 로컬 목록으로 채운다.
    let availableModels = [
        "Llama-3.2-3B-Instruct-4bit",
        "Qwen2.5-7B-Instruct-4bit",
        "Phi-3.5-mini-instruct-4bit",
    ]

    private var generationTask: Task<Void, Never>?

    init() {
        messages = [
            ChatMessage(
                role: .user,
                text: "Swift에서 actor와 async/await로 토큰 스트리밍을 어떻게 구현해?"
            ),
            ChatMessage(
                role: .assistant,
                text: "엔진을 actor로 만들고 generate가 AsyncThrowingStream을 반환하게 한 뒤, SwiftUI에서 for try await로 받으면 깔끔합니다.",
                tokensPerSecond: 12.4,
                tokenCount: 142
            ),
        ]
    }

    var parameterSummary: String {
        String(format: "temp %.1f · top-p %.1f · %d", params.temperature, params.topP, params.maxTokens)
    }

    func send() {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isGenerating else { return }
        messages.append(ChatMessage(role: .user, text: trimmed))
        input = ""
        startGeneration(for: trimmed)
    }

    func stop() {
        generationTask?.cancel()
    }

    /// 선택한 모델로 새 대화를 시작한다. 진행 중 생성은 취소하고 대화를 비운다.
    func startNewChat(with modelName: String) {
        generationTask?.cancel()
        isGenerating = false
        loadedModelName = modelName
        messages = []
        input = ""
    }

    private func startGeneration(for prompt: String) {
        isGenerating = true
        messages.append(ChatMessage(role: .assistant, text: "", isStreaming: true))
        let index = messages.count - 1

        generationTask = Task {
            let reply = Self.mockReply(to: prompt)
            let started = Date()
            var produced = 0

            for token in reply.map(String.init) {
                if Task.isCancelled { break }
                try? await Task.sleep(for: .milliseconds(26))
                produced += 1
                messages[index].text += token
            }

            let elapsed = max(Date().timeIntervalSince(started), 0.001)
            messages[index].isStreaming = false
            messages[index].tokenCount = produced
            messages[index].tokensPerSecond = Double(produced) / elapsed
            isGenerating = false
        }
    }

    private static func mockReply(to prompt: String) -> String {
        "좋은 질문이에요. 로컬 MLX 모델을 actor로 감싸고 generate가 AsyncThrowingStream<GenerationEvent, Error>를 반환하게 하면, 같은 스트림을 채팅 UI와 OpenAI 호환 서버가 함께 재사용할 수 있습니다."
    }
}
