//
//  zStocksApp.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 20.02.2021.
//

import SwiftUI

@main
struct zStocksApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            //TestNaviView()
            NewStocksHomeView()
            
            //ContentView()
            //    .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
