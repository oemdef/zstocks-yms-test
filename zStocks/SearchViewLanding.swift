//
//  SearchViewLanding.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 22.02.2021.
//

import SwiftUI

struct SearchViewLanding: View {
    
    @State var popularRequests: [String] = ["Apple", "First Solar", "Amazon", "Alibaba", "Google", "Facebook", "Tesla", "Mastercard", "Microsoft"]
    @State var searchHistory: [String] = ["Apple", "First Solar", "Amazon", "Alibaba", "Google", "Facebook", "Tesla", "Mastercard", "Microsoft", "Placeholder", "HansaDev"]
    
    @Binding var text : String
    
    
    var body: some View {
        
        VStack{
            
            VStack (alignment: .leading) {
                
                HStack {
                    Text("Popular requests").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                    Spacer()
                    
                    
                }
                .padding(.horizontal)
                
                
                ScrollView(
                    axes: [.horizontal],
                    showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                            ForEach(popularRequests, id: \.self) { request in
                                let index = popularRequests.firstIndex(of: request)
                                let isOdd = (index! % 2 == 0)
                                if isOdd {
                                    Text(request)
                                        .font(.custom("Montserrat-SemiBold", size: 14, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                        .padding(15)
                                        .padding(.horizontal, 4)
                                        .background(Capsule().foregroundColor(Color("shadedbg")))
                                        .onTapGesture {
                                            text = request
                                        }
                                    
                                }
                            }
                        }.padding(.leading)
                        
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                            ForEach(popularRequests, id: \.self) { request in
                                let index = popularRequests.firstIndex(of: request)
                                let isOdd = (index! % 2 == 0)
                                if !isOdd {
                                    Text(request)
                                        .font(.custom("Montserrat-SemiBold", size: 14, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                        .padding(15)
                                        .padding(.horizontal, 4)
                                        .background(Capsule().foregroundColor(Color("shadedbg")))
                                        .onTapGesture {
                                            text = request
                                        }
            
                                }
                            }
                        }
                        .padding(.leading)
                        
                        
                    }.padding(.bottom)
                }
                
                if !searchHistory.isEmpty {
                    HStack (alignment: .firstTextBaseline) {
                        Text("You've searched for this").font(.custom("Montserrat-Bold", size: 22, relativeTo: .title)).foregroundColor(Color("TextColor"))
                        Spacer()
                        
                        Button(action: {
                            
                            searchHistory.removeAll()
                            
                        }, label: {
                            Text("Clear").font(.custom("Montserrat-Semibold", size: 14, relativeTo: .title)).foregroundColor(Color("TextColor"))
                        })
                        
                        
                    }
                    .padding(.top, 25)
                    .padding(.horizontal)
                    
                    ScrollView(
                        axes: [.horizontal],
                        showsIndicators: false) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                                ForEach(searchHistory, id: \.self) { shElement in
                                    let index = searchHistory.firstIndex(of: shElement)
                                    let isOdd = (index! % 2 == 0)
                                    if isOdd {
                                        Text(shElement)
                                            .font(.custom("Montserrat-SemiBold", size: 14, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                            .padding(15)
                                            .padding(.horizontal, 4)
                                            .background(Capsule().foregroundColor(Color("shadedbg")))                         }
                                }
                            }.padding(.leading)
                            
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5) {
                                ForEach(searchHistory, id: \.self) { shElement in
                                    let index = searchHistory.firstIndex(of: shElement)
                                    let isOdd = (index! % 2 == 0)
                                    if !isOdd {
                                        Text(shElement)
                                            .font(.custom("Montserrat-SemiBold", size: 14, relativeTo: .title)).foregroundColor(Color("TextColor"))
                                            .padding(15)
                                            .padding(.horizontal, 4)
                                            .background(Capsule().foregroundColor(Color("shadedbg")))                              }
                                }
                            }.padding(.leading)
                            
                        }.padding(.bottom)
                    }
                    
                }
                
                
                
            }
            
        }
        
        Spacer()
        
        
        
        
    }
}
