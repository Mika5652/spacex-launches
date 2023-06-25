import Foundation
import LaunchDetailFeature
import UIKit
import SharedModels
import SwiftUI

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

            DispatchQueue.main.async {
                var snapshot = NSDiffableDataSourceSnapshot<Section, PastLaunch>()
                snapshot.appendSections([.main])
                snapshot.appendItems(self.viewModel.items, toSection: .main)
                self.dataSource?.apply(snapshot, animatingDifferences: false)
            }
        }

        viewModel.onSortingChange = {
            DispatchQueue.main.async {
                var currentSnapshot = self.dataSource?.snapshot()
                currentSnapshot?.deleteItems(self.viewModel.items)
                currentSnapshot?.appendItems(self.viewModel.items)
                currentSnapshot.map { self.dataSource?.apply($0, animatingDifferences: false) }
            }
        }
    }

    func setupViews() {
        title = viewModel.navigationTitle

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down"),
                menu: UIMenu(
                    title: "Sort list by",
                    options: .singleSelection,
                    children: viewModel.sortTypes.map { type in
                        UIAction(title: type.rawValue) { _ in
                            self.viewModel.handleSortAction(type)
                        }
                    }
                )
            )
        ]

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

extension PastLaunchesListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hostingView = UIHostingController(
            rootView: LaunchDetailView(
                item: viewModel.items[indexPath.row]
            )
        )
        navigationController?.pushViewController(hostingView, animated: true)
    }
}
