import Foundation
import UIKit

struct Image {
    let image: UIImage?
    let tag: Int
}

final class ImageLoadOperation: AsyncOperation<Image?, Error> {
    private let path: String?
    private let tag: Int
    
    init(path: String?,
         tag: Int) {
        self.path = path
        self.tag = tag

        super.init()
        self.state = .isReady
    }
    
    override func start() {
        super.start()

        guard let imagePath = path else {
            result = .failure(ImageDownloadError.imagePathError)
            state = .isFinished
            return
        }

        asyncImageLoad(path: imagePath, tag: tag) { [weak self] result in
            self?.result = result
            self?.state = .isFinished
        }
    }
    
    private func asyncImageLoad(path: String,
                                tag: Int,
                                completion: @escaping (Result<Image?, Error>) -> Void) {
        guard let url = URL(string: path) else {
            completion(.failure(ImageDownloadError.imageDownloadError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let data = data {
                completion(.success(.init(image: UIImage(data: data), tag: tag)))
                return
            }

            if let error = error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
