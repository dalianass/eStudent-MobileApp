import SwiftUI

struct PrijavljeniIspiti: View {
    @State private var prijavljeniPredmeti : [String] = []
//    @State private var nazivPredmeta : [String] = []
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        
        
        NavigationView {
            ZStack{
                List(prijavljeniPredmeti, id: \.self) {
                    prijava in
                    HStack{
                        VStack(alignment:.leading) {
                            
                            
                            Text("Naziv prijavljenog predmeta:")
                                .font(.headline)
                            
//                            Text(String(prijava.studentId))
//                                .font(.body)
                            
                            Text(prijava)
                                .foregroundColor(.pink)
//                                .font(.body)
//                                .task{
//                                    if settings.userId != 0 {
//                                        var res = await getNazivIspita(id: prijava.predmetId)
//                                        nazivPredmeta.append(res)
//                                    } else {
//                                        await getNazivIspita(id: 1)
//                                    }
//
//                                }

                            
                            
//                            Text(String(settings.userId))
//                                .font(.body)
                        }
//                        .task{
//                            if settings.userId != 0 {
//                                await getNazivIspita(id: prijava.predmetId)
//                            } else {
//                                await getNazivIspita(id: 1)
//                            }
//
//
//                        }
                        
                    }
                    
                }
                .navigationTitle("Moji prijavljeni ispiti")
                .task {
                    await getPrijavljeniIspiti(id: settings.userId)
//                    await getPrijavljeniIspiti(id: 2)
                   
                }
            }
        }
    }
        
        func getPrijavljeniIspiti(id: Int) async {
            guard let url = URL(string: UrlHelper.myUrl + "/predmetUser/prijavljeni-predmeti-usera?id=\(id)") else {
                print("Podaci nisu uspesno pokupljeni")
                return
            }
            
            do{
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let decodedResponse = try? JSONDecoder().decode([String].self, from: data) {
                    self.prijavljeniPredmeti = decodedResponse



                }
            }
            catch {
                print("Podaci nisu validni")
            }
        }
    
    func getNazivIspita(id: Int) async -> String {
        var result = ""
        guard let url = URL(string: UrlHelper.myUrl + "/predmet/predmet-by-id?id=\(id)") else {
            print("Podaci nisu uspesno pokupljeni")
            return "Podaci nisu uspesno pokupljeni"
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Predmet.self, from: data) {
                result = decodedResponse.naziv
                return decodedResponse.naziv
            }
        }
        catch {
            return "Podaci nisu validni"
        }
        return result
    }
    
}

struct PrijavljeniIspiti_Previews: PreviewProvider {
    static var previews: some View {
        PrijavljeniIspiti()
            .environmentObject(UserSettings())
    }
}
