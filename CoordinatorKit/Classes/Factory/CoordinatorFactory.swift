import Foundation

typealias CoordinatorGroup = (coordinator: Coordinatable, presentable: Presentable)
typealias ScenarioGroup<T: Scenario, Coordinator: ScenarioCoordinator<T>> = (coordinator: Coordinator, presentable: Presentable)

final class CoordinatorFactory {
    private(set) var moduleFactory = ModuleFactory()
}
