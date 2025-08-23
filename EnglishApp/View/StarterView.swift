import SwiftUI

struct StarterView: View {
    var body: some View {
        NavigationStack {
            VStack{
            
                NavigationLink(destination: ContentView()) {
                    VStack(spacing: 30) {
    
                    Text("学習を始める")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
            }
         
        }
    }
}

#Preview {
    StarterView()
}

