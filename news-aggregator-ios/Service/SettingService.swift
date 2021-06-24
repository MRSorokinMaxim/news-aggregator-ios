import Foundation

protocol SettingService {
    var newsUpdatFrequency: Int { get }
}

struct SettingServiceImpl: SettingService {

    @UserDefault("newsUpdatFrequency", defaultValue: 30)
    var newsUpdatFrequency: Int
}
