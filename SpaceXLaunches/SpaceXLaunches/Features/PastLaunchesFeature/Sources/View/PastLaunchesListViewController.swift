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
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
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
        viewModel.onSortingChange = {
            DispatchQueue.main.async {
                self.hideActivityIndicatorIfNeeded()
                self.reloadData()
            }
        }

        viewModel.onSearchChange = {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }

        viewModel.onLoadingError = { [weak self] in
            DispatchQueue.main.async {
                self?.hideActivityIndicatorIfNeeded()
                self?.showAlert()
            }
        }
    }

    func setupViews() {
        title = "Past Launches"

        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search in names..."
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "arrow.up.arrow.down"),
                menu: UIMenu(
                    title: "Sort list by",
                    options: .singleSelection,
                    children: viewModel.sortTypes.map { type in
                        UIAction(
                            title: type.rawValue,
                            state: self.viewModel.isTypeSelected(type) ? .on : .off
                        ) { _ in
                            self.viewModel.handleSortAction(type)
                        }
                    }
                )
            )
        ]

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

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
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func reloadData() {
        var currentSnapshot = self.dataSource?.snapshot()
        currentSnapshot?.deleteAllItems()
        currentSnapshot?.appendSections([.main])
        currentSnapshot?.appendItems(self.viewModel.items)
        currentSnapshot.map { self.dataSource?.apply($0, animatingDifferences: false) }
    }

    func showAlert() {
        let alertController = UIAlertController(
            title: "Error",
            message: "Loading data error, please try again",
            preferredStyle: .alert
        )

        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
            self.activityIndicator.startAnimating()
            self.viewModel.tryAgainAlertButtonTapped()
        }
        alertController.addAction(tryAgainAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        navigationController?.present(alertController, animated: true)
    }

    func hideActivityIndicatorIfNeeded() {
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        }
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

extension PastLaunchesListViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(searchText)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBarCancelButtonTapped()
    }
}
