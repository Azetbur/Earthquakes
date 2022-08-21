import Foundation
import SwiftUI

// MARK: Used in previews only

var earthquakesMock = mockLoad()

func mockLoad () -> ([Earthquake]) {
    
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
            
        let earthquakeTemp = Earthquake(mag: String(format: "%.2f", member.properties.mag),
                                        place: member.properties.place,
                                        timeAgo: time.formatted(.relative(presentation: .named)),
                                        time: time.formatted(),
                                        color: color)
        
        earthquakes.append(earthquakeTemp)
        
    }
    
    return earthquakes
    
}

