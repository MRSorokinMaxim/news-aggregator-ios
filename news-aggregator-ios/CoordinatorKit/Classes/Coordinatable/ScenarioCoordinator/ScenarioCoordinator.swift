import Foundation

open class ScenarioCoordinator<T: Scenario>: BaseCoordinator {

    open func start(with scenario: T) {
        assertionFailure("Method start(with:) has not been implemented")
    }
}
