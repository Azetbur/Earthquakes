import SwiftUI

struct ContentView: View {
    
    // MARK: @State vars
    
    @State var earthquakes : [Earthquake] = []
    @State var selection = Set<Earthquake.ID>()
    @State var updatedAt = Date()
    
    @State var editMode: EditMode = .inactive
    @State var selectMode: SelectMode = .inactive
    
    // MARK: View
    
    var body: some View {
        
        NavigationView {
            List (selection: $selection) {
                ForEach (earthquakes) {earthquake in
    
                    NavigationLink {
                        EarthquakeDetail(earthquake: earthquake)
                    } label: {
                        EarthquakeRow(earthquake: earthquake)
                    }
                    
                }
                
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Earthquakes")
            .toolbar(content: toolbarContent)
            .environment(\.editMode, $editMode)
        }
        .onAppear {
            earthquakes = load()
        }
    }
    
    // MARK: load()
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
                
            var color: Color {
                switch member.properties.mag {
                case 0..<1:
                    return .green
                case 1..<2:
                    return .yellow
                case 2..<3:
                    return .orange
                case 3..<5:
                    return .red
                case 5..<Double.greatestFiniteMagnitude:
                    return .init(red: 0.8, green: 0.2, blue: 0.7)
                default:
                    return .gray
                }
            }
                
            let time = Date(milliseconds: member.properties.time)
                
            let earthquakeTemp = Earthquake(mag: String(format: "%.1f", member.properties.mag),
                                            place: member.properties.place,
                                            timeAgo: time.formatted(.relative(presentation: .named)),
                                            time: time.formatted(),
                                            color: color)
            
            earthquakes.append(earthquakeTemp)
            
            }
        
        return earthquakes
        
    }

}

// MARK: @ToolbarContentBuilder
extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        
        // MARK: SelectButton
        ToolbarItem(placement: .navigationBarLeading) {
            if editMode == .active {
                SelectButton(mode: $selectMode) {
                    if selectMode.isActive {
                        selection = Set(earthquakes.map { $0.id })
                    } else {
                        selection = []
                    }
                }
            }
        }

        // MARK: EditButton
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode) {
                selection.removeAll()
                editMode = .inactive
                selectMode = .inactive
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            
            // MARK: RefreshButton
            Button(action: {
                earthquakes = load()
                updatedAt = Date()
            }) {
                Image(systemName: "arrow.clockwise")
            }.disabled(editMode == .active)

            Spacer()
            
            // MARK: Text
            VStack {
                
                Text("Updated \(updatedAt.formatted(.relative(presentation: .named)))")
                
                Text("\(earthquakes.count) Earthquakes")
                    .foregroundStyle(Color.secondary)
                
            }.font(.caption)
            
            Spacer()

            // MARK: DeleteButton
            if editMode == .active {
                Button(action: {
                    selection.forEach { objectID in
                        earthquakes.removeAll(where: {$0.id == objectID})
                    }
                    selection = []
                    editMode = .inactive
                }) {
                    Image(systemName: "trash")
                }.disabled(selection.isEmpty)
            }
            
            
        }
    }
}

// MARK: Date extension
//Converts the millisecond epoch used in the .geojson to the microsecond epoch used by Swift
extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

// MARK: Preview

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



