//
//  PregledPolozenihPredmeta.swift
//  DUNPprijava
//
//  Created by Lejla Buller on 5.5.23..
//

import SwiftUI

struct PregledPolozenihPredmeta: View {
    @State private var polozeniPredmeti = [StudentPrijavaFullData]()
    @EnvironmentObject var settings: UserSettings
    @State private var prosek : Float = 0.0
    var body: some View {
        ZStack {
//            Color.black
            VStack {
                Text("Pregled polozenih ispita")
                    .foregroundColor(.pink)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
//                    .offset( y: -70)
//                    .task() {
//                        await getPredmeti(id: 2)
//                    }

                List(polozeniPredmeti, id: \.id) {
                    predmet in
                    HStack {
                            Text(predmet.nazivPredmeta)
                                .font(.headline)
                            
                        Spacer()
                            Text("Ocena: " + String(predmet.ocena))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.pink)
                    }

                }
//                .background(.pink)
                .navigationTitle("Smerovi")
                .task {
                    await getPolozeniPredmeti(id: settings.userId)
                    prosek = getProsek(polozeniPredmeti: polozeniPredmeti)
                }
                Spacer()
                Text("Prosek je: " + String(prosek))
                    .foregroundColor(.pink)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
            }
            
        }
        
        
       
    }
    
    func getProsek(polozeniPredmeti: [StudentPrijavaFullData]) -> Float {
        var suma = 0
        var brojac = 0
        
        for predmet in polozeniPredmeti {
            suma += predmet.ocena
            brojac += 1
        }
        
        return Float(suma/brojac)
    }
    
    func getPolozeniPredmeti(id: Int) async {
        guard let url = URL(string: UrlHelper.myUrl + "/predmet/polozeni-predmeti?studentId=\(id)") else {
            print("Podaci nisu uspesno pokupljeni")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([StudentPrijavaFullData].self, from: data) {
                self.polozeniPredmeti = decodedResponse
                
            }
        }
        catch {
            print("Podaci nisu validni")
        }
    }

}

struct PregledPolozenihPredmeta_Previews: PreviewProvider {
    static var previews: some View {
        PregledPolozenihPredmeta()
            .environmentObject(UserSettings())
    }
}
