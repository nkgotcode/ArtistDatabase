//
//  DBManager.swift
//  ArtistDatabase
//
//  Created by itsnk on 10/5/22.
//

import Foundation
import SQLite

class DBManager {
    private var db: Connection!
    private var artists: Table!
    private var id: Expression<Int64> = Expression<Int64>("id")
    private var name: Expression<String> = Expression<String>("name")
    private var email: Expression<String> = Expression<String>("email")
    private var timestamp: Expression<String> = Expression<String>("timestamp")
    private var passport: Expression<String> = Expression<String>("passport")
    private var package: Expression<String> = Expression<String>("package")
    private var paid_status: Expression<String?> = Expression<String?>("paid_status")
    private var amount: Expression<Int64?> = Expression<Int64?>("amount")
    private var commission: Expression<Int64?> = Expression<Int64?>("commission")
    
    init() {
        var artistModels: [ArtistModel] = []
    }
    
    public func addArtist(artist: ArtistModel) {
        do {
            let url = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("artists.sqlite")
            let db = try Connection(url.path)
            let artists = Table("summer_jam")
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
            let dateString = formatter.string(from: now)
            
            let insert = artists.insert(timestamp <- dateString, name <- artist.name, email <- artist.email, passport <- artist.passport, package <- artist.package)
            try db.run(insert)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteArtist(artist: ArtistModel) {
        do {
            let url = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("artists.sqlite")
            let db = try Connection(url.path)
            let artists = Table("summer_jam")
            
            let toBeDeleted = artists.filter(name == artist.name && passport == artist.passport && email == artist.email)
            try db.run(toBeDeleted.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func editArtist(chosenArtist: ArtistModel, inputName: String, inputEmail: String, inputPassport: String, inputPackage: String) {
        do {
            let url = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("artists.sqlite")
            let db = try Connection(url.path)
            let artists = Table("summer_jam")
            
            let toBeEdited = artists.filter(name == chosenArtist.name && passport == chosenArtist.passport && email == chosenArtist.email)
            try db.run(toBeEdited.update(name <- name.replace(chosenArtist.name, with: inputName), email <- email.replace(chosenArtist.email, with: inputEmail), passport <- passport.replace(chosenArtist.passport, with: inputPassport), package <- package.replace(chosenArtist.package, with: inputPackage)))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getArtists() -> [ArtistModel] {
        var artistModels: [ArtistModel] = []
        
//        artists = artists.order(id.desc)
        
        do {
            let url = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("artists.sqlite")
            let db = try Connection(url.path)
            let artists = Table("summer_jam")
            for artist in try db.prepare(artists) {
                let artistModel: ArtistModel = ArtistModel()
                
//                artistModel.id = artist[id]
                artistModel.name = artist[name]
                artistModel.email = artist[email]
                artistModel.timestamp =  artist[timestamp]
                artistModel.passport = artist[passport]
                artistModel.package = artist[package]
                artistModel.paid_status = artist[paid_status] ?? ""
                artistModel.amount = Int(artist[amount] ?? 0)
                artistModel.commission = Int(artist[commission] ?? 0)
                
                artistModels.append(artistModel)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return artistModels
    }

}
