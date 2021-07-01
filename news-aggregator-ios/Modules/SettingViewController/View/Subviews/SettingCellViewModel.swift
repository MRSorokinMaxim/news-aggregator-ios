import Foundation

final class SettingCellViewModel {
    let initialValue: String
    let onEnterValue: ParameterClosure<String>
    
    init(initialValue: String,
         onEnterValue: @escaping ParameterClosure<String>) {
        self.initialValue = initialValue
        self.onEnterValue = onEnterValue
    }
}
