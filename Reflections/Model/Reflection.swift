//
//  Reflection.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 11/06/23.
//

import Foundation
import Nuvem
import CloudKit

struct Reflection: CKModel {

    var record: CKRecord! = CKRecord(recordType: "Reflection")
    
    @CKField("title", default: "Nova Reflection")
    var title: String
    
    @CKField("content", default: """
- Pense sobre seus erros e acertos:  O que você fez certo? O que poderia ter feito melhor? Como você pode fazer para melhorar ainda mais no futuro?

- Pense sobre o seu próprio aprendizado:  O que aprendi com essa atividade? Como esse aprendizado pode ser útil no futuro? Em que contextos posso aplicar o que aprendi?

- Pense sobre seus sentimentos: Como me senti/estou me sentindo? O que me empolga/empolgou? O me incomoda/incomodou?

- Pense sobre o academy: No que essa atividade me ajudou? No que não me ajudou? Como ela poderia ser melhor para mim e para a turma?
""")
    var content: String
    
    init() { }
    
    init(record: CKRecord! = nil, title: String, content: String) {
        self.record = record
        self.title = title
        self.content = content
    }
}

