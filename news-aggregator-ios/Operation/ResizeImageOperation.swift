import Foundation
import UIKit

final class ResizeImageOperation: AsyncOperation {
    private let inputImage: UIImage?
    private let width: CGFloat
    
    var outputImage: UIImage?
    
    init(image: UIImage?, width: CGFloat) {
        self.inputImage = image
        self.width = width
        super.init()
    }
    
    private var image: UIImage? {
        if let inputImage = inputImage {
            return inputImage
        } else if let dataProvider = dependencies.filter({ $0 is ImagePass }) .first as? ImagePass {
            return dataProvider.image
        } else {
            return nil
        }
    }
    
    override func main() {
        if let newSize = image?.size.aspectRatioForWidth(width),
           let resizedImage = image?.resized(size: newSize) {
               outputImage = resizedImage
        }
        
        state = .finished
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
