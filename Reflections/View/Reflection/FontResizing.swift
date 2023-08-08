//
//  UITextView+Extension.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 13/06/23.
//

import Foundation
import UIKit


protocol FontResizing: AnyObject {
    var font: UIFont? { get set }
}

extension FontResizing {
    func setFont(size: Double) {
        self.font = self.font!.withSize(size)
    }
    
    func increaseFontSize() {
        self.font = self.font!.withSize(self.font!.pointSize + 1)
    }
    
    func decreaseFontSize() {
        self.font = self.font!.withSize(self.font!.pointSize - 1)
    }
}

extension UITextField: FontResizing { }
extension UITextView: FontResizing { }

