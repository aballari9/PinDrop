//
//  Pin.swift
//  Pin Drop
//
//  Created by Akhila Ballari on 10/24/17.
//  Copyright © 2017 Akhila Ballari. All rights reserved.
//

import UIKit
import MapKit

class Pin: NSObject, MKAnnotation, Codable {
    var name: String
    var fact: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, fact: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.fact = fact
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    //MKAnnotation
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    public var title: String? {
        return self.name
    }
    
    public var subtitle: String? {
        return self.fact
    }

}
