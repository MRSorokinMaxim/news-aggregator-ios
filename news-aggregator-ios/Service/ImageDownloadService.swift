import Foundation
import UIKit

enum ImageDownloadError: Error {
    case imageDownloadError
    case imagePathError
    case imageResizedError
    case unknowed
}

final class ImageDownloadService {
    static let shared = ImageDownloadService()
    
    private var imageCache = NSCache<AnyObject, UIImage>()
    private let imageLoadQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = .utility
        return operationQueue
    }()
    
    private var imageObservation: NSKeyValueObservation?
    
    func asyncImageLoad(path: String?,
                        width: CGFloat,
                        complection: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let path = path else {
            complection(.failure(ImageDownloadError.imagePathError))
            return
        }
        
        if let image = imageCache.object(forKey: path as AnyObject) {
            complection(.success(image))
            return
        }

        let imageLoadOperation = ImageLoadOperation(path: path)
        let resizeImageOperation = ResizeImageOperation(image: nil, width: width)
        resizeImageOperation.addDependency(imageLoadOperation)
        
        imageObservation = resizeImageOperation
            .observe(onSuccess: { [weak self] image in
                OperationQueue.main.addOperation {
                    if let image = image {
                        self?.imageCache.setObject(image, forKey: path as AnyObject)
                        complection(.success(image))
                    }
                    
                    complection(.failure(ImageDownloadError.unknowed))
                }
            }, onFailure: { error in
                OperationQueue.main.addOperation {
                    complection(.failure(error))
                }
            })

        imageLoadQueue.addOperations([imageLoadOperation, resizeImageOperation], waitUntilFinished: false)
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
