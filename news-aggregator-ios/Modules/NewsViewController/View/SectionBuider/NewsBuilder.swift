import TableKit

protocol NewsBuilderDataSource {
    var newsSourceViewModels: [NewsCellViewModel]  { get }
}

final class NewsBuilder {
    // MARK: - Interface

    func buildSections(from dataSource: NewsBuilderDataSource) -> [TableSection] {
        [
            makeNewsSection(from: dataSource),
        ]
    }

    // MARK: - Public methods

    func makeNewsSection(from dataSource: NewsBuilderDataSource) -> TableSection {
        let rows = dataSource.newsSourceViewModels.map {
            NewsTableRow(item: $0)
        }

        return .init(rows: rows)
    }
}
