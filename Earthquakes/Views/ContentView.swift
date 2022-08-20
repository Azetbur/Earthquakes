import SwiftUI

struct ContentView: View {
    
    @StateObject var holder = EarthquakeHolder()
    
    @State private var editMode: EditMode = .inactive
    
    @State private var selectMode: SelectMode = .inactive
    
    var body: some View {
        NavigationView {
            List (selection: $holder.selection) {
                ForEach (holder.earthquakes, id: \.id) {earthquake in
    
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
    }
    
}

extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        
        ToolbarItem(placement: .navigationBarLeading) {
            if editMode == .active {
                SelectButton(mode: $selectMode) {
                    if selectMode.isActive {
                        holder.selection = Set(holder.earthquakes.map { $0.id })
                    } else {
                        holder.selection = []
                    }
                }
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode) {
                holder.selection.removeAll()
                editMode = .inactive
                selectMode = .inactive
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            
            Button(action: {
                holder.refresh()
            }) {
                Image(systemName: "arrow.clockwise")
            }.disabled(editMode == .active)

            Spacer()
            
            VStack {
                
                Text("Updated \(holder.updatedAt.formatted(.relative(presentation: .named)))")
                
                Text("\(holder.earthquakes.count) Earthquakes")
                    .foregroundStyle(Color.secondary)
                
            }
            
            Spacer()

            if editMode == .active {
                Button(action: {
                    holder.delete()
                    editMode = .inactive
                }) {
                    Image(systemName: "trash")
                }.disabled(holder.selection.isEmpty)
            }
            
            
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



