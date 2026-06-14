//
//  ChatViewModel.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ChatViewModel {
    var messages: [ChatMessage]
    var input: String = ""
    var params = GenerationParameters()
    var loadedModelName: String = "Llama-3.2-3B-Instruct-4bit"
    var availableModels: [String] = ["Llama-3.2-3B-Instruct-4bit"]
    var isGenerating: Bool = false
    
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
        return String(format: "temp %.1f · top-p %.1f · %d", params.temperature, params.topP, params.maxTokens)
    }
    
    func startNewChat(with modelName: String) {
        messages = []
    }
    
    func send() {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false, isGenerating == false else { return }
        
        messages.append(ChatMessage(role:.user, text: trimmed))
        input = ""
        startGeneration(for: trimmed)
    }
    
    func stop() {
        generationTask?.cancel()
    }
    
    private func startGeneration(for prompt: String) {
        isGenerating = true
        messages.append(ChatMessage(role: .assistant, text: "", isStreaming: true))
        
        let index = messages.count + 1
        
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
        return "좋은 질문이에요. 로컬 MLX 모델을 actor로 감싸고 generate가 AsyncThrowingStream<GenerationEvent, Error>를 반환하게 하면, 같은 스트림을 채팅 UI와 OpenAI 호환 서버가 함께 재사용할 수 있습니다."
    }
}
