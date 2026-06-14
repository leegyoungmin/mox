import SwiftUI

struct ChatView: View {
    @Bindable var model: ChatViewModel
    /// 모델을 고르면 호출 → 그 모델로 새 채팅 시작.
    var onSelectModel: (String) -> Void
    @State private var showParams = false

    var body: some View {
        messageList
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ChatInputBar(model: model, onSelectModel: onSelectModel)
            }
            .toolbar { toolbarContent }
    }

    @ViewBuilder
    private var messageList: some View {
        if model.messages.isEmpty {
            ContentUnavailableView {
                Label("새 대화", systemImage: "message")
            } description: {
                Text("\(model.loadedModelName) 모델로 새 대화를 시작하세요.")
            }
        } else {
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
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
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

    private func sliderRow(_ title: String, value: Binding<Double>,
                           range: ClosedRange<Double>, step: Double) -> some View {
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
