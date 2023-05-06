
import SwiftUI

struct DefaultScreenStudent: View {
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
                        Image(systemName: "pencil")
//                            .renderingMode(.template)
                        Text("Prijavljeni ispiti")
                          
                    }

                PregledPolozenihPredmeta()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Polozeni ispiti")
                    }

                Button {
                    settings.isLoggedIn = false
                    settings.userId = 0
                    settings.uloga = ""
                    settings.prikaziPocetnaStudent = false
                    
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
                    Image(systemName: "power")
                    Text("Odjavi se")
                }
            }
            .accentColor(.pink)
            .navigationBarHidden(true)
        }
        else {
            Login()
        }
    }
}

struct DefaultScreenStudent_Previews: PreviewProvider {
    static var previews: some View {
        DefaultScreenStudent()
            .environmentObject(UserSettings())
    }
}
