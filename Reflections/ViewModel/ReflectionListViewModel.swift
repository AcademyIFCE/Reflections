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
            updateViewHandler?(.success(()))
        }
    }
    
    var reflectionsByDate: [(dateString: String, reflections: [Reflection])] {
        reflections.reduce(into: [:]) { (result, reflection) in
            let dateString = DateFormatter.localizedString(from: reflection.creationDate ?? Date(), dateStyle: .short, timeStyle: .none)
            result[dateString, default: []].append(reflection)
        }
        .sorted { $0.0 < $1.0 }
        .map { (dateString: $0.0, reflections: $0.1) }
    }
    
    var updateViewHandler: ((Result<Void, Error>) -> Void)?
    
    func newReflection() -> Reflection {
        let new = Reflection()
        reflections.append(new)
        return new
    }
    
    func handleEndEdit(on reflection: Reflection) {
        for index in reflections.indices {
            if reflections[index].id == reflection.id {
                reflections[index] = reflection
            }
        }

        Task {
            var reflection = reflection
            do {
                try await reflection.save(on: .privateDB)
                print("✅ save complete")
            } catch {
                print("❌ save error", error)
                updateViewHandler?(.failure(error))
            }
        }
    }
    
    func handleDelete(on reflection: Reflection) {
        reflections.removeAll { $0.id == reflection.id }

        Task {
            do {
                try await reflection.delete(on: .privateDB)
                print("✅ delete complete")
            } catch {
                print("❌ delete error", error)
                updateViewHandler?(.failure(error))
            }
        }
    }
    
    func queryReflections() async {
        do {
            reflections = try await Reflection.query(on: .privateDB).all()
            print("✅ query complete")
        } catch {
            print("❌ query error", error)
            updateViewHandler?(.failure(error))
        }
    }
    
}
