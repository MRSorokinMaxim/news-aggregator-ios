import Foundation

public protocol Coordinatable: AnyObject {

    var onFinish: ((Coordinatable) -> ())? { get set }

    func start()
}
