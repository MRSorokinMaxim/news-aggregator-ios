import Foundation
import UIKit

final class NewsCellViewModel {
    let iconPath: String?
    let title: String?
    let description: String?
    let sourceName: String?
    let sourceUrl: String?
    private(set) var isOpen: Bool
    let onTap: VoidBlock
    
    var iconUrl: URL? {
        guard let iconPath = iconPath else {
            return nil
        }
        
        return URL(string: iconPath)
    }
    
    var sourceText: NSAttributedString {
        guard let sourceName = sourceName else {
            return .init()
        }

        let attributedString = NSMutableAttributedString(string: "common_source".localized + ": " + sourceName)
        if let sourceUrl = sourceUrl {
            attributedString.addAttribute(
                .link,
                value: sourceUrl,
                range: (attributedString.string as NSString).range(of: sourceName)
            )
        }
        
        return attributedString
    }
    
    func onTouchNews() {
        isOpen = true
        onTap()
    }
    
    init(iconPath: String?,
         title: String?,
         description: String?,
         sourceName: String?,
         sourceUrl: String?,
         isOpen: Bool,
         onTap: @escaping VoidBlock) {
        self.iconPath = iconPath
        self.title = title
        self.description = description
        self.sourceName = sourceName
        self.sourceUrl = sourceUrl
        self.isOpen = isOpen
        self.onTap = onTap
    }
}
