//
//  FilterObservableObject.swift
//  ArtistDatabase
//
//  Created by itsnk on 11/14/22.
//

import Foundation
class FilterObservableObject : ObservableObject {
    @Published var artists: [ArtistModel] = []
    @Published var searchResults: [ArtistModel] = []
    
    init() {
        artists = DBManager().getArtists()
    }
}

