//
//  SnippetView.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 21.02.2021.
//

import SwiftUI
import URLImage

struct SnippetView: View {
    
    @State private var snippet: Snippet
    private var editorsPickSymbols: [String] = ["YNDX", "GOOGL", "AAPL", "BAC", "AMZN", "MSFT", "MA", "TSLA"]
    private var weirdos: [String] = ["ASML.AS","INTC","NFLX","PYPL"]
    
    init(snippet: Snippet) {
        self.snippet = snippet
    }
    
    @State var name: String = "CONTOSO"
    @State var companyName: String = "Placeholder Inc."
    @State var price: Double = 66.66
    @State var priceDelta: Double = 6.66
    @State var isFavourite: Bool = false
    @State var isSquare: Bool = true
    
    @ObservedObject var favorites = Favorites()
    
    func getDeltaPercent (price a: Double, priceDelta b: Double) -> Double {
        return abs(b/a)*100
    }
    
    func getMoreThan1000 (price a: Double) -> String {
        
    let b = Int(a)
        
        if b % 1000 > 100 {
            return (String(b / 1000) + " " + String(b - (b / 1000 * 1000)))
        } else {
            return (String(b / 1000) + " 0" + String(b - (b / 1000 * 1000)))
        }
    
    }
    
    func getDeltaString(price a : Double, priceDelta b : Double) -> String {
        return ((b > 0 ? "+" : "-") + "$" + (abs(b) < 1000 ? String(format: "%.2f", abs(b)) : getMoreThan1000(price: abs(b))) + " (" + String(format: "%.2f", getDeltaPercent(price: a, priceDelta: b)) + "%)")
    }
    
    //@ObservedObject var viewModel = SnippetViewModel()
    
    var body: some View {
        
        VStack {
            /*HStack {
             Button(action: {
             withAnimation(.spring()){
             //topBarCollapsed.toggle()
             //isOdd.toggle()
             }
             }, label: {
             Image(name).resizable().frame(width: 60, height: 60).cornerRadius(15).padding(.leading, 2.0)
             })
             VStack {
             HStack(alignment: .center) {
             Text(name)
             Button(action: {isFavourite.toggle()}, label: {
             Image("StarIcon").renderingMode(.template).foregroundColor(isFavourite ? .yellow : .gray)
             })
             Spacer()
             Text("$" + String(price))
             }
             .padding(.trailing, 3.0)
             .font(.custom("Montserrat-Bold", size: 22))
             
             HStack {
             Text(companyName)
             Spacer()
             Text(getDeltaString(price: price, priceDelta: priceDelta)).foregroundColor(.green)
             }
             .font(.custom("Montserrat-SemiBold", size: 14))
             .padding(.top, -5.0)
             
             }
             .padding(.horizontal, 8.0)
             .padding(.vertical, 8.0)
             }
             .padding(8.0)
             .background(isOdd ? Color("shadedbg") : Color.clear)
             .cornerRadius(20)
             .padding(.horizontal)
             .padding(.vertical, 4.0)*/
            
            HStack {
                /*Button(action: {
                 withAnimation(.spring()){
                 //topBarCollapsed.toggle()
                 //isOdd.toggle()
                 }
                 }, label: {
                 if editorsPickSymbols.contains(snippet.symbol) {
                 Image(snippet.symbol).resizable().frame(width: 60, height: 60).cornerRadius(15).padding(.leading, 2.0)
                 } else {
                 
                 URLImage(snippet.image)
                 
                 /*RemoteImage(url: snippet.image)
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 60)
                 .background(Color("trendbg")).frame(width: 60, height: 60).cornerRadius(15).padding(.leading, 2.0)*/
                 }
                 })*/
                
                if editorsPickSymbols.contains(snippet.symbol) {
                    Image(snippet.symbol).resizable().frame(width: 60, height: 60).cornerRadius(15).padding(.leading, 2.0)
                } else {
                    
                    
                    
                    VStack {
                        
                        if snippet.defaultImage == false {
                            
                            URLImage(url: URL(string: snippet.image)!,
                                     inProgress: { progress in
                                        VStack {
                                            Text(snippet.symbol.prefix(2))
                                                .font(.custom("Montserrat-Bold", size: 28)).foregroundColor(Color("DarkTextColor"))
                                        }
                                     },
                                     failure: { error, retry in
                                        VStack {
                                            Text(snippet.symbol.prefix(2))
                                                .font(.custom("Montserrat-Bold", size: 28)).foregroundColor(Color("DarkTextColor"))
                                            
                                        }
                                     },
                                     content: { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                     }).frame(width: weirdos.contains(snippet.symbol) ? 45 : 60, height: weirdos.contains(snippet.symbol) ? 45 : 60).frame(width: 60, height: 60).background(Color("trendbg")).cornerRadius(15).padding(.leading, 2.0)
                            
                        } else {
                            Text(snippet.symbol.prefix(2))
                                .font(.custom("Montserrat-Bold", size: 28)).foregroundColor(Color("DarkTextColor"))
                                .frame(width: 60, height: 60).background(Color("trendbg")).cornerRadius(15).padding(.leading, 2.0)
                        }
                        
                    }
                }
                
                VStack {
                    HStack(alignment: .center) {
                        Text(snippet.symbol).lineLimit(1)
                        Button(action: {
                            
                            if self.favorites.contains(snippet) {
                                self.favorites.remove(snippet)
                                self.favorites.save()
                            } else {
                                self.favorites.add(snippet)
                                self.favorites.save()
                            }
                            
                            print(self.favorites.getTaskIds())
                            
                            //isFavourite.toggle()
                            
                        }, label: {
                            Image("StarIcon").renderingMode(.template).foregroundColor(self.favorites.contains(snippet) ? .yellow : .gray)
                        })
                        Spacer()
                        if (snippet.price < 1000) {
                            Text("$" + String(format: "%.2f", snippet.price))
                        } else {
                            Text("$" + getMoreThan1000(price: snippet.price))
                        }
                        
                    }
                    .padding(.trailing, 3.0)
                    .font(.custom("Montserrat-Bold", size: 22))
                    
                    HStack {
                        Text(snippet.companyName).lineLimit(1)
                        Spacer()
                        Text(getDeltaString(price: snippet.price, priceDelta: snippet.changes)).foregroundColor(snippet.changes > 0 ? .green : .red)
                    }
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .padding(.top, -5.0)
                    
                }
                .padding(.horizontal, 8.0)
                .padding(.vertical, 8.0)
            }
            .padding(8.0)
            
        }
    }
}

/*struct SnippetView_Previews: PreviewProvider {
 static var previews: some View {
 SnippetView(snippet: snippet, isOdd: true)
 }
 }*/
