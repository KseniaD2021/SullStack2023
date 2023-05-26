
import AutoLayoutSugar
import Foundation
import UIKit
import SwiftUI

// MARK: - HistoryVC

final class HistoryVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.History.title
        
        view.addSubview(tableView)
        tableView.top(to: .bottom, of: segmentedControl).left().right().bottom()
        configTableView()
        
        historyService?.getOrdersList(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(orders):
                self.items = orders
            case .failure:
                break
            }
        })
    }
    
    static let historyCellReuseId: String = HistoryCell.description()
    
    var historyService: HistoryService?
    
    
    var snacker: Snacker?
    
    var items: [Order] = [] {
        didSet {
            snapshot(Array(items))
        }
    }
    
    func setup(with historyService: HistoryService) {
        self.historyService = historyService
        
    }

    func configTableView() {
        dataSource = UITableViewDiffableDataSource<SimpleDiffableSection, Order>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, modelHistory -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: Self.historyCellReuseId,
                    for: indexPath
                ) as? HistoryCell else {
                    return nil
                }
                cell.modelHistory = modelHistory
                
                
                return cell
            }
        )
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
    
    func snapshot(_ items: [Order]) {
        var snapshot = NSDiffableDataSourceSnapshot<SimpleDiffableSection, Order>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func loadNextPage() {
        isLoadingNextPage = true
        historyService?.getOrdersList(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(orders):
                self.items += orders
            case .failure:
                break
            }
            self.isLoadingNextPage = false
        })
    }
    
    private var isLoadingNextPage: Bool = false {
        didSet {
            loadFooterView(load: isLoadingNextPage)
        }
    }
    
    private enum SimpleDiffableSection: Int, Hashable {
        case main
    }
    
    private var dataSource: UITableViewDiffableDataSource<SimpleDiffableSection, Order>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: Self.historyCellReuseId
        )
        return tableView
    }()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func tabSegmented(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            historyService?.getOrdersList(completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case let .success(orders):
                    self.items = orders
                    
                case .failure:
                    break
                }
            })
        case 1:
            items = []
            historyService?.getOrdersList(completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case let .success(orders):
                    for product in orders{
                        if product.status == "in_work" {
                            self.items.append(product)
                            
                        }
                        
                    }
                case .failure:
                    break
                }
            })
        default:
            break
        }
    }
    
}


extension HistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard items.indices.contains(indexPath.row) else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: .default, title: L10n.Action.deleteAction) {
            _, indexPath in
            let alert = UIAlertController(title: L10n.Action.delete, message: L10n.Question.delete, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: L10n.Action.deleteAction, style: .default) { (sender: UIAlertAction) -> Void in
                guard self.items.indices.contains(indexPath.row) else {
                    return
                }
                let id = self.items[indexPath.row].id
                self.historyService?.deleteOrder(id: id, completion: { (result: Result<Void, Error>) in
                    switch result {
                    case let .success(id):
                        self.items.remove(at: indexPath.row)
                        print(id)
                    case .failure:
                        print("fail")
                    }
                })
            })
            guard self.items.indices.contains(indexPath.row) else {
                return
            }
            let status = self.items[indexPath.row].status
            if status == "cancelled" {
                alert.addAction(UIAlertAction(title: L10n.Action.cancel, style: .cancel){ (sender: UIAlertAction) -> Void in })
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: L10n.Action.error, message: L10n.Action.errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: L10n.Action.ok, style: .cancel){ (sender: UIAlertAction) -> Void in
                })
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        shareAction.backgroundColor = UIColor.red
        return [shareAction]
    }
}


