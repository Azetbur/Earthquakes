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
        RoundedRectangle(cornerRadius: 8)
            .fill(.black)
            .frame(width: 80, height: 60)
            .overlay {
                Text(earthquake.mag)
                    .font(.title)
                    .bold()
                    .foregroundStyle(earthquake.color)
            }
    }
}

// MARK: Preview
struct Magnitude_Previews: PreviewProvider {
    static var previews: some View {
        Magnitude(earthquake: earthquakesMock[0])
    }
}
