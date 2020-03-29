//
//  DetailHymnScreen.swift
//  Hymns
//
//  Created by Benjamin Findeisen on 3/28/20.
//  Copyright © 2020 skywalkerdude. All rights reserved.
//

import SwiftUI

struct DetailHymnScreen: View {
    var body: some View {
            VStack {
                GeometryReader { geometry in
                    VStack {
                        HStack {
                            Image(systemName: "xmark")
                            Spacer()
                        Text("Hello")
                            Spacer()
                            Image(systemName: "heart")
                        }                                                .frame(width: geometry.size.width/1.1)

                        
                        
                        HStack {
                            Spacer()
                            Text("Lyrics")
                            Spacer()
                            Text("Chords")
                            Spacer()
                            Text("Guitar")
                            Spacer()
                            Text("Piano")
                            Spacer()
                          }
                        

                        
                        
                    }
                        .aspectRatio(contentMode: .fit)
                                    
                        .background(Color.white.shadow(radius: 2)
                    )
                    Spacer()
                    
                }

                
        }
    }
}

struct DetailHymnScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailHymnScreen()
    }
}
