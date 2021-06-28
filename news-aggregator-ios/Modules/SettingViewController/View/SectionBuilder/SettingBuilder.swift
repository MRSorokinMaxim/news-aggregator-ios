import TableKit

protocol SettingBuilderDataSource {
    var settingViewModels: SettingCellViewModel { get }
}

final class SettingBuilder {
    // MARK: - Interface

    func buildSections(from dataSource: SettingBuilderDataSource) -> [TableSection] {
        [
            makeNewsSection(from: dataSource),
        ]
    }

    // MARK: - Public methods

    func makeNewsSection(from dataSource: SettingBuilderDataSource) -> TableSection {
        let row = SettingTableRow(item: dataSource.settingViewModels)
        return .init(rows: [row])
    }
}
