import SwiftUI

struct LibraryView: View {
    @Bindable var model: LibraryViewModel

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            resultsList
            Divider()
            footer
        }
        .navigationTitle("라이브러리")
        .searchable(text: $model.query, placement: .toolbar, prompt: "mlx-community 모델 검색")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("", selection: $model.selectedTab) {
                ForEach(LibraryViewModel.Tab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(width: 220)

            GlassGroup(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(model.availableFilters, id: \.self) { filter in
                        FilterChip(title: filter, isActive: model.activeFilters.contains(filter)) {
                            model.toggleFilter(filter)
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(model.filteredResults) { item in
                    ModelRowView(
                        model: item,
                        onDownload: { model.download(item) },
                        onDelete: { model.delete(item) }
                    )
                }
            }
            .padding(16)
        }
    }

    private var footer: some View {
        HStack {
            Label(model.modelsPath, systemImage: "folder")
            Spacer()
            Text(String(format: "%d개 모델 · %.1f GB 사용 중",
                        model.installedModels.count, model.usedDiskGB))
        }
        .font(.system(size: 12))
        .foregroundStyle(.secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

private struct FilterChip: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12))
                .padding(.vertical, 5)
                .padding(.horizontal, 12)
                .foregroundStyle(isActive ? Color.accentColor : .secondary)
                .chipGlass(active: isActive)
        }
        .buttonStyle(.plain)
    }
}
