//
//  ViewController.swift
//  SortingMessages
//
//  Created by mohamed hassan on 5/2/17.
//  Copyright © 2017 mohamed hassan. All rights reserved.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces



class MapView: UIViewController {
    
    var entryArray   :  NSArray!
    var stringsArray : [String]       = [String]()
    var Data         : [NSDictionary] = [NSDictionary]()
    var CitiesMarkers : [GMSMarker] = [GMSMarker]()
    
    
    
    
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?address="
    var lat : Double!
    var lng : Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchData()
        
      
        
        
    }
    
    
    func fetchData() {
        // Fetch data
        Alamofire.request("https://spreadsheets.google.com/feeds/list/0Ai2EnLApq68edEVRNU0xdW9QX1BqQXhHRl9sWDNfQXc/od6/public/basic?alt=json").responseJSON { response in
            if let json = response.result.value {
                
                let data = json as! NSDictionary
                let feed = data["feed"] as! NSDictionary
                let entry = feed["entry"] as! NSArray
                self.entryArray = entry
                
                // Parse the array
                for index in 0...self.entryArray.count-1 {
                    let row = self.entryArray[index] as! NSDictionary
                    let tt = row["content"] as! NSDictionary
                    let str = tt["$t"]
                    self.stringsArray.append(str as! String)
                    
                }
                
                // Read array of strings
                
                for index in 0...self.stringsArray.count-1 {
                    
                    let str = self.stringsArray[index]
                    var newStr = str.components(separatedBy: ",")
                    
                    if (newStr.count == 4){
                        newStr[1] = newStr[1]+newStr[2]
                        newStr.remove(at: 2)
                    }
                        
                        
                    else if (newStr.count == 5){
                        newStr[1] = newStr[1]+newStr[2]+newStr[3]
                        newStr.remove(at: 3)
                        newStr.remove(at: 2)
                    }
                    else {
                        
                    }
                    
                    let indexForID = newStr[0].index(newStr[0].startIndex, offsetBy: 11)
                    let messageid = newStr[0].substring(from: indexForID)
                    
                    //print(messageid)
                    
                    let indexForMessage = newStr[1].index(newStr[1].startIndex, offsetBy: 9)
                    let message = newStr[1].substring(from: indexForMessage)
                    //print(message)
                    
                    
                    
                    let indexForSentiment = newStr[2].index(newStr[2].startIndex, offsetBy: 11)
                    let sentiment = newStr[2].substring(from: indexForSentiment)
                    //print(sentiment)
                    
                    
                    let dataDictionary: [String:String] = [
                        "messageid" : messageid , "message" : message ,"sentiment" : sentiment
                    ]
                    
                    self.Data.append(dataDictionary as NSDictionary)
                    
                    
                    
                }
                
                print(self.Data[0])
                print(self.Data[0]["message"])
                
                // Add markers here
                self.AddMarkersToMap()
            }
            
            
            
            
            
            
        }
        
    }
    
    func AddMarkersToMap() {
        
        
        for index in 0...Cities.CitiesArray.count-1 {

            self.getCityCoordinates(cityName: Cities.CitiesArray[index] , index : index)
        
        }
        
    }
    
    
   
    func getCityCoordinates(cityName: String , index : Int) {
        
        // Fetch data
        let url = baseURLGeocode + cityName
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 3.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
    
                let cityData = json as! NSDictionary
                let results = cityData["results"] as! NSArray
                print(results[0])
                
                let data = results[0] as! NSDictionary
                let geometry = data["geometry"] as! NSDictionary
                
                let location = geometry["location"] as! NSDictionary
                print("oooooo\(location["lat"])")
                print("oooooo\(location["lng"])")
                
                self.lat = location["lat"] as! Double
                self.lng = location["lng"] as! Double
                
                // Creates a marker in the center of the map.
                let coor = CLLocationCoordinate2D(latitude: location["lat"] as! Double, longitude: location["lng"] as! Double)
                
                self.CitiesMarkers.append(MarkerCreator.returnMarkerData(coor: coor, title: self.Data[index]["message"] as! String, sentiment: self.Data[index]["sentiment"] as! String))

                
            }
        
            //
            for index in 0...self.CitiesMarkers.count-1 {
                
                self.CitiesMarkers[index].map = mapView
                
            }
        }
        
    }
    
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}


