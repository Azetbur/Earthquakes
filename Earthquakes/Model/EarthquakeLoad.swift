//These are ONLY used for for decoding the .geojson file in the load function!/////////////////////////////////////////////////////////

import Foundation

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
