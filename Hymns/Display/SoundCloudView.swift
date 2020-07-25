//
//  SoundCloudView.swift
//  Hymns
//
//  Created by Benjamin Findeisen on 7/25/20.
//  Copyright © 2020 skywalkerdude. All rights reserved.
//

import SwiftUI

struct SoundCloudView: View {
    @State var isLoading = true
    @Binding var showSoundCloud: Bool
    var searchTitle: String

    var body: some View {
        Group<AnyView> {
            guard let url = URL(string:
                "https://soundcloud.com/search?q=\(self.searchTitle)") else {
                    return ErrorView().eraseToAnyView()
            }
            return VStack {
                HStack(spacing: 20) {
//                    Button(action: {
//                        self.showSoundCloud = false
//                     //   self.clickedOnce = false
//                    }, label: {
//                        Image(systemName: "x.circle").accentColor(.primary)
//                    })
                    Button(action: {
                        self.showSoundCloud.toggle()
                    }, label: {
                        Image(systemName: "minus.circle").accentColor(.primary)
                    })
                    Spacer()
                }.padding()
                ZStack {
                    SoundCloudWebView(isLoading: self.$isLoading, url: url).eraseToAnyView().opacity(isLoading ? 0 : 1)
                    ActivityIndicator().maxSize().eraseToAnyView().opacity(isLoading ? 1 : 0)
                }
            }
            .eraseToAnyView()
        }
    }
}
/*
struct SoundCloudView_Previews: PreviewProvider {
    static var previews: some View {
        SoundCloudView()
    }
}
*/
