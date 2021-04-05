//
//  SearchBar.swift
//  zStocks
//
//  Created by OemDef | HansaDev on 27.02.2021.
//

import SwiftUI

struct SearchBar: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    //@ObservedObject var viewModel = SnippetViewModel()
    
    @Binding var text : String
    @Binding var isSearching : Bool
    @Binding var isActivelySearching : Bool
    @State private var isEditing = false
    @State private var isEmpty = false
    private let pattern = "^[A-Za-z\\s.-]*$"
    
    var body: some View {
        
        HStack {
            
            ZStack(alignment: .leading) {
                
                if text.isEmpty {
                    if self.isEditing == false {
                        Text("Find company or ticker...")
                            .font(.custom("Montserrat-SemiBold", size: 19))
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal)
                            .padding(.leading, 52.0)
                    }
                }
                
                TextField("", text: $text)
                { isEditing in
                    self.isEditing = isEditing
                    if !text.isEmpty {
                        isEmpty = false
                        isActivelySearching = true
                    } else {
                        isActivelySearching = false
                    }
                } onCommit: {
                    isEmpty = false
                }
                .disableAutocorrection(true)
                .modifier(TextFieldClearButton(text: $text, isEditing: $isEditing, isActivelySearching: $isActivelySearching))
                .accentColor(Color("TextColor"))
            }
            .padding(.vertical)
            .textFieldStyle(YMSDefaultTextFieldStyle(isEditing: $isEditing, isSearching: $isSearching, isActivelySearching: $isActivelySearching, text: $text))
        }
        
        
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Montserrat-SemiBold", size: 19))
            .foregroundColor(Color("TextColor"))
            .padding(20)
            .padding(.leading, 48.0)
            .overlay(
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color("TextColor"), lineWidth: 0.5)
                    HStack{
                        Image("MagnGlass")
                            .renderingMode(.template)
                            .foregroundColor(Color("TextColor"))
                            .scaleEffect(1.1)
                        Spacer()
                    }.padding(20)
                }.padding()
            )
    }
}

struct YMSDefaultTextFieldStyle: TextFieldStyle {
    
    @Binding var isEditing: Bool
    @Binding var isSearching: Bool
    @Binding var isActivelySearching: Bool
    @Binding var text: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Montserrat-SemiBold", size: 19))
            .foregroundColor(Color("TextColor"))
            .padding(20)
            .padding(.horizontal, 48.0)
            .overlay(
                ZStack {
                    
                    if isSearching == false {
                        if isEditing == false {
                            Capsule()
                                .stroke(Color("TextColor"), lineWidth: 1)
                            HStack{
                                Image("MagnGlass")
                                    .renderingMode(.template)
                                    .foregroundColor(Color("TextColor"))
                                    .scaleEffect(1.1)
                                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Spacer()
                            }.padding(20)
                        } else {
                            Capsule()
                                .stroke(Color("TextColor"), lineWidth: 2)
                            HStack{
                                
                                Button(action: {
                                    text = ""
                                    UIApplication.shared.endEditing()
                                    self.presentationMode.wrappedValue.dismiss()
                                    isActivelySearching = false
                                    isSearching = false
                                    isEditing = false
                                }, label: {
                                    Image("BackIcon")
                                        .renderingMode(.template)
                                        .foregroundColor(Color("TextColor"))
                                        .scaleEffect(1.1)
                                        .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                })
                                
                                Spacer()
                                
                                
                            }.padding(20)
                        }
                    } else {
                        Capsule()
                            .stroke(Color("TextColor"), lineWidth: 2)
                        HStack{
                            
                            Button(action: {
                                text = ""
                                UIApplication.shared.endEditing()
                                self.presentationMode.wrappedValue.dismiss()
                                isActivelySearching = false
                                isSearching = false
                                isEditing = false
                            }, label: {
                                Image("BackIcon")
                                    .renderingMode(.template)
                                    .foregroundColor(Color("TextColor"))
                                    .scaleEffect(1.1)
                                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            })
                            
                            Spacer()
                            
                            
                        }.padding(20)
                    }
                    
                    
                    
                }.padding()
            )
    }
}

struct TextFieldClearButton: ViewModifier {
    
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var isActivelySearching: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if self.isEditing {
                if !text.isEmpty {
                    HStack {
                        Spacer()
                        
                        
                        Button(action: {
                            self.text = ""
                            isActivelySearching = false
                        }, label: {
                            Image("CrossIcon")
                                .renderingMode(.template)
                                .foregroundColor(Color("TextColor"))
                                .scaleEffect(1.1)
                        })
                        .transition(.move(edge: .trailing))
                        .animation(.default)
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding(.horizontal)
                        .padding(20)
                        
                    }
                }
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/*struct SearchBar_Previews: PreviewProvider {
 
 @Binding var text: String
 
 static var previews: some View {
 SearchBar(text: $text)
 }
 
 
 }*/
