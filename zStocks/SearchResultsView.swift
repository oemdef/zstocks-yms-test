//
//  SearchResultsView.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 29.03.2021.
//

import SwiftUI

struct SearchResultsView: View {
    
    @State var viewState: Int = 0
    @ObservedObject var viewModel = SnippetViewModel()
    @State var compactLimit: Int = 4
    @State var isCompactView: Bool = true
    @Binding var searchQuery : String
    
    var body: some View {
        VStack {
            HStack (alignment: .firstTextBaseline)  {
                Text("Search results for \"\(searchQuery)\"").lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/).font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                
                Spacer()
                
                if viewModel.searchResultsSnippets.count > compactLimit {
                    Button(action: {
                        isCompactView = false
                        UIApplication.shared.endEditing()
                    }, label: {
                        Text(isCompactView ? "Show more" : "").font(.custom("Montserrat-Semibold", size: 14, relativeTo: .title)).foregroundColor(Color("TextColor"))
                    })
                }
            }
            .padding(.horizontal)
            
            ScrollView(
                axes: [.vertical],
                showsIndicators: true
            ) {
                VStack {
                    
                    if !viewModel.searchResultsSnippets.isEmpty {
                        ForEach(viewModel.searchResultsSnippets) { snippet in
                            let index = viewModel.searchResultsSnippets.firstIndex(of: snippet)
                            let isOdd = (index! % 2 == 0)
                            if isCompactView {
                                if index! < compactLimit{
                                    SnippetView(snippet: snippet)
                                        .background(isOdd ? Color("shadedbg") : Color.clear)
                                        .cornerRadius(20)
                                        .padding(.horizontal)
                                        .padding(.vertical, 4.0)
                                }
                            } else {
                                SnippetView(snippet: snippet)
                                    .background(isOdd ? Color("shadedbg") : Color.clear)
                                    .cornerRadius(20)
                                    .padding(.horizontal)
                                    .padding(.vertical, 4.0)
                            }
                            
                        }
                        
                    } else {
                        HStack {
                            if viewModel.isLoading {
                                HStack {
                                    //CustomLoadingIndicator().frame(width: 22, height: 22)
                                    Text("Loading results").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                }
                                
                            } else {
                                HStack{
                                    Image(systemName: "nosign")
                                    Text("No results found").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                }
                            }
                            
                            
                        }
                    }
                    
                }.onAppear {
                    self.viewModel.getFavorites()
                }
                .onDisappear {
                    self.viewModel.getFavorites()
                }
            }
            
            Spacer()
            
        }.onAppear(perform: {
            viewModel.getSearchResponse(searchQuery: searchQuery)
        })
    }
}
