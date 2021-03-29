//
//  SnippetViewModel.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 23.02.2021.
//

import Foundation
import SwiftUI
import Combine

struct Snippet: Hashable, Codable, Identifiable {
    //var id: Int
    let symbol: String
    let price: Double
    let changes: Double
    let companyName: String
    let image: String
    let defaultImage: Bool
    
    var isOdd: Bool = true
    let id = UUID().uuidString
    var isFavourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case symbol, price, changes, companyName, image, defaultImage
    }
    
}

struct TrendingResponse: Hashable, Codable {
    let symbol: String
}

struct SearchResponse: Hashable, Codable {
    let symbol: String
}

class SnippetViewModel: ObservableObject {
    
    private var apiKey = "9ac38fb881b5427253c99350334ba085"
    private var profileUrl = "https://financialmodelingprep.com/api/v3/profile/"
    private var taskOne: AnyCancellable?
    private var taskTwo: AnyCancellable?
    private var taskThree: AnyCancellable?
    private var taskFour: AnyCancellable?
    private var taskFive: AnyCancellable?
    
    @Published var snippets: [Snippet] = []
    @Published var favSnippets: [Snippet] = []
    @Published var trendingSnippets: [Snippet] = []
    @Published var searchResultsSnippets: [Snippet] = []
    @ObservedObject var favorites = Favorites()
    @ObservedObject var monitor = NetworkMonitor()
    
    
    private var trendingResponse: [TrendingResponse] = []
    private var searchResponse: [SearchResponse] = []
    private var trendingSymbols: Set<String> = []
    private var searchSymbols: Set<String> = []
    private var editorsPickSymbols: [String] = ["YNDX", "GOOGL", "AAPL", "BAC", "AMZN", "MSFT", "MA", "TSLA"]
    private var useAPI : Bool = false
    
    
    func getFavorites() {
        
        favSnippets.removeAll()
        
        print(favSnippets)
        
        snippets.forEach { snippet in
            
            print("checking")
            print(snippet.symbol)
            
            if favorites.contains(snippet) {
                favSnippets.append(snippet)
                print("appended")
                print(snippet.symbol)
            }
            
        }
        
        trendingSnippets.forEach { snippet in
            
            
            
            print("checking")
            print(snippet.symbol)
            
            if !editorsPickSymbols.contains(snippet.symbol) {
                if favorites.contains(snippet) {
                    favSnippets.append(snippet)
                    print("appended")
                    print(snippet.symbol)
                }
            }
            
        }
        
    }
    
    func getTrendingSnippets() {
        
        print(trendingResponse.count)
        
        if !trendingResponse.isEmpty {
            trendingResponse.forEach { response in
                
                trendingSymbols.insert(response.symbol)
                
                favorites.getTaskIds().forEach { symbol in
                    if !trendingSymbols.contains(symbol) {
                        trendingSymbols.insert(symbol)
                    }
                }
                
            }
            
            let trendingQuery: String = trendingSymbols.joined(separator: ",")
            
            guard let trQueryUrl = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(trendingQuery)?apikey=\(apiKey)") else { return }
            
            print("\(trQueryUrl)")
            
            taskThree = URLSession.shared.dataTaskPublisher(for: URL(string: "https://financialmodelingprep.com/api/v3/profile/\(trendingQuery)?apikey=\(apiKey)")!)
                .map { $0.data }
                .decode(type: [Snippet].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .assign(to: \SnippetViewModel.trendingSnippets, on: self)
            
            
            
        }
    }
    
    func getSearchResponse(searchQuery: String) {
        
        taskFour = URLSession.shared.dataTaskPublisher(for: URL(string: "https://financialmodelingprep.com/api/v3/search?query=\(searchQuery.replacingOccurrences(of: " ", with: "%20"))&limit=10&apikey=\(apiKey)")!)
            .map { $0.data }
            .decode(type: [SearchResponse].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \SnippetViewModel.searchResponse, on: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchSearchResults()
        }
        
    }
    
    func fetchSearchResults() {
        
        print(searchResponse.count)
        
        if !searchResponse.isEmpty {
            searchResponse.forEach { response in
                
                searchSymbols.insert(response.symbol)
                
                /*favorites.getTaskIds().forEach { symbol in
                    if !searchSymbols.contains(symbol) {
                        searchSymbols.insert(symbol)
                    }
                }*/
                
            }
            
            let searchResQuery: String = searchSymbols.joined(separator: ",")
            
    
            taskFive = URLSession.shared.dataTaskPublisher(for: URL(string: "https://financialmodelingprep.com/api/v3/profile/\(searchResQuery)?apikey=\(apiKey)")!)
                .map { $0.data }
                .decode(type: [Snippet].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .assign(to: \SnippetViewModel.searchResultsSnippets, on: self)
            
            
            
        }
    }
    
    
    func fetchTrending() {
        
        useAPI = (monitor.isConnected ? true : false)
        
        if useAPI {
            
            let trendingUrl: String = "https://financialmodelingprep.com/api/v3/stock-screener?limit=50&apikey=\(apiKey)"
            
            
            taskTwo = URLSession.shared.dataTaskPublisher(for: URL(string: trendingUrl)!)
                .map { $0.data }
                .decode(type: [TrendingResponse].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .assign(to: \SnippetViewModel.trendingResponse, on: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.getTrendingSnippets()
            }
            
            
            
            /*URLSession.shared.dataTask(with: trendingUrl) { (data, _, _) in
             
             self.trendingResponse = try! JSONDecoder().decode([TrendingResponse].self, from: data!)
             
             /*DispatchQueue.main.async {
             self.getTrendingQueryUrl()
             }*/
             
             }.resume()*/
            
            
            
            
            /*URLSession.shared.dataTask(with: trQueryUrl) { (data, _, _) in
             self.trendingSnippets = try! JSONDecoder().decode([Snippet].self, from: data!)
             }.resume()*/
            
            
            
            
            
            
        } else {
            
            trendingSnippets = load("trendingSnippetData.json")
            
            func load<T: Decodable>(_ filename: String) -> T {
                let data: Data
                
                guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
                else {
                    fatalError("Couldn't find \(filename) in main bundle.")
                }
                
                do {
                    data = try Data(contentsOf: file)
                } catch {
                    fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: data)
                } catch {
                    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
                }
            }
            
            
        }
        
    }
    
    
    func fetchSnippets() {
        
        useAPI = (monitor.isConnected ? true : false)
        
        if useAPI {
            
            let pickQuery = editorsPickSymbols.joined(separator: ",")
            let url = "\(profileUrl)\(pickQuery)?apikey=\(apiKey)"
            
            taskOne = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
                .map { $0.data }
                .decode(type: [Snippet].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .assign(to: \SnippetViewModel.snippets, on: self)
            
        } else {
            
            snippets = load("snippetData.json")
            
            func load<T: Decodable>(_ filename: String) -> T {
                let data: Data
                
                guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
                else {
                    fatalError("Couldn't find \(filename) in main bundle.")
                }
                
                do {
                    data = try Data(contentsOf: file)
                } catch {
                    fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: data)
                } catch {
                    fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
                }
            }
            
        }
        
    }
    
}




