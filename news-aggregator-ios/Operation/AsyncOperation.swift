import Foundation

open class AsyncOperation<Output, Failure: Error>: Operation {

    open var result: Result<Output, Failure>?

    var state: State? = nil {
        // KVO support
        willSet {
            willChangeValue(forKey: newValue.orReady.rawValue)
            willChangeValue(forKey: state.orReady.rawValue)
        }

        didSet {
            didChangeValue(forKey: state.orReady.rawValue)
            didChangeValue(forKey: oldValue.orReady.rawValue)
        }
    }

    // MARK: - Operation override

    open override var isCancelled: Bool {
        state == .isCancelled
    }

    open override var isExecuting: Bool {
        state == .isExecuting
    }

    open override var isFinished: Bool {
        state == .isFinished
    }

    open override var isReady: Bool {
        state == .isReady
    }

    open override var isAsynchronous: Bool {
        true
    }

    open override func start() {
        state = .isExecuting

        if result != nil {
            state = .isFinished
        }
    }

    open override func cancel() {
        state = .isCancelled
    }

    // MARK: - Methods for subclass override

    open func handle(result: Output) {
        self.result = .success(result)
    }

    open func handle(error: Failure) {
        self.result = .failure(error)
    }

    // MARK: - Helpers

    func observe(onSuccess: ((Output) -> Void)? = nil,
                 onFailure: ((Failure) -> Void)? = nil) -> NSKeyValueObservation {

        observe(\.isFinished, options: [.new]) { object, change in
            if let isFinished = change.newValue, isFinished {
                switch object.result {
                case let .success(result)?:
                    onSuccess?(result)

                case let .failure(failure)?:
                    onFailure?(failure)

                default:
                    assertionFailure("Got nil result from operation when isFinished was true!")
                }
            }
        }
    }
}

private extension Optional where Wrapped == Operation.State {
    var orReady: Wrapped {
        self ?? .isReady
    }
}

extension Operation {
    enum State: String {
        case isCancelled
        case isExecuting
        case isFinished
        case isReady
    }
}
