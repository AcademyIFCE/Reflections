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
        setupLayout()
        registerForNotifications()
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWasShown(notification:)), name:UIResponder.keyboardDidShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden(notification:)), name:UIResponder.keyboardWillHideNotification, object:nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo
        if let keyboardRect = info?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            let keyboardSize = keyboardRect.size
            textView.contentInset = UIEdgeInsets(
                top: 0, left: 0, bottom: keyboardSize.height, right: 0
            )
            textView.scrollIndicatorInsets = textView.contentInset
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        textView.contentInset = UIEdgeInsets(top: 0, left: 0,
            bottom: 0, right: 0)
        textView.scrollIndicatorInsets = textView.contentInset
    }

    @objc override func delete(_ sender: Any?) {
        let alert = UIAlertController(title: "Esta ação é irreversível", message: "Você está prestes a deletar uma reflection.", preferredStyle: .actionSheet)
        alert.addAction(.init(title: "Deletar Reflection", style: .destructive) { [unowned self] _ in
            deleteHandler(reflection)
            navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(.init(title: "Cancelar", style: .cancel) {
            $0.isEnabled.toggle()
        })
        if UIDevice.current.model != "iPhone" {
            alert.popoverPresentationController?.sourceItem = sender as! UIBarButtonItem
        }
        self.present(alert, animated: true)
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
    
    @objc func exit(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func setupLayout() {
        self.view.backgroundColor = .systemGroupedBackground
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(exit))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(saveAndExit))
        
        self.navigationController?.isToolbarHidden = false
        let trashButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(delete))
        trashButton.tintColor = .systemRed
        self.toolbarItems = [
            .flexibleSpace(),
            trashButton
        ]
        
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
    
}

extension ReflectionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        edit(textView)
    }
}
