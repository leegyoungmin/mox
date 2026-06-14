//
//  GenerationParameters.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

struct GenerationParameters: Sendable, Equatable {
    var temperature: Double = 0.7
    var topP: Double = 0.9
    var maxTokens: Int = 2048
}
