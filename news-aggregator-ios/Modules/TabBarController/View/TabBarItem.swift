import UIKit

enum TabBarItem: Int, CaseIterable {
    case news
    case setting
}

extension TabBarItem {
    private var title: String {
        switch self {
        case .news:
            return "common_global_news".localized

        case .setting:
            return "common_global_setting".localized
        }
    }

    private var icon: UIImage? {
        switch self {
        case .news:
            return UIImage(named: "news_icon")

        case .setting:
            return UIImage(named: "setting_icon")
        }
    }

    func asTabBarItem() -> UITabBarItem {
        let item = UITabBarItem(title: title, image: icon, selectedImage: icon)
        item.setTitleTextAttributes(
            [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.blue
            ],
            for: .selected)

        item.setTitleTextAttributes(
            [
                .font: UIFont.systemFont(ofSize: 10, weight: .medium),
                .foregroundColor: UIColor.black
            ],
            for: .normal)

        return item
    }
}
