import TableKit

protocol NewsBuilderDataSource {
    var newsSourceViewModels: [NewsCellViewModel]  { get }
    var collapceNewsViewModels: [CollapseNewsViewModel] { get }
}

protocol NewsBuilder {
    func makeNewsSection(from dataSource: NewsBuilderDataSource) -> TableSection
    func makeCollapceNewsSection(from dataSource: NewsBuilderDataSource) -> TableSection
}

final class NewsBuilderImpl: NewsBuilder {

    // MARK: - Public methods

    func makeNewsSection(from dataSource: NewsBuilderDataSource) -> TableSection {
        let rows = dataSource.newsSourceViewModels.map {
            NewsTableRow(item: $0)
        }

        return .init(rows: rows)
    }
    
    func makeCollapceNewsSection(from dataSource: NewsBuilderDataSource) -> TableSection {
        let rows = dataSource.collapceNewsViewModels.map {
            CollapseNewsTableRow(item: $0)
        }

        return .init(rows: rows)
    }
}
