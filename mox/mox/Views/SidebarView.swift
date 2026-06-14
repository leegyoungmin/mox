//
//  SidebarView.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import SwiftUI

struct SidebarView: View {
    let sessions: [ChatSession]
    let chat: ChatViewModel
    @Binding var selection: SidebarItem?

    var body: some View {
        List(selection: $selection) {
            Section {
                ModelStatusCard(name: chat.loadedModelName)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 4, leading: 6, bottom: 10, trailing: 6))
            }

            Section("채팅") {
                ForEach(sessions) { session in
                    Label(session.title, systemImage: "message")
                        .tag(SidebarItem.chat(session.id))
                }
            }

            Section {
                Label("라이브러리", systemImage: "square.stack.3d.up")
                    .tag(SidebarItem.library)
                Label("설정", systemImage: "gearshape")
                    .tag(SidebarItem.settings)
            }
        }
        .listStyle(.sidebar)
        .safeAreaInset(edge: .bottom) {
            ServerToggleRow()
        }
    }
}

private struct ModelStatusCard: View {
    let name: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Circle().fill(.green).frame(width: 7, height: 7)
                Text(name)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
            }
            Text("로드됨 · RAM 6.2 / 24 GB")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(.quaternary, lineWidth: 0.5))
    }
}

private struct ServerToggleRow: View {
    @State private var isOn = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "bolt.horizontal.circle")
            Text("로컬 서버").font(.system(size: 13))
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.mini)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.bar)
    }
}
