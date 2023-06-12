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
        self.viewModel.updateViewHandler = { [tableView] in
            DispatchQueue.main.async {
                tableView?.reloadData()
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
            reflection: Reflection(),
            endEditHandler: viewModel.handleEndEdit(on:),
            deleteHandler: viewModel.handleDelete(on:)
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
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newReflection)),
            UIBarButtonItem(image: .init(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(refresh))
        ]
        #else
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newReflection))
        ]
        #endif
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
}

