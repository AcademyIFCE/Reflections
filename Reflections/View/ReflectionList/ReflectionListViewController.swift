//
//  ReflectionListViewController.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import UIKit

class ReflectionListViewController: UITableViewController {
    
    var viewModel: ReflectionListViewModel
    
    init(viewModel: ReflectionListViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.updateViewHandler = { [weak self, tableView] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.hideUnsyncedView()
                    tableView!.reloadData()
                case .failure(let error):
                    self?.showUnsyncedView(error.localizedMessageForCKError)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        Task {
            await viewModel.queryReflections()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Task {
            await viewModel.queryReflections()
            refreshControl?.endRefreshing()
        }
    }

    @objc func newReflection(_ sender: UIBarButtonItem) {
        let newRefVC = ReflectionViewController(
            viewModel: .init(
                reflection: viewModel.newReflection(),
                endEditHandler: viewModel.handleEndEdit(on:),
                deleteHandler: viewModel.handleDelete(on:)
            )
        )
        
        if UIDevice.current.model == "iPhone" {
            self.navigationController?.pushViewController(newRefVC, animated: true)
        } else {
            self.splitViewController?.setViewController(newRefVC, for: .secondary)
        }
    }
    
    func setupLayout() {
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "Minhas Reflections"

        #if targetEnvironment(macCatalyst)
        self.navigationItem.pinnedTrailingGroup = .init(
            barButtonItems: [
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newReflection)),
                UIBarButtonItem(image: .init(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(refresh))
            ],
            representativeItem: nil
        )
        
        #else
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newReflection))
        ]
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        #endif
    }
    
    var header: UIView?
    
    func showUnsyncedView(_ text: String) {
        header = SyncWarningView(message: text).uiView
        tableView.tableHeaderView = header
        header?.translatesAutoresizingMaskIntoConstraints = false
        header?.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        tableView.reloadData()
    }
    
    func hideUnsyncedView() {
        tableView.tableHeaderView = nil
        tableView.reloadData()
    }

}



import SwiftUI

struct SyncWarningView: View {
    var message: String

    var body: some View {
        HStack {
            Text(message)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
                .padding(.vertical)
                .background(Color.accentColor.opacity(0.25))
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
    }
    
    @MainActor
    var uiView: UIView {
        UIHostingConfiguration(content: { self })
            .margins(.horizontal, 0)
            .makeContentView()
    }
}

//#Preview("ReflectionListViewController") {
//    UINavigationController(rootViewController: ReflectionListViewController())
//}
