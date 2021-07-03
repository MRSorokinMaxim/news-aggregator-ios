import XCTest
@testable import news_aggregator_ios
import RealmSwift
import Realm

final class NewsStorageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = name
    }

    override func tearDown() {
        super.tearDown()
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func testStoreAndReadNewsCheckCount() {
        let exp = expectation(description: "News Storage")
        
        NewsServiceMock().obtainTopHeadlines { topHeader , error  in
            let storage: NewsStorage = NewsStorageImpl()
            storage.save(topHeader!.articles)
            
            XCTAssertEqual(storage.read().count, topHeader!.articles.count)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.1)
    }

    
    func testAndStoreNewsCheckProperties() {
        let article = Article(
            source: .init(id: nil, name: "Gazeta.ru"),
            author: "Test",
            title: "Бузова отреагировала на критику Михалкова в свой адрес - Газета.Ru",
            description: "Test1",
            url: "https://lenta.ru/news/2021/07/02/galaxys21ultra/",
            urlToImage: "https://icdn.lenta.ru/images/2021/07/01/12/20210701123224561/share_0bbd689a4f88eced868b3e3bd02011a7.jpg",
            publishedAt: "2021-07-03T16:34:38Z",
            content: nil)
        
        let storage: NewsStorage = NewsStorageImpl()
        storage.save([article])
        let articleFromDisk = storage.read()[0]
        
        XCTAssertEqual(articleFromDisk.source?.id, article.source?.id)
        XCTAssertEqual(articleFromDisk.source?.name, article.source?.name)
        XCTAssertEqual(articleFromDisk.author, article.author)
        XCTAssertEqual(articleFromDisk.title, article.title)
        XCTAssertEqual(articleFromDisk.description, article.description)
        XCTAssertEqual(articleFromDisk.url, article.url)
        XCTAssertEqual(articleFromDisk.urlToImage, article.urlToImage)
        XCTAssertEqual(articleFromDisk.publishedAt, article.publishedAt)
        XCTAssertEqual(articleFromDisk.content, article.content)
    }
}

final class NewsServiceMock: NewsService {
    func obtainEverything(completionHandler: @escaping EverythingCompletion) {
        completionHandler(nil, nil)
    }
    
    func obtainTopHeadlines(completionHandler: @escaping TopHeadlinesCompletion) {
        let result = BaseArticleResponse(status: .ok, totalResults: 100, articles: [
            .init(
                source: .init(id: nil, name: "Gazeta.ru"),
                author: nil,
                title: "Бузова отреагировала на критику Михалкова в свой адрес - Газета.Ru",
                description: "Test",
                url: "https://lenta.ru/news/2021/07/02/galaxys21ultra/",
                urlToImage: "https://icdn.lenta.ru/images/2021/07/01/12/20210701123224561/share_0bbd689a4f88eced868b3e3bd02011a7.jpg",
                publishedAt: "2021-07-03T16:34:38Z",
                content: nil)
            ]
        )
        
        completionHandler(result, nil)
    }
    
    func obtainSources(completionHandler: @escaping SourcesCompletion) {
        completionHandler(nil, nil)
    }
}
