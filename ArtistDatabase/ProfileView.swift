//
//  ProfileView.swift
//  ArtistDatabase
//
//  Created by itsnk on 10/10/22.
//

import SwiftUI

struct ProfileView: View {
    @State var artist: ArtistModel
    @State var artistSelected: Bool = true
    @State var isPopover = false
    @ObservedObject var oo: FilterObservableObject
    var body: some View {
        VStack {
            AsyncImage(url:URL(string: "https://picsum.photos/1920/1080")){ image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    
            } placeholder: {
                Color.gray
            }.frame(width: 600, height: 300)
            
            HStack{
                Button(action: { self.isPopover.toggle() }) {
                                Text("Edit")
                            }.popover(isPresented: self.$isPopover, arrowEdge: .bottom) {
                                PopoverView(isPopover: self.$isPopover, artist: self.artist, oo: self.oo)
                            }
                
                Spacer()
                Text(artist.name).textCase(.uppercase).font(.system(size: 20))
                Spacer()
                Text(artist.package)
            }.padding(16)
            HStack {
                Text("email: \(artist.email)")
                Text("passport: \(artist.passport)")
            }
            Spacer()
        }
    }
}

struct PopoverView: View {
    @Binding var isPopover: Bool
    @State var artist: ArtistModel
    @State private var showingAlert = false
    @ObservedObject var oo: FilterObservableObject
    @State var inputName: String = ""
    @State var inputEmail: String = ""
    @State var inputPassport: String = ""
    @State var inputPackage: String = ""
    var body: some View {
        VStack{
            Form {
                TextField(text: $inputName) {
                    Text("Name")
                }
                TextField(text: $inputEmail) {
                    Text("Email")
                }
                TextField(text: $inputPassport) {
                    Text("Passport No.")
                }
                TextField(text: $inputPackage) {
                    Text("Package")
                }
            }
            HStack {
                Button("Cancel") {
                    self.isPopover.toggle()
                }
                Button("Save") {
                    self.isPopover.toggle()
                    DBManager().editArtist(chosenArtist: self.artist, inputName: inputName, inputEmail: inputEmail, inputPassport: inputPassport, inputPackage: inputPackage)
                    oo.artists = DBManager().getArtists()
                }.foregroundColor(Color.green)
                Button("Delete") {
                    self.isPopover.toggle()
                    showingAlert.toggle()
                }.foregroundColor(Color.red)
                    .alert("Do you want to delete this artist from the database?", isPresented: $showingAlert) {
                        Button("No", role: .cancel) { }
                        Button("Yes", role: .none) {
                            DBManager().deleteArtist(artist: self.artist)
                            oo.artists = DBManager().getArtists()
                        }
                    }
            }
        }.padding()
            .onAppear(perform:  {
                inputName = artist.name
                inputEmail = artist.email
                inputPassport = artist.passport
                inputPackage = artist.package
            })
    }
}
