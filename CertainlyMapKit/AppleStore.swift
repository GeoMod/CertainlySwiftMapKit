//
//  AppleStores.swift
//  CertainlyMapKit
//
//  Created by Daniel O'Leary on 9/8/19.
//  Copyright © 2019 Impulse Coupled Dev. All rights reserved.
//

import MapKit
import UIKit

class AppleStore: NSObject,  MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
