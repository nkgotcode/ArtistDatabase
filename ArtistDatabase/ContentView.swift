//
//  ContentView.swift
//  ArtistDatabase
//
//  Created by itsnk on 10/5/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var oo = FilterObservableObject()
    @State var artistModels: [ArtistModel] = []
    @State var searchQuery = ""
    @State var filteredArtists = ArtistModel().name
    @State var isPopover = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
                NavigationView{
                    List(searchQuery.isEmpty ? oo.artists : oo.searchResults) { (model) in
                        NavigationLink(destination: ProfileView(artist: model, oo: self.oo), label: {
                                Text(model.name)
                            })
                    }
                    .background(Color.init(NSColor.controlBackgroundColor))
                    .animation(.default, value: searchQuery)
                    .searchable(text: $searchQuery, placement: .automatic)
                    .onChange(of: searchQuery, perform: { newQuery in
                        oo.searchResults = artistModels.filter({ artist in
                            artist.name.lowercased().contains(newQuery.lowercased())
                        })
                })
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Button(action: { self.isPopover.toggle() }) {
                                Text("Add Artist")
                            }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                AddArtistPopoverView(isPopover: self.$isPopover, artist: ArtistModel(), oo: self.oo)
                            }
                        }
                    }
                }
                .background(Color.init(NSColor.controlBackgroundColor))
                .padding()
                .onAppear(perform: {
                    self.artistModels = DBManager().getArtists()
                })
        }
        .background(Color.init(NSColor.controlBackgroundColor))
    }
}

struct AddArtistPopoverView: View {
    @Binding var isPopover: Bool
    @State var artist: ArtistModel
    @ObservedObject var oo: FilterObservableObject
    var body: some View {
        VStack{
            Form {
                TextField(text: $artist.name) {
                    Text("Name")
                }
                TextField(text: $artist.email) {
                    Text("Email")
                }
                TextField(text: $artist.passport) {
                    Text("Passport No.")
                }
                TextField(text: $artist.package) {
                    Text("Package")
                }
            }
            HStack {
                Button("Save") {
                    self.isPopover.toggle()
                    DBManager().addArtist(artist: self.artist)
                    oo.artists = DBManager().getArtists()
                }.foregroundColor(Color.green)
                Spacer()
                Button("Cancel") {
                    self.isPopover.toggle()
                }.foregroundColor(Color.red)
            }
        }.padding()
            .frame(width: 380, height: 360)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(PreviewDevice(rawValue: "Mac"))
    }
}
