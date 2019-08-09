//
//  UserLocation.swift
//  Visits
//
//  Created by Jeffrey Curtis on 3/30/19.
//  Copyright © 2019 Jeffrey Curtis. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import Contacts


struct UserLocation:Codable {
    
   
    
    var LocationCounter:Int?
    var Latitude:Double?
    var Longitude:Double?
    var Street:String?
    var SubLocality:String?
    var City:String?
    var State:String?
    var Postalcode:String?
    var Country:String?
    var CountryCode:String?
    var Altitude:Double?
    var Course:Double?
    var AdministrativeArea:String?
    var Name:String?
    var Info:String?
    var Speed:Double?
    var Time:Date?
    var Address:String?
    var AreasOfInterest:[String]?
    var Ocean:String?
    var InlandWater:String?
    var HorizontalAccuracy:Double?
    var VerticalAccuracy:Double?
    var UID:UUID?
    var ArrivalTime:Date?
    var DepartureTime:Date?
  
    struct AreasOfIntrest: Codable {
        var name: String
    }
  

    
    
    /// used as a helper if a dictioanary is needed of the Structure
    static func getUserLocationDictionary(place:CLPlacemark, andLocation location:CLLocation, andVisit visit:CLVisit? )-> [LocationKeys: Any]{
        
        
        var userLocationDictionary: [LocationKeys: Any]=[:]
        
        userLocationDictionary[LocationKeys.Latitude] = location.coordinate.latitude
        userLocationDictionary[LocationKeys.Longitude] = location.coordinate.longitude
        userLocationDictionary[LocationKeys.Altitude] = location.altitude
        userLocationDictionary[LocationKeys.Course] = location.course
        userLocationDictionary[LocationKeys.City] = place.locality
        userLocationDictionary[LocationKeys.State] = place.administrativeArea
        userLocationDictionary[LocationKeys.Zip] = place.postalCode
        userLocationDictionary[LocationKeys.Name] = place.name
        userLocationDictionary[LocationKeys.Street] = place.thoroughfare
        userLocationDictionary[LocationKeys.Country] = place.country
        userLocationDictionary[LocationKeys.Info]=place.subLocality
        userLocationDictionary[LocationKeys.Speed]=location.speed
        userLocationDictionary[LocationKeys.Time]=location.timestamp
        userLocationDictionary[LocationKeys.Address] = place.postalAddress
        userLocationDictionary[LocationKeys.AreasOfInterest] = place.areasOfInterest
        userLocationDictionary[LocationKeys.Ocean] = place.ocean
        userLocationDictionary[LocationKeys.InlandWater] = place.inlandWater
        userLocationDictionary[LocationKeys.HorizontalAccuracy] = location.horizontalAccuracy
        userLocationDictionary[LocationKeys.VerticalAccuracy] = location.verticalAccuracy
        userLocationDictionary[LocationKeys.Region] = place.region
        userLocationDictionary[LocationKeys.ArrivalTime] = visit?.arrivalDate
        userLocationDictionary[LocationKeys.DepartureTime] = visit?.departureDate
        return userLocationDictionary
        
    
    }
    static func getAddressDict(location:UserLocation) ->[String: Any]{
        
        var userLocationDictionary: [String: Any]=[:]
        
       
       
        userLocationDictionary["postalCode"] = location.Postalcode
        userLocationDictionary["country"] = location.Country
        userLocationDictionary["subLocality"]=location.SubLocality
        userLocationDictionary["city"] = location.City
        userLocationDictionary["street"] = location.Street
        userLocationDictionary["state"] = location.State
        userLocationDictionary["isoCountryCode"] = location.CountryCode
        
        return userLocationDictionary
        
        
    }
    // used to generate
    static func getMapMarker(location: CLLocation, place:CLPlacemark)->MKPlacemark{
        
        let loc = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let placeMark = MKPlacemark(coordinate: loc, postalAddress: place.postalAddress!)
        
        return placeMark
        
    }
    
}

