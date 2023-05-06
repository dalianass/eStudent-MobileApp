import SwiftUI

struct PrijavaIspita: View {
    @State private var predmeti = [Predmet]()
    @State private var prijavaActive : Prijava = Prijava()
    
    @EnvironmentObject var settings: UserSettings
    @State private var response: String = "aaaa"
    @State private var showingAlert = false
     
    var body: some View {
        NavigationView {
            ZStack{

                //                Color.black
                VStack {
                    if prijavaActive.prijavaAktivna {
                        
                        List(predmeti, id: \.id) {
                            predmet in
                            HStack{
                                VStack(alignment:.leading) {
                                    Text(predmet.naziv)
                                        .font(.headline)
                                    
                                    Text(predmet.imeIPrezimeProfesora)
                                        .font(.body)
                                    
                                }
                                
                                Spacer()
                                Group {
                                    
                                }
                                Button {
                                    Task{
                                        await postPrijaviIspit(studentId:settings.userId, predmetId:predmet.id)
                                    }
                                } label: {
                                    Text("Prijavi ispit")
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(width: 120, height: 40)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(.linearGradient(colors: [.pink, .orange], startPoint: .top, endPoint: .bottomTrailing))
                                        )
                                }
                                .alert("Uspesno ste prijavili ispit!", isPresented: $showingAlert) {
                                    Button("OK", role: .cancel) { }
                                }
                                
                            }
                            
                        }.navigationTitle("Prijava ispita")
                    }
                else {
                    Text("Ne mozete prijaviti ispite, prijava nije aktivna!").foregroundColor(.red)
                }

            }
        }
        }
        .task {
            await getPredmeti(id: settings.userId)
            await getPrijavaActive()
        }
    }
    
        func postPrijaviIspit(studentId: Int, predmetId: Int) async{
            guard let url = URL(string: UrlHelper.myUrl + "/predmetUser/dodaj-predmet-user") else {
                return
            }
            let userData = PrijavaIspitaInfo(studentId: studentId, predmetId: predmetId)
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(userData)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            await URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        self.response = responseString
                        showingAlert = true
                    }
                }
            }.resume()
        }
    
    func getPredmeti(id: Int) async {
        guard let url = URL(string: UrlHelper.myUrl + "/predmet/neprijavljeni-predmeti?studentId=\(id)") else {
            print("Podaci nisu uspesno pokupljeni")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Predmet].self, from: data) {
                self.predmeti = decodedResponse
            }
        }
        catch {
            print("Podaci nisu validni")
        }
    }
    
    func getPrijavaActive() async {
        guard let url = URL(string: UrlHelper.myUrl + "/prijava") else {
            print("Podaci nisu uspesno pokupljeni")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Prijava.self, from: data) {
                self.prijavaActive = decodedResponse
            }
        }
        catch {
            print("Podaci nisu validni")
        }
    }

}

struct PrijavaIspita_Previews: PreviewProvider {
    static var previews: some View {
        PrijavaIspita()
            .environmentObject(UserSettings())
    }
}
