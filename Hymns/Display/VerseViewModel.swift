//
//  VerseViewModel.swift
//  Hymns
//
//  Created by Samuel Yusuf on 4/18/20.
//  Copyright © 2020 skywalkerdude. All rights reserved.
//

import Foundation

struct VerseViewModel: Hashable {

    var verseNumber: String?
    var verse: Verse
    init(verseNumber: String, verse: Verse) {
        self.verseNumber = verseNumber
        self.verse = verse
    }
    init(verse: Verse) {
        self.verse = verse
    }
}
