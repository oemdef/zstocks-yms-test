//
//  CardView.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 05.03.2021.
//

import SwiftUI
import SwiftUICharts

struct CardView: View {
    
    var testGraphData : [Double] = [123.39, 122.54, 120.09, 120.59, 121.21]
    var testGraphDataString : [String] = ["March 22, 21", "March 23, 21", "March 24, 21", "March 25, 21", "March 26, 21"]
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("This is a card view")
                //LineChartView(data: testGraphData, title: "AAPL")
                LineView(data: testGraphData)
                    
                    
                    
                    
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("BackIcon")
                }
                
                //Spacer()
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("AAPL").font(.custom("Montserrat-Bold", size: 22))
                        Text("Apple Inc").font(.custom("Montserrat-Semibold", size: 12))
                    }
                }
                
                //Spacer()
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("StarOutlineIcon")
                }
                
                
                
        }
        }
    }
}

//struct GraphData: Hashable, Codable, Identifiable {
    //var id: Int
    /*let symbol: String
    let price: Double
    let changes: Double
    let companyName: String
    let image: String
    let defaultImage: Bool*/
    
    /*var isOdd: Bool = true
    let id = UUID().uuidString
    var isFavourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case symbol, price, changes, companyName, image, defaultImage
    }*/
    
//}

/*class graphVM : ObservableObject {
    
    @Published var graphData: [GraphData] = []
    
    graphData = load("testGraphData.json")
    
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
    
}*/

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
