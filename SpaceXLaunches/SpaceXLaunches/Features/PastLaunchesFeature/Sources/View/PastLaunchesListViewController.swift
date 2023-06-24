import Foundation
import UIKit

public final class PastLaunchesListViewController: UIViewController {
    private let cellId: String = "Cell"
    private enum Section: Hashable {
        case main
    }

    private var taskCancellables: Set<Task<(), Error>>?
    private let viewModel: PastLaunchesListViewModel

    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, PastLaunch>?

    public init(viewModel: PastLaunchesListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        taskCancellables?.forEach { $0.cancel() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let task = Task {
            try await viewModel.onViewDidLoad()
            configureInitialDiffableSnapshot()
        }
        taskCancellables?.insert(task)
    }
}

private extension PastLaunchesListViewController {
    func setupViews() {
        title = "Past launches"

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, _, pastLaunch in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId) else {
                return UITableViewCell()
            }

            var content = cell.defaultContentConfiguration()
            content.text = pastLaunch.name
            content.secondaryText = pastLaunch.dateUtc.formatted(date: .numeric, time: .shortened)
            cell.contentConfiguration = content

            return cell
        }
    }

    func setupConstraints() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureInitialDiffableSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PastLaunch>()

        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items, toSection: .main)

        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
