import Foundation

protocol LoadingViewModel: class {
    var downloader: DispatchGroup { get }
    var state: LoadingState { get set }
    var dataSource: [VoidBlock] { get }
    var errors: [ApiError] { get set }

    func handleResults()
}

extension LoadingViewModel {
    func loadContent() {
        state = .loading
        errors = []

        dataSource.forEach { closure in
            closure()
        }

        downloader.notify(queue: DispatchQueue.main) { [weak self] in
            self?.handleResults()
        }
    }

    func handleErrorIfNeeded(_ error: ApiError?) {
        if let error = error {
            errors.append(error)
            state = .error
        }
    }
}
