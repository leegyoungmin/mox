import Foundation

/// 라이브러리에 표시되는 모델 한 개. 탐색 결과이자 로컬 모델 항목이기도 하다.
struct ModelInfo: Identifiable, Hashable {
    var id: String { repoId }

    /// 예: "mlx-community/Qwen2.5-7B-Instruct-4bit"
    let repoId: String
    let parameters: String      // "7B"
    let quantization: String    // "4bit"
    let sizeGB: Double
    var state: ModelState
    /// 로드 전 메모리 체크 결과. false면 OOM 경고 배지를 띄운다.
    var fitsInMemory: Bool = true

    var displayName: String {
        repoId.split(separator: "/").last.map(String.init) ?? repoId
    }

    var author: String {
        repoId.split(separator: "/").first.map(String.init) ?? ""
    }
}

enum ModelState: Hashable {
    case available
    case downloading(progress: Double, downloadedGB: Double, speedMBs: Double)
    case installed
}
