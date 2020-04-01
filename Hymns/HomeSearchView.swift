import SwiftUI

struct HomeSearchView: View {
    @State var isActive: Bool = false
    @State private var searchText: String = ""
    var allHymns: [DummyHymnView] = testData
    
    var body: some View {
        VStack {
            NavigationLink(destination: SearchBarSearchView(),
                           isActive: $isActive) {
                            Button(action: {
                                self.isActive.toggle()
                            }) {
                                SearchBar(text: $searchText).disabled(true) // This line gives the searchbar image but disables the text field to be used as a button
                            }.onAppear{self.isActive = false}
            }
            List {
                ForEach(self.allHymns.filter { self.searchText.isEmpty ? true : $0.songTitle.contains(self.searchText)}) { hymn in
                    Text(hymn.songTitle)
                }.navigationBarTitle(Text("Look up any hymn"))
            }
        } /*.onAppear(perform: self.isActive = false})*/ .onAppear {print(self.isActive) } /* .onDisappear { */
             //   print("ContentView disappeared!")}
    
            //.onAppear { self.isActive = false } // I don't think this is working...*/
    }}


struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView()
    }
}

// .onAppear(perform: {
                //   self.textName = ""
            //   })
