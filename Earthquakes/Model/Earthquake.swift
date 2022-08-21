import Foundation
import SwiftUI

// MARK: Earthquake
struct Earthquake: Hashable, Identifiable {
    
    var id: String{time} //id
    
    let mag: String // (magnitude, e.g. 2.2)
    
    let place: String // (e.g. 22km ESE of Anza, CA)
   
    let timeAgo: String // (e.g. 1 hour ago)
    
    let time: String // (e.g. 8/18/2022, 1:12 PM)
    
    let color: Color // Color of the font displaying the earthquake magnitude
    
}

// MARK: ONLY for decoding .geojson

struct EarthquakeLoad: Decodable {
    let features: [EarthquakeFeaturesLoad]
}
struct EarthquakeFeaturesLoad: Decodable {
    let properties: EarthquakeFeaturePropertiesLoad
}
struct EarthquakeFeaturePropertiesLoad: Decodable {
    let mag: Double
    let place: String
    let time: Int64
    let updated: Int64
}

