import UIKit

public protocol StackRoutable: ModalRoutable {

    /// Module marked as "head" in the stack
    var headModule: Presentable? { get set }

    /// Module on the top of the stack
    var topModule: Presentable? { get }

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?,
              animated: Bool,
              configurationClosure: ConfigurationClosure?)
    
    func push(_ module: Presentable?,
              animated: Bool,
              configurationClosure: ConfigurationClosure?,
              completion: (() -> ())?)

    func popModule()
    func popModule(animated: Bool)
    func popModule(animated: Bool, completion: (() -> ())?)

    func popToHead()
    func popToHead(animated: Bool)

    func pop(to module: Presentable?)
    func pop(to module: Presentable?, animated: Bool)
}
