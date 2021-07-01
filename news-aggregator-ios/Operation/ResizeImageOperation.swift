import Foundation
import UIKit

final class ResizeImageOperation: AsyncOperation<Image?, Error> {
    private let inputImage: UIImage?
    private let width: CGFloat
    private let tag: Int
    
    private var dependencyObservation: NSKeyValueObservation?
    
    init(image: UIImage?, width: CGFloat, tag: Int) {
        self.inputImage = image
        self.width = width
        self.tag = tag
        super.init()

        state = .isReady
    }
    
    override func start() {
        super.start()

        if let image = inputImage {
            resized(infoImage: .init(image: image, tag: tag))
            return
        }

        if let dataProvider = dependencies.filter({ $0 is ImageLoadOperation }) .first as? ImageLoadOperation {
            dependencyObservation = dataProvider
                .observe(onSuccess: { [weak self] infoImage in
                    self?.resized(infoImage: infoImage)
                }, onFailure: { [weak self] error in
                    self?.result = .failure(error)
                    self?.state = .isFinished
                })
            return
        }
        
        result = .failure(ImageDownloadError.imageDownloadError)
        state = .isFinished
    }
    
    private func resized(infoImage: Image?) {
        if let newSize = infoImage?.image?.size.aspectRatioForWidth(width),
           let resizedImage = infoImage?.image?.resized(size: newSize),
           let tag = infoImage?.tag {
            result = .success(.init(image: resizedImage, tag: tag) )
        } else {
            result = .failure(ImageDownloadError.imageResizedError)
        }
        
        state = .isFinished
    }
}

private extension UIImage {
    func resized(size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = self

        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

private extension CGSize {
    func aspectRatioForWidth(_ width: CGFloat) -> CGSize {
        return CGSize(width: width, height: width * self.height / self.width)
    }
}
