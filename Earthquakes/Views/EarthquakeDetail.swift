import SwiftUI

struct EarthquakeDetail: View {
    var earthquake: Earthquake
    
    var body: some View {
        VStack {
            
            // MARK: Magnitude
            Magnitude(earthquake: earthquake)
            
            
            // MARK: Text
            Text(earthquake.place)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(earthquake.time)
                .foregroundStyle(Color.secondary)
            
        }
    }
}

// MARK: Preview
struct EarthquakeDetail_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeDetail(earthquake: earthquakesMock[0])
    }
}
