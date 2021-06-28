import Foundation

final class SettingViewModel: SettingBuilderDataSource {
    
    var settingViewModels: SettingCellViewModel {
        SettingCellViewModel(
            initialValue: settingService.newsUpdatFrequency,
            onEnterValue: { [weak self] in
                self?.settingService.newsUpdatFrequency = $0
            })
    }
    
    private let settingService: SettingService
    
    init(settingService: SettingService) {
        self.settingService = settingService
    }
}
