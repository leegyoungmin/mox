//
//  LibraryViewModel.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class LibraryViewModel {
    enum Tab: String, CaseIterable, Identifiable {
        case discover = "탐색"
        case local = "내 모델"
        
        var id: String { rawValue }
    }
    
    var selectedTab: Tab? = .discover
    var query: String = ""
    var activeFilters: Set<String> = []
    let availableFilters = ["4bit", "8bit", "≤4B", "≤8B"]
    let modelPath = "~/Library/Application Support/Mox/models"
    
    var results: [ModelInfo]
    
    init() {
        results = [
                    ModelInfo(repoId: "mlx-community/Llama-3.2-3B-Instruct-4bit",
                              parameters: "3B", quantization: "4bit", sizeGB: 1.8, state: .installed),
                    ModelInfo(repoId: "mlx-community/Qwen2.5-7B-Instruct-4bit",
                              parameters: "7B", quantization: "4bit", sizeGB: 4.3,
                              state: .downloading(progress: 0.62, downloadedGB: 2.7, speedMBs: 18)),
                    ModelInfo(repoId: "mlx-community/Phi-3.5-mini-instruct-4bit",
                              parameters: "3.8B", quantization: "4bit", sizeGB: 2.2, state: .available),
                    ModelInfo(repoId: "mlx-community/gemma-2-9b-it-4bit",
                              parameters: "9B", quantization: "4bit", sizeGB: 5.1,
                              state: .available, fitsInMemory: false),
                ]
    }
    
    var filteredResults: [ModelInfo] {
            results.filter { model in
                let matchesQuery = query.isEmpty || model.repoId.localizedCaseInsensitiveContains(query)
                let matchesFilter = activeFilters.isEmpty || activeFilters.contains(model.quantization)
                return matchesQuery && matchesFilter
            }
        }

    var installedModels: [ModelInfo] { results.filter { $0.state == .installed } }
    var usedDiskGB: Double { installedModels.reduce(0) { $0 + $1.sizeGB } }
    
    func toggleFilter(_ filter: String) {
        if activeFilters.contains(filter) {
            activeFilters.remove(filter)
        } else {
            activeFilters.insert(filter)
        }
    }
    
    func download(_ model: ModelInfo) { /* TODO: DownloadManager 연결 */ }
    
    func delete(_ model: ModelInfo) { /* TODO: ModelStore 연결 */ }
}
