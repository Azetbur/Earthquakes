import SwiftUI


struct EarthquakeRow: View {
    var earthquake: Earthquake
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Magnitude(earthquake: earthquake)
            
            VStack {
                
                HStack {
                    Text(earthquake.place)
                        .font(.title3)
                    Spacer()
                }
                
                HStack {
                    Text(earthquake.timeAgo)
                        .foregroundColor(Color.gray)
                    Spacer()
                    
                }
                
            }
        }
    }
}

struct EarthquakeRow_Previews: PreviewProvider {
    static var previews: some View {
        EarthquakeRow(earthquake: earthquakesMock[0])
    }
}
