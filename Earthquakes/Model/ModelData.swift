import Foundation
import SwiftUI

//For preview purposes ONLY
let earthquakesMock = load()

//Used to convert the millisecond epoch used in the .geojson to the microsecond epoch used by Swift
extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

//Holds all earthquake data in a published array
class EarthquakeHolder: ObservableObject {
    
    @Published var earthquakes: [Earthquake] = load()
    
    @Published var selection = Set<Earthquake.ID>()
    
    @Published var updatedAt = Date()
    
    @Published var time = Date()
    
    init () {
        updatedAt = Date()
    }
    
    func refresh () -> () {
        earthquakes = load()
        updatedAt = Date()
    }
    
    func delete() {
        selection.forEach { objectID in
            earthquakes.removeAll(where: {$0.id == objectID})
        }
        
    }
}

//Loads US earthquake data from the web into an array of earthquakes
func load () -> ([Earthquake]) {
    
    let data:Data
    
    do {
       data  = try Data(contentsOf: URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson")!)
    } catch {
        fatalError("Could not download earthquake data. Are you connected to the internet? Is the url correct?\(error)")
    }
    
    var earthquakes: [Earthquake] = []
    
    let earthquakesTemp: EarthquakeLoad
    
    do {
        earthquakesTemp = try JSONDecoder().decode(EarthquakeLoad.self, from: data)
    } catch {
        fatalError("Could not process earthquake data. Is the url correct? Are the key names in EarthquakeLoad correct? Is the data structure in EarthquakeLoad correct?\(error)")
    }

    for member in earthquakesTemp.features {
            
        let color: Color
            
        if (member.properties.mag > 2) {
                color = Color.red
        } else if (member.properties.mag > 1) {
            color = Color.yellow
        } else {
            color = Color.green
        }
            
        let time = Date(milliseconds: member.properties.time)
        
        let updated = Date(milliseconds: member.properties.updated)
            
        let earthquakeTemp = Earthquake(mag: String(format: "%.2f", member.properties.mag),
                                        place: member.properties.place,
                                        timeAgo: time.formatted(.relative(presentation: .named)),
                                        time: time.formatted(),
                                        color: color,
                                        updated: updated.formatted(.relative(presentation: .named)))
        
        earthquakes.append(earthquakeTemp)
        
        }
    
    return earthquakes
    
}
