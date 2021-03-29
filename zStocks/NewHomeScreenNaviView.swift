//
//  NewHomeScreenNaviView.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 05.03.2021.
//

import SwiftUI

struct NewHomeScreenNaviView: View {
    
    @Binding var isSelected : Int
    
    var body: some View {
        
        HStack(alignment: .firstTextBaseline){
            
            Button(action: {
                self.isSelected = 0
            }, label: {
                Text("Stocks")
                    .font(.custom("Montserrat-Bold", size: (self.isSelected == 0 ? 33 : 22), relativeTo: .title)).foregroundColor(self.isSelected == 0 ? Color("TextColor") : .gray)
            })
            
            Button(action: {
                self.isSelected = 1
            }, label: {
                Text("Favourite")
                    .font(.custom("Montserrat-Bold", size: (self.isSelected == 1 ? 33 : 22), relativeTo: .title)).foregroundColor(self.isSelected == 1 ? Color("TextColor") : .gray).padding(.leading, 10.0).transition(.scale)/*.animation(.spring())*/
            })
            
            Spacer()
            
        }
        .padding(.horizontal)
        .padding(.bottom, 8.0)
        
    }
    
}

struct NewHomeScreenNaviView_Previews: PreviewProvider {
    static var previews: some View {
        NewHomeScreenNaviView(isSelected: .constant(0))
    }
}
