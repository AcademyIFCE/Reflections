//
//  CloudKit+Extension.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 12/06/23.
//

import Foundation
import CloudKit

extension CKDatabase {
    static var privateDB: CKDatabase = CKContainer.default().database(with: .private)
}
