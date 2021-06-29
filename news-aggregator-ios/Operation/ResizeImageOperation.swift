import Foundation
import UIKit

final class ResizeImageOperation: AsyncOperation<UIImage?, Error> {
    private let inputImage: UIImage?
    private let width: CGFloat
    
    private var dependencyObservation: NSKeyValueObservation?
    
    init(image: UIImage?, width: CGFloat) {
        self.inputImage = image
        self.width = width
        super.init()

        state = .isReady
    }
    
    override func start() {
        super.start()
        
        if let dataProvider = dependencies.filter({ $0 is ImageLoadOperation }) .first as? ImageLoadOperation {
            dependencyObservation = dataProvider
                .observe(onSuccess: { [weak self] image in
                    self?.resized(image: image)
                }, onFailure: { [weak self] error in
                    self?.result = .failure(error)
                    self?.state = .isFinished
                })
        }
    }
    
    private func resized(image: UIImage?) {
        if let newSize = image?.size.aspectRatioForWidth(width),
           let resizedImage = image?.resized(size: newSize) {
            result = .success(resizedImage)
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
