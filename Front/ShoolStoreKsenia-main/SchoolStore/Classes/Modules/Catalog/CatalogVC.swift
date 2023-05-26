
import AutoLayoutSugar
import Foundation
import UIKit

// MARK: - CatalogVC

final class CatalogVC: UIViewController {
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.Catalog.title
        view.addSubview(tableView)
        tableView.top().left().right().bottom()
        configTableView()
        catalogService?.getCatalogItems(with: 0, limit: 20, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(products):
                self.items = products
            case .failure:
                break
            }
        })
    }

    // MARK: Internal

    static let productCellReuseId: String = ProductCell.description()

    var catalogService: CatalogService?

    var snacker: Snacker?

    var items: [Product] = [] {
        didSet {
            snapshot(Array(items))
        }
    }

    func configTableView() {
        dataSource = UITableViewDiffableDataSource<SimpleDiffableSection, Product>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, model -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: Self.productCellReuseId,
                    for: indexPath
                ) as? ProductCell else {
                    return nil
                }
                cell.model = model
                cell.buyHandler = { product in
                    debugPrint("Buy \(product.id)")
                    self.navigationController?.pushViewController(VCFactory.buildOrderVC(with: model), animated: true)
                }
                return cell
            }
        )
    }

    func snapshot(_ items: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<SimpleDiffableSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func loadNextPage() {
        isLoadingNextPage = true
        catalogService?.getCatalogItems(with: items.count, limit: 12, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(products):
                self.items += products
            case .failure:
                break
            }
            self.isLoadingNextPage = false
        })
    }

    func loadFooterView(load: Bool) {
        if load {
            let view = UIView()
            view.frame.size = .init(width: view.frame.size.width, height: 60)
            view.startLoading(with: .smallBlue)
            tableView.tableFooterView = view
        } else {
            tableView.tableFooterView = UIView()
        }
    }

    // MARK: Private

    private enum SimpleDiffableSection: Int, Hashable {
        case main
    }

    private var dataSource: UITableViewDiffableDataSource<SimpleDiffableSection, Product>?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.register(
            ProductCell.self,
            forCellReuseIdentifier: Self.productCellReuseId
        )
        return tableView
    }()

    private var isLoadingNextPage: Bool = false {
        didSet {
            loadFooterView(load: isLoadingNextPage)
        }
    }
}

// MARK: UITableViewDelegate

extension CatalogVC: UITableViewDelegate {
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard items.indices.contains(indexPath.row) else {
            return
        }
        let id = items[indexPath.row].id
        catalogService?.getProduct(with: id, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(model):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(VCFactory.buildProductVC(with: model), animated: true)
                }
            case let .failure(error):
                self.snacker?.show(snack: error.localizedDescription, with: .error)
            }
        })
    }
    
    

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        guard !isLoadingNextPage else { return }
        let offset = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height

        if scrollView == tableView {
            if (offset + height) >= contentHeight {
                loadNextPage()
            }
        }
    }
}
