//
//  ReflectionViewController.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import Foundation
import UIKit

class ReflectionViewController: UIViewController {

    var reflection: Reflection
    
    var endEditHandler: (Reflection) -> Void
    var deleteHandler: (Reflection) -> Void
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.text = reflection.title
        textField.font = UIFont.systemFont(ofSize: 28)
        textField.addTarget(self, action: #selector(edit), for: .allEditingEvents)
        return textField
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = reflection.content
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = self
        return textView
    }()
    
    init(reflection: Reflection, endEditHandler: @escaping (Reflection) -> Void, deleteHandler: @escaping (Reflection) -> Void) {
        self.reflection = reflection
        self.endEditHandler = endEditHandler
        self.deleteHandler = deleteHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        self.titleTextField.text = reflection.title
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(delete))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: {
                let button = UIButton()
                button.setTitle(" Salvar e fechar", for: .normal)
                button.setImage(UIImage(systemName: "bird.fill"), for: .normal)
                button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
                button.addTarget(self, action: #selector(saveAndExit), for: .touchUpInside)
                return button
            }()
        )

        self.view.addSubview(titleTextField)
        self.view.addSubview(textView)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.bottomAnchor.constraint(equalTo: textView.topAnchor),
            
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc override func delete(_ sender: Any?) {
        deleteHandler(reflection)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func edit(_ sender: AnyObject) {
        if sender is UITextField {
            reflection.title = titleTextField.text ?? "Sem título"
        } else if sender is UITextView {
            reflection.content = textView.text ?? "Sem conteúdo"
        }
    }
    
    @objc func saveAndExit(_ sender: UIBarButtonItem) {
        endEditHandler(reflection)
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension ReflectionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        edit(textView)
    }
}
