//
//  ChatInputBar.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import SwiftUI

struct ChatInputBar: View {
    @Bindable var model: ChatViewModel
    /// 모델을 고르면 호출 → 그 모델로 새 채팅 시작.
    var onSelectModel: (String) -> Void
    @FocusState private var focused: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            modelSelector

            TextField("메시지를 입력하세요…", text: $model.input, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .lineLimit(1...6)
                .padding(.vertical, 4)
                .padding(.leading, 6)
                .focused($focused)
                .onSubmit { model.send() }

            if model.isGenerating {
                Button(role: .destructive) {
                    model.stop()
                } label: {
                    Label("정지", systemImage: "stop.fill")
                }
                .glassAction(prominent: true)
                .tint(.red)
            } else {
                Button {
                    model.send()
                } label: {
                    Label("보내기", systemImage: "arrow.up")
                }
                .glassAction(prominent: true)
                .disabled(model.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .softGlass(in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }

    /// 입력 바 왼쪽의 모델 선택기. 항목을 고르면 그 모델로 새 채팅을 연다.
    private var modelSelector: some View {
        Menu {
            ForEach(model.availableModels, id: \.self) { name in
                Button {
                    onSelectModel(name)
                } label: {
                    if name == model.loadedModelName {
                        Label(name, systemImage: "checkmark")
                    } else {
                        Text(name)
                    }
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "cpu")
                Text(model.loadedModelName)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .frame(maxWidth: 108, alignment: .leading)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 9))
            }
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(.quaternary, in: Capsule())
        }
        .menuStyle(.button)
        .menuIndicator(.hidden)
        .buttonStyle(.plain)
        .fixedSize()
        .help("모델 선택 — 고르면 새 채팅이 시작됩니다")
    }
}
