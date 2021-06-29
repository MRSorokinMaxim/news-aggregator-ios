import Foundation
import UIKit

protocol ImagePass {
    var image: UIImage? { get }
}

final class ImageLoadOperation: AsyncOperation {
    private let path: String?

    var result: Result<UIImage?, Error>?
    
    init(path: String?) {
        self.path = path
        super.init()
    }
    
    override func main() {
        if let imagePath = path {
            asyncImageLoad(path: imagePath) { [weak self] result in
                self?.result = result
                self?.state = .finished
            }
        }
    }
    
    private func asyncImageLoad(path: String,
                                complection: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let url = URL(string: path) else {
            complection(.failure(ImageDownloadError.imageDownloadError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let data = data {
                complection(.success(UIImage(data: data)))
                return
            }
            
            if let error = error {
                complection(.failure(error))
            }
        }
        
        task.resume()
    }
}

extension ImageLoadOperation: ImagePass {
    var image: UIImage? {
        switch result {
        case let .success(image?):
            return image
        default:
            return nil
        }
    }
}
