//
//  ReflectionListViewController.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import UIKit

class ReflectionListViewController: UITableViewController {
    
    var reflections: [Reflection] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var reflectionsByDate: [(String, [Reflection])] {
        reflections.reduce(into: [:]) { (result, reflection) in
            let date = DateFormatter.localizedString(from: reflection.timestamp, dateStyle: .short, timeStyle: .none)
            result[date, default: []].append(reflection)
        }
        .sorted { $0.0 < $1.0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationItem.title = "Minhas Reflections"

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
        
        Task {
            await queryReflections()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Task {
            await queryReflections()
            refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return reflectionsByDate.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return reflectionsByDate[section].0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reflectionsByDate[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = reflectionsByDate[indexPath.section].1[indexPath.row].title
        cell.detailTextLabel?.text = reflectionsByDate[indexPath.section].1[indexPath.row].content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ref = reflectionsByDate[indexPath.section].1[indexPath.row]
        let refVC = ReflectionViewController(
            reflection: ref,
            endEditHandler: handleEndEdit(on:),
            deleteHandler: handleDelete(on:)
        )
        
        if UIDevice.current.model == "iPhone" {
            self.navigationController?.pushViewController(refVC, animated: true)
        } else {
            self.splitViewController?.setViewController(refVC, for: .secondary)
        }
    }
    
    @objc func newReflection(_ sender: UIBarButtonItem) {
        let newRef = Reflection()
        
        let newRefVC = ReflectionViewController(
            reflection: newRef,
            endEditHandler: handleEndEdit(on:),
            deleteHandler: handleDelete(on:)
        )
        
        if UIDevice.current.model == "iPhone" {
            self.navigationController?.pushViewController(newRefVC, animated: true)
        } else {
            self.splitViewController?.setViewController(newRefVC, for: .secondary)
        }
    }
    
    func handleEndEdit(on reflection: Reflection) {
        if reflection.record != nil {
            for index in reflections.indices {
                if reflections[index].id == reflection.id {
                    reflections[index] = reflection
                }
            }
        }
        
        Task {
            var reflection = reflection
            do {
                try await reflection.save(on: .privateDB)
                print("✅ save complete")
            } catch {
                print("❌ save error", error)
            }
        }
    }
    
    func handleDelete(on reflection: Reflection) {
        guard reflection.record != nil else { return }
        reflections.removeAll { $0.id == reflection.id }
        Task {
            do {
                try await reflection.delete(on: .privateDB)
                print("✅ delete complete")
            } catch {
                print("❌ delete error", error)
            }
        }
    }
    
    func queryReflections() async {
        do {
            reflections = try await Reflection.query(on: .privateDB).all()
            print("✅ query complete")
        } catch {
            print("❌ query error", error)
        }
    }
}

