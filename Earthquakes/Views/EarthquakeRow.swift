import SwiftUI


struct EarthquakeRow: View {
    var earthquake: Earthquake
    
    var body: some View {
        HStack {
            
            // MARK: Magnitutde
            Magnitude(earthquake: earthquake)
            
            
            // MARK: Text
            VStack(alignment: .leading) {
                
                Text(earthquake.place)
                    .font(.title3)
                
                Text(earthquake.timeAgo)
                    .foregroundStyle(Color.secondary)
                
            }
        }.padding(.vertical, 8)
    }
}

// MARK: Preview
struct EarthquakeRow_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeRow(earthquake: earthquakesMock[0])
    }
}
