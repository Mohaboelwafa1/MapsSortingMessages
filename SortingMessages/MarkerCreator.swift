//
//  MarkerCreator.swift
//  SortingMessages
//
//  Created by mohamed hassan on 5/2/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps


class MarkerCreator {
    
    class func returnMarkerData(coor : CLLocationCoordinate2D , title : String , sentiment : String) -> GMSMarker {
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coor.latitude, longitude: coor.longitude)
        marker.title = title
        marker.snippet = sentiment
        
        if sentiment.contains("Neutral") {
            marker.icon = GMSMarker.markerImage(with: .blue)
        }
        else if sentiment.contains("Negative") {
            
            marker.icon = GMSMarker.markerImage(with: .red)
        }
        else if sentiment.contains("Positive") {
            
            marker.icon = GMSMarker.markerImage(with: .green)
        }
        
        return marker
    }
}
