//
//  Favourites.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 28.02.2021.
//

import Foundation
import SwiftUI

class Favorites: ObservableObject {
    
    private var snippets: Set<String>
    let defaults = UserDefaults.standard
    
    let library_path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]

    
    
    init() {
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey: "Favorites") as? Data {
            let snippetData = try? decoder.decode(Set<String>.self, from: data)
            self.snippets = snippetData ?? []
        } else {
            self.snippets = []
        }
    }
    
    func getTaskIds() -> Set<String> {
        
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey: "Favorites") as? Data {
            let snippetData = try? decoder.decode(Set<String>.self, from: data)
            self.snippets = snippetData ?? []
        } else {
            self.snippets = []
        }
        
        return self.snippets
        
    }
    
    func isEmpty() -> Bool {
        snippets.count < 1
    }
    
    func contains(_ snippet: Snippet) -> Bool {
        
        let decoder = JSONDecoder()
        if let data = defaults.value(forKey: "Favorites") as? Data {
            let snippetData = try? decoder.decode(Set<String>.self, from: data)
            self.snippets = snippetData ?? []
        } else {
            self.snippets = []
        }
        
        return snippets.contains(snippet.symbol)
        
    }
    
    func add(_ snippet: Snippet) {
        
        print("Adding ticker symbol to Favs")
        print(snippet.symbol)
        
        objectWillChange.send()
        snippets.insert(snippet.symbol)
        save()
        
        print("Ticker added")
    }
    
    func remove(_ snippet: Snippet) {
        
        print("Removing ticker symbol to Favs")
        print(snippet.symbol)
        
        objectWillChange.send()
        snippets.remove(snippet.symbol)
        save()
        
        print("Ticker removed")
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(snippets) {
            defaults.set(encoded, forKey: "Favorites")
        }
    }
}
