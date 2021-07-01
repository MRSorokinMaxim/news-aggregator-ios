import TableKit

protocol SettingBuilderDataSource {
    var settingViewModels: SettingCellViewModel { get }
}

protocol SettingBuilder {
    func buildSections(from dataSource: SettingBuilderDataSource) -> [TableSection]
}

final class SettingBuilderImpl: SettingBuilder {
    // MARK: - Interface

    func buildSections(from dataSource: SettingBuilderDataSource) -> [TableSection] {
        [
            makeNewsSection(from: dataSource),
        ]
    }

    // MARK: - Public methods

    private func makeNewsSection(from dataSource: SettingBuilderDataSource) -> TableSection {
        let row = SettingTableRow(item: dataSource.settingViewModels)
        return .init(rows: [row])
    }
}
