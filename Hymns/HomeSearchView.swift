//
//  HomeSearchView.swift
//  Hymns
//
//  Created by Benjamin Findeisen on 3/27/20.
//  Copyright © 2020 skywalkerdude. All rights reserved.
//

import SwiftUI

struct HomeSearchView: View {
    var hymns = hymnTestData
    @State private var searchText: String = ""

    var body: some View {
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

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView()
    }
}
