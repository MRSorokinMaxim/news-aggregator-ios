import Foundation
import UIKit

enum ImageDownloadError: Error {
    case imageDownloadError
}

final class ImageDownloadService {
    static let shared = ImageDownloadService()
    
    private var imageCache = NSCache<AnyObject, UIImage>()
    private let imageLoadQueue = OperationQueue()
    
    func asyncImageLoad(path: String?,
                        width: CGFloat,
                        complection: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let path = path else {
            complection(.failure(ImageDownloadError.imageDownloadError))
            return
        }
        
        if let image = imageCache.object(forKey: path as AnyObject) {
            complection(.success(image))
            return
        }

        let imageLoadOperation = ImageLoadOperation(path: path)
        imageLoadOperation.completionBlock = { [weak imageLoadOperation] in
            OperationQueue.main.addOperation {
                switch imageLoadOperation?.result {
                case let .failure(error):
                    complection(.failure(error))

                default:
                    break
                }
            }
        }
        
        let resizeImageOperation = ResizeImageOperation(image: nil, width: width)
        resizeImageOperation.completionBlock = { [weak self, weak resizeImageOperation] in
            OperationQueue.main.addOperation {
                guard let image = resizeImageOperation?.outputImage else {
                    complection(.failure(ImageDownloadError.imageDownloadError))
                    return
                }
                
                self?.imageCache.setObject(image, forKey: path as AnyObject)
                
                complection(.success(image))
            }
        }

        resizeImageOperation.addDependency(imageLoadOperation)

        imageLoadQueue.addOperations([imageLoadOperation, resizeImageOperation], waitUntilFinished: true)
    }
}

extension UIImageView {

    func load(path: String?,
              width: CGFloat,
              downloader: ImageDownloadService = .shared,
              completion: VoidBlock? = nil) {
        downloader.asyncImageLoad(path: path, width: width) { [weak self] result in
            switch result {
            case let .success(image):
                self?.image = image
                completion?()
            case let .failure(error):
                print(error)
                completion?()
            }
        }
    }
}
