//
//  ModelInfo.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

struct ModelInfo: Identifiable, Hashable {
    var id: String {
        return repoId
    }
    
    let repoId: String
    let parameters: String
    let quantization: String
    let sizeGB: Double
    var state: ModelState
    var fitsInMemory: Bool = true
    
    var displayName: String {
        return repoId.split(separator: "/").last.map(String.init) ?? repoId
    }
    
    var author: String {
        return repoId.split(separator: "/").first.map(String.init) ?? ""
    }
}

enum ModelState: Hashable {
    case available
    case downloading(progress: Double, downloadedGB: Double, speedMBs: Double)
    case installed
}
