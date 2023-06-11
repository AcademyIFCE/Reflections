//
//  ReflectionViewController.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import Foundation
import UIKit

class ReflectionViewController: UIViewController {

    var reflection: Reflection {
        willSet {
            editReflectionHandler(newValue)
        }
    }
    
    var editReflectionHandler: (Reflection) -> Void
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.text = reflection.title
        textField.font = UIFont.systemFont(ofSize: 28)
        return textField
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = reflection.content
        textView.font = UIFont.systemFont(ofSize: 17)
        return textView
    }()
    
    init(reflection: Reflection, editReflectionHandler: @escaping (Reflection) -> Void) {
        self.reflection = reflection
        self.editReflectionHandler = editReflectionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGroupedBackground
        self.titleTextField.text = reflection.title

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
