import Foundation
import UIKit

public final class PastLaunchesListViewController: UIViewController {
    private let cellId: String = "Cell"
    private enum Section: Hashable {
        case main
    }

    private let viewModel: PastLaunchesListViewModel

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var dataSource: UITableViewDiffableDataSource<Section, PastLaunch>?

    public init(viewModel: PastLaunchesListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        setupBindings()
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onViewDidLoad()
    }
}

private extension PastLaunchesListViewController {
    func setupBindings() {
        viewModel.onInitialLoad = { [weak self] in
            guard let self else { return }

            var snapshot = NSDiffableDataSourceSnapshot<Section, PastLaunch>()
            snapshot.appendSections([.main])
            snapshot.appendItems(viewModel.items, toSection: .main)
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }

    func setupViews() {
        title = viewModel.navigationTitle

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self

        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, _, pastLaunch in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId) else {
                return UITableViewCell()
            }

            var content = cell.defaultContentConfiguration()
            content.text = pastLaunch.name
            content.secondaryText = pastLaunch.dateUtc.formatted(date: .numeric, time: .shortened)
            content.secondaryTextProperties.color = .secondaryLabel
            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none

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



    }
}
