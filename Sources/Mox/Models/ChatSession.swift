import Foundation

/// 사이드바에 나열되는 대화 세션. MVP에서는 제목만 보관한다.
struct ChatSession: Identifiable, Hashable {
    let id: UUID
    var title: String

    init(id: UUID = UUID(), title: String) {
        self.id = id
        self.title = title
    }
}
