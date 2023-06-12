//
//  ViewModel.swift
//  Reflections
//
//  Created by Gabriela Bezerra on 12/06/23.
//

import Foundation

class ReflectionListViewModel  {
    
    private var reflections: [Reflection] = [] {
        didSet {
            updateViewHandler?()
        }
    }
    
    var reflectionsByDate: [(dateString: String, reflections: [Reflection])] {
        reflections.reduce(into: [:]) { (result, reflection) in
            let dateString = DateFormatter.localizedString(from: reflection.timestamp, dateStyle: .short, timeStyle: .none)
            result[dateString, default: []].append(reflection)
        }
        .sorted { $0.0 < $1.0 }
        .map { (dateString: $0.0, reflections: $0.1) }
    }
    
    var updateViewHandler: (() -> Void)?
    
    func handleEndEdit(on reflection: Reflection) {
        if reflection.record != nil {
            for index in reflections.indices {
                if reflections[index].id == reflection.id {
                    reflections[index] = reflection
                }
            }
        }
        
        Task {
            var reflection = reflection
            do {
                try await reflection.save(on: .privateDB)
                print("✅ save complete")
            } catch {
                print("❌ save error", error)
            }
        }
    }
    
    func handleDelete(on reflection: Reflection) {
        guard reflection.record != nil else { return }
        reflections.removeAll { $0.id == reflection.id }
        Task {
            do {
                try await reflection.delete(on: .privateDB)
                print("✅ delete complete")
            } catch {
                print("❌ delete error", error)
            }
        }
    }
    
    func queryReflections() async {
        do {
            reflections = try await Reflection.query(on: .privateDB).all()
            print("✅ query complete")
        } catch {
            print("❌ query error", error)
        }
    }
    
}
