
import SwiftUI

struct Smerovi: View {
    @State private var smerovi = [Smer]()
    @EnvironmentObject var settings: UserSettings
    @State private var response: String = "aaaa"
    @State private var showingAlert = false
    var body: some View {
        
        NavigationView {
//            ZStack{
                List(smerovi, id: \.id) {
                    predmet in
                    HStack{
                        VStack(alignment:.leading) {
                            Text(predmet.nazivSmera)
                                .font(.headline)
                            
                            Text("Id smera: " + String(predmet.id))
                                .font(.body)
                        }
                    }
                    
                }
                .navigationTitle("Smerovi")
                .task {
                    await getSmerovi()
                }
//            }
        }
    }
    func getSmerovi() async {
        guard let url = URL(string: UrlHelper.myUrl + "/smer") else {
            print("Podaci nisu uspesno pokupljeni")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Smer].self, from: data) {
                self.smerovi = decodedResponse
                
            }
        }
        catch {
            print("Podaci nisu validni")
        }
    }
}

struct Smerovi_Previews: PreviewProvider {
    static var previews: some View {
        Smerovi()
            .environmentObject(UserSettings())
    }
}
