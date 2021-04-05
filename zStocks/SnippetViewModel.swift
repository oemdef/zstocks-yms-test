//
//  SnippetViewModel.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 23.02.2021.
//

import Foundation
import SwiftUI
import Combine
import DataCache

open class Snippet: NSObject,  NSCoding, Codable, Identifiable {
    
    open var symbol: String = ""
    open var price: Double = 0
    open var changes: Double = 0
    open var companyName: String = ""
    open var image: String = ""
    open var defaultImage: Bool = true
    
    open var isOdd: Bool = true
    open var id = UUID().uuidString
    open var isFavourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case symbol, price, changes, companyName, image, defaultImage
    }
    
    override init() {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.symbol = aDecoder.decodeObject(forKey: "symbol") as! String
        self.price = aDecoder.decodeDouble(forKey: "price")
        self.changes = aDecoder.decodeDouble(forKey: "changes")
        self.companyName = aDecoder.decodeObject(forKey: "companyName") as! String
        self.image = aDecoder.decodeObject(forKey: "image") as! String
        self.defaultImage = aDecoder.decodeBool(forKey: "defaultImage")
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.symbol, forKey: "symbol")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.changes, forKey: "changes")
        aCoder.encode(self.companyName, forKey: "companyName")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.defaultImage, forKey: "defaultImage")
    }
    
}


/*struct Snippet: Hashable, Codable, Identifiable {
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
 
 }*/

struct TrendingResponse: Hashable, Codable {
    let symbol: String
}

struct SearchResponse: Hashable, Codable {
    let symbol: String
}

class SnippetViewModel: ObservableObject {
    
    //private var apiKey = "9ac38fb881b5427253c99350334ba085"
    private var apiKey = "87039e6143ac8c095864537ccde689c4"
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
    @Published var isLoading = false
    @Published var lastUpdateSuccess = false
    @Published var lastUpdatedString = "6 Apr 2021, 01:25"
    @ObservedObject var favorites = Favorites()
    @ObservedObject var monitor = NetworkMonitor()
    
    private var trendingResponse: [TrendingResponse] = []
    private var searchResponse: [SearchResponse] = []
    private var trendingSymbols: Set<String> = []
    private var searchSymbols: Set<String> = []
    private var editorsPickSymbols: [String] = ["YNDX", "GOOGL", "AAPL", "BAC", "AMZN", "MSFT", "MA", "TSLA"]
    private var useAPI : Bool = false
    
    func getDateString() {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        if self.lastUpdateSuccess == true {
            lastUpdatedString = formatter.string(from: currentDateTime)
        }
    }
    
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
        
        searchResultsSnippets.forEach { snippet in
            
            print("checking")
            print(snippet.symbol)
            
            if !editorsPickSymbols.contains(snippet.symbol) {
                if !trendingSymbols.contains(snippet.symbol) {
                    if favorites.contains(snippet) {
                        favSnippets.append(snippet)
                        print("appended")
                        print(snippet.symbol)
                    }
                }
            }
            
        }
        print(favSnippets)
        
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
            
            self.lastUpdateSuccess = false
            
            let trendingQuery: String = trendingSymbols.joined(separator: ",")
            
            guard let trQueryUrl = URL(string: "https://financialmodelingprep.com/api/v3/profile/\(trendingQuery)?apikey=\(apiKey)") else { return }
            
            print("\(trQueryUrl)")
            
            taskThree = URLSession.shared.dataTaskPublisher(for: URL(string: "https://financialmodelingprep.com/api/v3/profile/\(trendingQuery)?apikey=\(apiKey)")!)
                .map { $0.data }
                .decode(type: [Snippet].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.lastUpdateSuccess = false
                        print(error)
                    case .finished:
                        self.lastUpdateSuccess = true
                        print("Success")
                        self.getDateString()
                    }
                }, receiveValue: { value in
                    self.trendingSnippets = value
                    DataCache.instance.write(array: self.trendingSnippets, forKey: "trendingSnippets")
                })
            
        }
    }
    
    func getSearchResponse(searchQuery: String) {
        
        taskFour = URLSession.shared.dataTaskPublisher(for: URL(string: "https://financialmodelingprep.com/api/v3/search?query=\(searchQuery.replacingOccurrences(of: " ", with: "%20"))&limit=25&apikey=\(apiKey)")!)
            .map { $0.data }
            .decode(type: [SearchResponse].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { value in
                print(value)
                self.searchResponse = value
                self.fetchSearchResults()
            })
        
    }
    
    func fetchSearchResults() {
        
        print(searchResponse.count)
        
        if !searchResponse.isEmpty {
            searchResponse.forEach { response in
                
                searchSymbols.insert(response.symbol)
                
            }
            
            let searchResQuery: String = searchSymbols.joined(separator: ",")
            
            self.isLoading = true
            
            taskFive = URLSession.shared.dataTaskPublisher(for: URL(string: "https://financialmodelingprep.com/api/v3/profile/\(searchResQuery)?apikey=\(apiKey)")!)
                .map { $0.data }
                .decode(type: [Snippet].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    print(value)
                    self.searchResultsSnippets = value
                    self.isLoading = false
                })
            
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
                .sink(receiveValue: { value in
                    print(value)
                    self.trendingResponse = value
                    self.getTrendingSnippets()
                })
            
        } else {
            
            if DataCache.instance.hasDataOnDisk(forKey: "trendingSnippets") {
                trendingSnippets = DataCache.instance.readArray(forKey: "trendingSnippets") as! [Snippet]
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
        
    }
    
    
    func fetchSnippets() {
        
        useAPI = (monitor.isConnected ? true : false)
        
        if useAPI {
            
            self.lastUpdateSuccess = false
            
            let pickQuery = editorsPickSymbols.joined(separator: ",")
            let url = "\(profileUrl)\(pickQuery)?apikey=\(apiKey)"
            
            print(url)
            
            taskOne = URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
                .map { $0.data }
                .decode(type: [Snippet].self, decoder: JSONDecoder())
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    self.snippets = value
                    DataCache.instance.write(array: self.snippets as [Snippet], forKey: "editorsPickSnippets")
                    self.lastUpdateSuccess = true
                    self.getDateString()
                })
            
        } else {
            
            if DataCache.instance.hasDataOnDisk(forKey: "editorsPickSnippets") {
                snippets = DataCache.instance.readArray(forKey: "editorsPickSnippets") as! [Snippet]
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
    
}


