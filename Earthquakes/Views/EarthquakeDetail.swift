//
//  EarthquakeDetail.swift
//  Earthquakes
//
//  Created by Jindrich Kocman on 10.08.2022.
//

import SwiftUI

struct EarthquakeDetail: View {
    var earthquake: Earthquake
    
    var body: some View {
        VStack {
            
            Magnitude(earthquake: earthquake)
            
            Text(earthquake.place)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(earthquake.time)
                .foregroundColor(Color.gray)
            
        }
    }
}

struct EarthquakeDetail_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeDetail(earthquake: earthquakesMock[0])
    }
}
