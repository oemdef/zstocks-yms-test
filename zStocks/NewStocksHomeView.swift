//
//  NewStocksHomeView.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 05.03.2021.
//

import SwiftUI
import SwiftUIX
//import URLImage

struct NewStocksHomeView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject var viewModel = SnippetViewModel()
    @ObservedObject var trendingViewModel = SnippetViewModel()
    @ObservedObject var monitor = NetworkMonitor()
    
    @ObservedObject var favorites = Favorites()
    
    @State var isSelected = 0
    @State var isSearching = false
    @State var isActivelySearching = false
    
    @State var lastUpdatedString = "never"
    
    @State var text: String = ""
    
    @State var scrollViewOffset : CGFloat = 160
    
    func getDateString() {
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        lastUpdatedString = formatter.string(from: currentDateTime)
    }
    
    
   
    
    
    func getVStackOffset (scrollViewOffset a: CGFloat) -> CGFloat {
        
        if a >= 0 {
            return 160
        } else if a >= -160 * 160/93 && a < 0 {
            return 160 + a * 93/160 //* (160/93)
        }  else  {
            return 0
        }
        
    }
    
    func getDataOnLaunch() {
        viewModel.fetchSnippets()
        viewModel.fetchTrending()
        getDateString()
    }
    
    
    var body: some View {
        
        ZStack {
            
            if self.isSelected == 0 {
                
                VStack {
                    ScrollView(
                        axes: [.vertical],
                        showsIndicators: true,
                        offsetChanged: {
                            //print($0.y)
                            scrollViewOffset = $0.y
                        }
                    ) {
                        
                        VStack {
                            HStack (alignment: .firstTextBaseline)  {
                                Text("Editors' pick").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                
                                Spacer()
                                
                                //Text("Last updated: 20:09 04.04").font(.custom("Montserrat-Semibold", size: 10, relativeTo: .title)).foregroundColor(Color("TextColor"))
                            }
                            .padding(.horizontal)
                            
                            VStack {
                                
                                ForEach(viewModel.snippets) { snippet in
                                    let index = viewModel.snippets.firstIndex(of: snippet)
                                    let isOdd = (index! % 2 == 0)
                                    SnippetView(snippet: snippet)
                                        .background(isOdd ? Color("shadedbg") : Color.clear)
                                        .cornerRadius(20)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4.0)
                                }
                                
                                /*HStack {
                                 Text("Added by you").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                 
                                 Spacer()
                                 }
                                 .padding()*/
                                
                                HStack {
                                    Text("Trending").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                    
                                    Spacer()
                                }
                                .padding([.top, .leading])
                                
                                LazyVStack {
                                    ForEach(viewModel.trendingSnippets) { snippet in
                                        let index = viewModel.trendingSnippets.firstIndex(of: snippet)
                                        let isOdd = (index! % 2 == 0)
                                        SnippetView(snippet: snippet)
                                            .background(isOdd ? Color("shadedbg") : Color.clear)
                                            .cornerRadius(20)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4.0)
                                    }
                                }
                                
                                
                                /*HStack {
                                 Text("Placeholder").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                 
                                 Spacer()
                                 }
                                 .padding()
                                 .padding(.vertical, 200)*/
                                
                            }
                        }
                        //.padding(.top, getVStackOffset(scrollViewOffset: scrollViewOffset))
                        .offset(y: getVStackOffset(scrollViewOffset: scrollViewOffset))
                        .onAppear(perform: getDataOnLaunch)
                        
                        
                    }
                    
                    
                    HStack {
                        Image(systemName: monitor.isConnected ? "wifi" : "wifi.slash")
                        VStack (alignment: .leading) {
                            Text(monitor.isConnected ? "Connection established" : "No connection").font(.custom("Montserrat-Bold", size: 16, relativeTo: .title)).foregroundColor(Color("TextColor"))
                            Text("Last updated: \(lastUpdatedString)").font(.custom("Montserrat-Semibold", size: 12, relativeTo: .title)).foregroundColor(Color("TextColor"))
                        }
                        Spacer()
                        Button(action: {
                            getDataOnLaunch()
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                
                    }.padding(.horizontal)
                    
                }
                //.edgesIgnoringSafeArea(.top)
                //.padding(.top, scrollViewOffset > 0 ? 160 : scrollViewOffset <= -93 ? 67: 160 + scrollViewOffset)
                //.padding(.top, scrollViewOffset > 0 ? 160 : scrollViewOffset <= -160 * (-160 / -93) ? 0 : 160 + scrollViewOffset * (-160 / -93))
                //.padding(.top, scrollViewOffset > 0 ? 160 : scrollViewOffset <= -160 ? 0 : 160 + scrollViewOffset)
                
                //.offset(y: scrollViewOffset > 0 ? 160 : scrollViewOffset <= -93 ? 67: 160 + scrollViewOffset)
                //.offset(y: scrollViewOffset > 0 ? 160 : scrollViewOffset <= -160 ? 0 : 160 + scrollViewOffset)
            } else {
                
                VStack {
                    ScrollView(
                        axes: [.vertical],
                        showsIndicators: true,
                        offsetChanged: {
                            print($0.y)
                            scrollViewOffset = $0.y
                        }
                    ) {
                        LazyVStack {
                            
                            /*Button(action: {resetDefaults()}, label: {
                             Text("Reset UserDefaults")
                             })*/
                            
                            if viewModel.favSnippets.isEmpty {
                                VStack {
                                    HStack {
                                        //Image(systemName: "nosign").font(Font.system(size: 22, weight: .heavy))
                                        Text("You have no favourite tickers").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                        
                                        
                                    }
                                    
                                    
                                    
                                    HStack {
                                        Text("Add a ticker to favourites by clicking the ").font(.custom("Montserrat-Semibold", size: 12, relativeTo: .caption)).foregroundColor(Color("TextColor"))
                                        Image("StarIcon").renderingMode(.template).foregroundColor(.gray).frame(width: 10, height: 10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        Text(" button").font(.custom("Montserrat-Semibold", size: 12, relativeTo: .caption)).foregroundColor(Color("TextColor"))
                                        
                                        
                                    }.padding(.top, -4)
                                    
                                    Spacer()
                                    
                                }.padding(.horizontal)
                                
                            } else {
                                
                                ForEach(viewModel.favSnippets) { snippet in
                                    let index = viewModel.favSnippets.firstIndex(of: snippet)
                                    let isOdd = (index! % 2 == 0)
                                    SnippetView(snippet: snippet)
                                        .background(isOdd ? Color("shadedbg") : Color.clear)
                                        .cornerRadius(20)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4.0)
                                }
                                
                                
                                
                            }
                        }
                        .onAppear {
                            self.viewModel.getFavorites()
                        }
                    }
                    .padding(.top, 160/*scrollViewOffset > 0 ? 160 : scrollViewOffset <= -93 ? 67: 160 + scrollViewOffset*/)
                    
                    HStack {
                        Image(systemName: monitor.isConnected ? "wifi" : "wifi.slash")
                        VStack (alignment: .leading) {
                            Text(monitor.isConnected ? "Connection established" : "No connection").font(.custom("Montserrat-Bold", size: 16, relativeTo: .title)).foregroundColor(Color("TextColor"))
                            Text("Last updated: \(lastUpdatedString)").font(.custom("Montserrat-Semibold", size: 12, relativeTo: .title)).foregroundColor(Color("TextColor"))
                        }
                        Spacer()
                        Button(action: {
                            getDataOnLaunch()
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                
                    }.padding(.horizontal)
                    
                }
                
            }
            
            
            VStack {
                
                VStack {
                    SearchBar(text: $text, isSearching: $isSearching, isActivelySearching: $isActivelySearching).opacity(isSelected == 1 ? 1 : scrollViewOffset >= 0 ? 1 : 1 - Double(scrollViewOffset / -100))
                        .onTapGesture(perform: {
                            if scrollViewOffset >= 0 {
                                isSearching = true
                            }
                        })
                    if isSearching {
                        if isActivelySearching {
                            SearchResultsView(searchQuery: $text)
                        } else {
                            SearchViewLanding(text: $text)
                        }
                    } else {
                        NewHomeScreenNaviView(isSelected: $isSelected)
                    }
                }
                .padding(.bottom, 7)
                .background(Color("bg").opacity(scrollViewOffset >= 0 ? 1 : scrollViewOffset <= -30 ? 0 : Double(1 + scrollViewOffset * 1/30)).ignoresSafeArea())
                .background(VisualEffectBlurView(blurStyle: .systemThinMaterial).shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(scrollViewOffset >= 0 ? 0 : scrollViewOffset <= -30 ? 0.2 : Double(scrollViewOffset * -0.2/30)), radius: 2, x: 0, y: 2).ignoresSafeArea())
                
                
                
                
                Spacer()
                
                
                
                
                
            }
            .edgesIgnoringSafeArea([.bottom])
            //.background(isSearching ? (VisualEffectBlurView(blurStyle: .systemThinMaterial)) : Color(.clear)).ignoresSafeArea()
            .offset(y: isSelected == 1 ? 0 : scrollViewOffset > 0 ? 0 : scrollViewOffset >= -160 ? 0 + scrollViewOffset * 93/160 : -93)
            //.offset(y: isSelected == 1 ? 0 : scrollViewOffset > 0 ? 0 : scrollViewOffset >= -93 ? 0 + scrollViewOffset : -93)
            //.offset(y: isSelected == 1 ? 0 : scrollViewOffset > 0 ? 0 : scrollViewOffset >= -55 ? 0 + scrollViewOffset * 160/93 : -93)
            
        }
    }
    //.onAppear(perform: getDataOnLaunch)
    
}


/*struct NewStocksHomeView_Previews: PreviewProvider {
 static var previews: some View {
 NewStocksHomeView(text: .constant("Sample Text"))
 }
 }*/
