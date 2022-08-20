//
//  Magnitude.swift
//  Earthquakes
//
//  Created by Jindrich Kocman on 10.08.2022.
//

import SwiftUI

struct Magnitude: View {
    var earthquake: Earthquake
    
    var body: some View {
        Text(earthquake.mag)
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .background(Color.black)
            .cornerRadius(10)
            .foregroundColor(earthquake.color)
    }
}

struct Magnitude_Previews: PreviewProvider {
    static var previews: some View {
        Magnitude(earthquake: earthquakesMock[0])
    }
}
