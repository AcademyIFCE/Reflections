//
//  ReflectionListView.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 12/06/23.
//

import Foundation
import UIKit

extension ReflectionListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.reflectionsByDate.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.reflectionsByDate[section].dateString
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reflectionsByDate[section].reflections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reflection = viewModel.reflectionsByDate[indexPath.section].reflections[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = reflection.title
        cell.detailTextLabel?.text = reflection.content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reflection = viewModel.reflectionsByDate[indexPath.section].reflections[indexPath.row]
        
        let refVC = ReflectionViewController(
            viewModel: .init(
                reflection: reflection,
                endEditHandler: viewModel.handleEndEdit(on:),
                deleteHandler: viewModel.handleDelete(on:)
            )
        )
        
        if UIDevice.current.model == "iPhone" {
            self.navigationController?.pushViewController(refVC, animated: true)
        } else {
            self.splitViewController?.setViewController(refVC, for: .secondary)
        }
    }
    
}
