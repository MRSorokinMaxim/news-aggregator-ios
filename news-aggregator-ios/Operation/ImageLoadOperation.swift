import Foundation
import UIKit

final class ImageLoadOperation: AsyncOperation<UIImage?, Error> {
    private let path: String?
    
    init(path: String?) {
        self.path = path

        super.init()
        self.state = .isReady
    }
    
    override func start() {
        super.start()

        if let imagePath = path {
            asyncImageLoad(path: imagePath) { [weak self] result in
                self?.result = result
                self?.state = .isFinished
            }
        } else {
            result = .failure(ImageDownloadError.imagePathError)
            state = .isFinished
        }
    }
    
    private func asyncImageLoad(path: String,
                                completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url = URL(string: path) else {
            completion(.failure(ImageDownloadError.imageDownloadError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let data = data {
                completion(.success(UIImage(data: data)))
                return
            }

            if let error = error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
