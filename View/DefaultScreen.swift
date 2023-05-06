
import SwiftUI

struct DefaultScreen: View {
    @EnvironmentObject var settings: UserSettings
    @State private var prikaziWelcome = false
    
    var body: some View {
        if settings.isLoggedIn {
            TabView {
                PrijavaIspita()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Prijava ispita")
                    }
                
                PrijavljeniIspiti()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Prijavljeni ispiti")
                    }
                
                Button {
                    settings.isLoggedIn = false
                    settings.userId = 0
                    
                    
                } label: {
                    Text("Odjavi se")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .orange], startPoint: .top, endPoint: .bottomTrailing))
                        )
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Odjavi se")
                }
            }
        }
        else {
            Login()
        }
    }
}

struct DefaultScreen_Previews: PreviewProvider {
    static var previews: some View {
        DefaultScreen()
            .environmentObject(UserSettings())
    }
}
