//
//  ContentView.swift
//  Hymns
//
//  Created by Luke Lu on 3/23/20.
//  Copyright © 2020 skywalkerdude. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var hymns = hymnTestData
    @State private var searchText : String = ""
    
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(hymns.filter { self.searchText.isEmpty ? true : $0.contains(self.searchText)}, id: \.self) { hymn in
                                        Text(hymn)
                    }
                }.navigationBarTitle(Text("Look up any hymn"))
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
