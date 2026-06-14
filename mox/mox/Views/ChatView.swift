//
//  ChatView.swift
//  mox
//
//  Created by 이경민 on 6/14/26.
//

import SwiftUI

struct ChatView: View {
    @Bindable var model: ChatViewModel
    var onSelectModel: (String) -> Void
    @State private var showParams = false
    
    var body: some View {
        messageList
            .safeAreaInset(edge: .bottom, spacing: .zero) {
                ChatInputBar(model: model, onSelectModel: onSelectModel)
            }
            .toolbar {
                toolbarContent
            }
    }
    
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(model.messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }
                }
                .padding(16)
            }
            .onChange(of: model.messages.last?.text) {
                guard let last = model.messages.last else { return }
                withAnimation(.easeOut(duration: 0.15)) {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
    }
    
    @ToolbarContentBuilder
        private var toolbarContent: some ToolbarContent {
            ToolbarItem(placement: .navigation) {
                Menu {
                    Button("Llama-3.2-3B-Instruct-4bit") {}
                    Button("Qwen2.5-7B-Instruct-4bit") {}
                    Divider()
                    Button("모델 언로드", role: .destructive) {}
                } label: {
                    Label(model.loadedModelName, systemImage: "cpu")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showParams.toggle()
                } label: {
                    Label(model.parameterSummary, systemImage: "slider.horizontal.3")
                }
                .popover(isPresented: $showParams, arrowEdge: .bottom) {
                    ParametersView(params: $model.params)
                        .padding(16)
                        .frame(width: 260)
                }
            }
        }
}

private struct ParametersView: View {
    @Binding var params: GenerationParameters
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("생성 파라미터").font(.system(size: 13, weight: .medium))
            
            sliderRow("Temperature", value: $params.temperature, range: 0...2, step: 0.1)
            sliderRow("Top-p", value: $params.topP, range: 0...1, step: 0.05)
            
            Stepper("Max tokens: \(params.maxTokens)", value: $params.maxTokens, in: 256...8192, step: 256)
                .font(.system(size: 12))
        }
    }
        
    private func sliderRow(_ title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(title).font(.system(size: 12))
                Spacer()
                Text(String(format: "%.2f", value.wrappedValue))
                    .font(.system(size: 12)).foregroundStyle(.secondary)
            }
            Slider(value: value, in: range, step: step)
        }
    }
}

#Preview {
    ChatView(model: ChatViewModel(), onSelectModel: { _ in })
        .frame(width: 800, height: 400)
}
