//
//  LocationDetail.swift
//  ApiDemo
//
//  Created by Appinventiv on 13/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

class location{
    
    var  name : String
    var address : String
    var rating: NSNumber
    var photoRef: String
    var langitude : Float32
    var longitude : Float32
    
    init(name: String,address: String, rating: NSNumber, photoRef: String, langitude: Float32,longitude: Float32) {
        self.name = name
        self.address = address
        self.rating = rating
        self.photoRef = photoRef
        self.langitude = langitude
        self.longitude = longitude
    }
    
   
}
