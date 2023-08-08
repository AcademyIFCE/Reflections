//
//  ReflectionViewModel.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 14/06/23.
//

import Foundation

struct ReflectionViewModel {
    var reflection: Reflection
    
    var endEditHandler: (Reflection) -> Void
    var deleteHandler: (Reflection) -> Void
    
    func loadFontSize() -> (textField: Double, textView: Double) {
        (UserDefaults.standard.double(forKey: "textFieldFontSize"), UserDefaults.standard.double(forKey: "textViewFontSize"))
    }
    
    func saveFontSize(textField: Double, textView: Double) {
        UserDefaults.standard.set(textField, forKey: "textFieldFontSize")
        UserDefaults.standard.set(textView, forKey: "textViewFontSize")
    }
}
