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
    
    private var imageCache: [String: UIImage] = [:]
    private let imageLoadQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .utility
        return operationQueue
    }()
    
    private var imageLock = NSLock()
    private var imageObservations: [Int: NSKeyValueObservation] = [:]
    private var imageObservationsLock: [Int: NSKeyValueObservation] {
        get {
            imageLock.lock()
            defer { imageLock.unlock() }
            return imageObservations
        }
        set {
            imageLock.lock()
            defer { imageLock.unlock() }
            imageObservations = newValue
        }
    }
    
    func asyncImageLoad(path: String?,
                        width: CGFloat,
                        tag: Int,
                        completion: @escaping ParameterClosure<Result<Image?, Error>>) {
        guard let path = path else {
            completion(.failure(ImageDownloadError.imagePathError))
            return
        }
        
        guard let image = imageCache[path + "\(width)"] else {
            startDownloadAndResizeOperation(image: nil,
                                            path: path,
                                            tag: tag,
                                            width: width,
                                            completion: completion)
            return
        }
        
        completion(.success(.init(image: image, tag: tag)))
    }
    
    private func startDownloadAndResizeOperation(
        image: UIImage?,
        path: String,
        tag: Int,
        width: CGFloat,
        completion: @escaping ParameterClosure<Result<Image?, Error>>
    ) {
        let imageLoadOperation = ImageLoadOperation(path: path, tag: tag)
        let resizeImageOperation = createResizeImageOperation(image: nil,
                                                              path: path,
                                                              tag: tag,
                                                              width: width,
                                                              completion: completion)
        resizeImageOperation.addDependency(imageLoadOperation)
        imageLoadQueue.addOperations([imageLoadOperation, resizeImageOperation], waitUntilFinished: false)
    }
    
    private func createResizeImageOperation(
        image: UIImage?,
        path: String,
        tag: Int,
        width: CGFloat,
        completion: @escaping ParameterClosure<Result<Image?, Error>>
    ) -> Operation {
        let resizeImageOperation = ResizeImageOperation(image: image, width: width, tag: tag)

        let hash = resizeImageOperation.hashValue

        let observable = resizeImageOperation
            .observe(onSuccess: { [weak self] infoImage in
                OperationQueue.main.addOperation {
                    guard let infoImage = infoImage else {
                        completion(.failure(ImageDownloadError.unknowed))
                        return
                    }
                    
                    self?.imageCache[path + "\(width)"] = infoImage.image

                    completion(.success(infoImage))
                    self?.removeObservable(with: hash)
                }
            }, onFailure: { [weak self] error in
                OperationQueue.main.addOperation {
                    completion(.failure(error))
                    self?.removeObservable(with: hash)
                }
            })
        
        imageObservationsLock[hash] = observable

        return resizeImageOperation
    }
    
    func removeObservable(with hash: Int) {
        DispatchQueue.global().async { [weak self] in
            self?.imageObservationsLock.removeValue(forKey: hash)
        }
    }
}

extension UIImageView {

    func load(path: String?,
              width: CGFloat,
              downloader: ImageDownloadService = .shared,
              completion: VoidBlock? = nil) {
        let tag = Int.random(in: 1..<100000)

        self.tag = tag
        
        downloader.asyncImageLoad(path: path, width: width, tag: tag) { [weak self] result in
            switch result {
            case let .success(imageInfo?):
                guard let tag = self?.tag, tag == imageInfo.tag else {
                    return
                }

                self?.image = imageInfo.image
                completion?()
                
            case let .failure(error):
                print(error)
                completion?()
                
            default:
                print(ImageDownloadError.imageDownloadError)
                self?.image = nil
                completion?()
            }
        }
    }
}
