import SwiftUI

enum SidebarItem: Hashable {
    case chat(ChatSession.ID)
    case library
    case settings
}

/// 앱의 셸. 좌측 사이드바 + 우측 디테일(채팅 / 라이브러리 / 설정).
struct RootView: View {
    @State private var chat = ChatViewModel()
    @State private var library = LibraryViewModel()
    @State private var sessions: [ChatSession] = [
        .init(title: "Swift 동시성 질문"),
        .init(title: "리팩토링 아이디어"),
        .init(title: "정규식 도움"),
    ]
    @State private var selection: SidebarItem?

    var body: some View {
        NavigationSplitView {
            SidebarView(sessions: sessions, chat: chat, selection: $selection)
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
        } detail: {
            switch selection {
            case .library:
                LibraryView(model: library)
            case .settings:
                SettingsView()
            default:
                ChatView(model: chat) { modelName in
                    startNewChat(with: modelName)
                }
            }
        }
        .onAppear {
            if selection == nil { selection = .chat(sessions[0].id) }
        }
    }

    /// 모델을 고르면 그 모델로 새 채팅 세션을 만들어 사이드바 맨 위에 꽂고 선택한다.
    private func startNewChat(with modelName: String) {
        let session = ChatSession(title: "새 채팅")
        sessions.insert(session, at: 0)
        selection = .chat(session.id)
        chat.startNewChat(with: modelName)
    }
}
