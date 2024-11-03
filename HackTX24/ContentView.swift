import SwiftUI

struct ContentView: View {
    var body: some View {
        ARContentView()  // Use ARContentView instead of ARView
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
