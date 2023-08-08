//
//  ReflectionViewController.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import Foundation
import UIKit

class ReflectionViewController: UIViewController {

    var viewModel: ReflectionViewModel
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.text = viewModel.reflection.title
        textField.font = UIFont.systemFont(ofSize: 24)
        textField.addTarget(self, action: #selector(edit), for: .allEditingEvents)
        return textField
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = viewModel.reflection.content
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = self
        return textView
    }()
    
    init(viewModel: ReflectionViewModel) {
        self.viewModel = viewModel
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
            viewModel.deleteHandler(viewModel.reflection)
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
            viewModel.reflection.title = titleTextField.text ?? "Sem título"
        } else if sender is UITextView {
            viewModel.reflection.content = textView.text ?? "Sem conteúdo"
        }
    }
    
    @objc func saveAndExit(_ sender: UIBarButtonItem) {
        viewModel.endEditHandler(viewModel.reflection)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func exit(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func increaseTextSize(_ sender: UIBarButtonItem) {
        print("increase")
        titleTextField.increaseFontSize()
        textView.increaseFontSize()
    }
    
    @objc func decreaseTextSize(_ sender: UIBarButtonItem) {
        print("decrease")
        titleTextField.decreaseFontSize()
        textView.decreaseFontSize()
    }
    
    func setupLayout() {
        
        let (textFieldFontSize, textViewFontSize) = viewModel.loadFontSize()
        self.titleTextField.setFont(size: textFieldFontSize)
        self.textView.setFont(size: textViewFontSize)
        
        self.view.backgroundColor = .systemGroupedBackground
        
        #if targetEnvironment(macCatalyst)
        self.navigationItem.backAction = .init(attributes: .hidden, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        })
        #else
        self.navigationItem.leadingItemGroups = [
            .init(
                barButtonItems: [
                    UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(exit))
                ],
                representativeItem: nil
            )
        ]
        #endif
        
        self.navigationItem.trailingItemGroups = [
            .init(
                barButtonItems: [
                    UIBarButtonItem(image: UIImage(systemName: "minus"), style: .plain, target: self, action: #selector(decreaseTextSize)),
                    UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(increaseTextSize))
                ],
                representativeItem: nil
            ),
            .init(
                barButtonItems: [
                    UIBarButtonItem(title: "Salvar", style: .done, target: self, action: #selector(saveAndExit))
                ],
                representativeItem: nil
            )
        ]
        
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
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
