//
//  ChatMessage.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import Foundation

enum ChatRole: String, Codable, Sendable {
    case system
    case user
    case assistant
}

struct ChatMessage: Identifiable, Sendable {
    let id = UUID()
    var role: ChatRole
    var text: String
    var isStreaming: Bool = false
    var tokensPerSecond: Double? = nil
    var tokenCount: Int? = nil
}
