import UIKit

public final class PastLaunchesListViewController: UIViewController {
    private var taskCancellables: Set<Task<(), Error>>?
    private let viewModel: PastLaunchesListViewModel

    public init(viewModel: PastLaunchesListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        taskCancellables?.forEach { $0.cancel() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        taskCancellables?.insert(
            Task {
                try await viewModel.onViewDidLoad()
            }
        )
    }
}

