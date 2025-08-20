import SwiftUI

struct StarterView: View {
    var body: some View {
        NavigationStack {
            VStack {
            
                NavigationLink(destination: ContentView()) {
                    Text("アプリを始める")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("スタート画面")
        }
    }
}

#Preview {
    StarterView()
}

