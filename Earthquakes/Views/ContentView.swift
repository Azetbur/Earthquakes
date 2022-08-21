import SwiftUI

// MARK: View

struct ContentView: View {
    
    // MARK: State
    
    @State var earthquakes : [Earthquake] = []
    @State var selection = Set<Earthquake.ID>()
    @State var updatedAt = Date()
    
    @State var editMode: EditMode = .inactive
    @State var selectMode: SelectMode = .inactive
    
    // MARK: Content
    
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
            .navigationTitle("Earthquakes")
            .toolbar(content: toolbarContent)
            .environment(\.editMode, $editMode)
        }
        .onAppear {
            earthquakes = load()
        }
    }
    
    // MARK: Actions
    
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
                
            let earthquakeTemp = Earthquake(mag: String(format: "%.2f", member.properties.mag),
                                            place: member.properties.place,
                                            timeAgo: time.formatted(.relative(presentation: .named)),
                                            time: time.formatted(),
                                            color: color)
            
            earthquakes.append(earthquakeTemp)
            
            }
        
        return earthquakes
        
    }

}

// MARK: Extensions

//Builds the toolbar
extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        
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

        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode) {
                selection.removeAll()
                editMode = .inactive
                selectMode = .inactive
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            
            Button(action: {
                earthquakes = load()
                updatedAt = Date()
            }) {
                Image(systemName: "arrow.clockwise")
            }.disabled(editMode == .active)

            Spacer()
            
            VStack {
                
                Text("Updated \(updatedAt.formatted(.relative(presentation: .named)))")
                
                Text("\(earthquakes.count) Earthquakes")
                    .foregroundStyle(Color.secondary)
                
            }
            
            Spacer()

            if editMode == .active {
                Button(action: {
                    selection.forEach { objectID in
                        earthquakes.removeAll(where: {$0.id == objectID})
                    }
                    editMode = .inactive
                }) {
                    Image(systemName: "trash")
                }.disabled(selection.isEmpty)
            }
            
            
        }
    }
}

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



