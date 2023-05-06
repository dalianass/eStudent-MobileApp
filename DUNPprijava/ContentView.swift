
import SwiftUI
struct ContentView: View {
    @State private var showDetail = false
    var body: some View {
            NavigationView {
                VStack {
//                    Button("Go to  Welcome") {
//                        // Perform some action here before showing the detail view
//                        showDetail = true
//                    }
//                    NavigationLink(destination: Login(), isActive: $showDetail) {
//                        EmptyView()
//                    }
                      Welcome()
//                    PotvrdaRegistracija()
//                    PregledPolozenihPredmeta()
                }
                .navigationTitle("Welcome")
                .navigationBarHidden(true)
            }
        }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserSettings())
    }
}



