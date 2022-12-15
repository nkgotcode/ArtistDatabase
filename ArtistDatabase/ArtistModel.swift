//
//  ArtistModel.swift
//  ArtistDatabase
//
//  Created by itsnk on 10/5/22.
//

import Foundation

class ArtistModel: Identifiable {
    public var timestamp: String = ""
    public var name: String = ""
    public var email: String = ""
    public var passport: String = ""
    public var package: String = ""
    public var paid_status: String = ""
    public var amount: Int = 0
    public var commission: Int = 0
    
}
