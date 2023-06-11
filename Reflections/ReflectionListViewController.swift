//
//  ReflectionListViewController.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import UIKit

class ReflectionListViewController: UITableViewController {
    
    var reflections: [Reflection] = [
        .init(timestamp: Date().advanced(by: -1*60*60*24), title: "Olá Mundo", content: "Aqui foi onde o tudo começou."),
        .init(timestamp: Date().advanced(by: -1*60*60*24), title: "Escrever reflections é estranho", content: "Mas eu acho que posso aprender a fazer isso."),
        .init(timestamp: Date(), title: "O segundo dia", content: "As vezes você tem que continuar tentando, mesmo sem se sentir confiante no que ta fazendo.")
    ]
    
    var reflectionsByDate: [(Date, [Reflection])] {
        reflections.reduce(into: [:]) { (result, reflection) in
            let date = reflection.timestamp
            result[date, default: []].append(reflection)
        }
        .sorted { $0.0 < $1.0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationItem.title = "Minhas Reflections"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newReflection))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return reflectionsByDate.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DateFormatter.localizedString(from: reflectionsByDate[section].0, dateStyle: .short, timeStyle: .short)
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
            editReflectionHandler: handleChanges(on:)
        )
        
        if UIDevice.current.model == "iPhone" {
            self.navigationController?.pushViewController(refVC, animated: true)
        } else {
            self.splitViewController?.setViewController(refVC, for: .secondary)
        }
    }
    
    @objc func newReflection(_ sender: UIBarButtonItem) {
        let newRefVC = ReflectionViewController(
            reflection: Reflection(),
            editReflectionHandler: handleChanges(on:)
        )
        
        if UIDevice.current.model == "iPhone" {
            self.navigationController?.pushViewController(newRefVC, animated: true)
        } else {
            self.splitViewController?.setViewController(newRefVC, for: .secondary)
        }
    }
    
    func handleChanges(on reflection: Reflection) {
        print(reflection.title)
        print(reflection.content)
    }

}

