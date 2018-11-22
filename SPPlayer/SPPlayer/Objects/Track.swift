//
//  Track.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/21/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import Foundation
import ObjectMapper

class Track: Mappable {
    var name: String?
    var uri: String?
    var images: [trackImage]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        uri <- map["uri"]
        images <- map["images"]
    }
}
class trackImage: Mappable {
    var url: String?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
    }
}
