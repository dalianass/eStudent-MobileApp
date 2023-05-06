import SwiftUI

struct Grid: View {
        
        let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9"]
        let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        if item == items[0] || item == items[4] || item == items[8] {
                            
                                Image("men")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .rotationEffect(.degrees(360))
                                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                            
                        } else {
                            RoundedRectangle(cornerRadius: 30, style:
                                    .continuous)
                            .frame(width: 100, height: 100)
                        }
                    }
                }
                .padding()
            }
        }
}

struct Grid_Previews: PreviewProvider {
    static var previews: some View {
        Grid()
    }
}
