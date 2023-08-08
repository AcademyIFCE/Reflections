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

extension Error {
    var localizedMessageForCKError: String {
        guard let error = self as? CKError else { return "" }
        switch error.code {
        case .accountTemporarilyUnavailable, .notAuthenticated:
            return "Dados não sincronizados. Logue com seu iCloud neste dispositivo para sincronizar."
        case .networkFailure, .networkUnavailable:
//            return "Dados não sincronizados. Logue com seu iCloud neste dispositivo para sincronizar."
            return "Dados não sincronizados. Você está offline?"
        default:
            return "Dados não sincronizados."
        }
    }
}
