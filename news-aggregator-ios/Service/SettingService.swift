import Foundation

protocol SettingServiceDelegate: AnyObject {
    func updateNewsUpdatFrequency(_ value: String)
}

protocol SettingService: AnyObject {
    var newsUpdatFrequency: String { get set }

    func addDelegate(_ delegate: SettingServiceDelegate)
}

final class SettingServiceImpl: SettingService {

    @UserDefault("newsUpdatFrequency", defaultValue: "30")
    var newsUpdatFrequency: String {
        didSet {
            delegates.forEach { $0.updateNewsUpdatFrequency(newsUpdatFrequency) }
        }
    }
    
    private var delegates: [SettingServiceDelegate] = []
    
    func addDelegate(_ delegate: SettingServiceDelegate) {
        guard (delegates.first(where: { $0 === delegate }) == nil) else { return }
        delegates.append(delegate)
    }
}
