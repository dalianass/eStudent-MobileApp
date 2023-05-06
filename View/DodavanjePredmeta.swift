import SwiftUI

struct DodavanjePredmeta: View {
    @State private var naziv: String = ""
    @State private var godinaStudija: String = ""
    @State private var imeIPrezimeProfesora: String = ""
    @State private var smerId: String = ""
    @State private var response: String = ""
    @State private var showingAlert = false
    @State private var smerovi = [Smer]()
    @State private var nazivSmera : String = ""
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("Dodaj predmet")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(y:-120)

                TextField("Naziv predmeta", text: $naziv)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: naziv.isEmpty) {
                        Text("Naziv predmeta")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)

                TextField("Godina studija", text: $godinaStudija)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: godinaStudija.isEmpty) {
                        Text("Godina studija")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)



                TextField("Ime i prezime profesora na predmetu", text: $imeIPrezimeProfesora)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: imeIPrezimeProfesora.isEmpty) {
                        Text("Ime i prezime profesora na predmetu")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)

                
                Group {
                    TextField("Id smera na kome je predmet", text: $smerId)
                        .foregroundColor(.white)
                        .textFieldStyle(.plain)
                        .placeholder(when: smerId.isEmpty) {
                            Text("Id smera na kome je predmet")
                                .foregroundColor(.white)
                                .bold()
                    }
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.white)
                    
//                    Text(response)
//                        .foregroundColor(.white)
                }
//                
//                Text("Naziv smera: \(nazivSmera)")
//                    .foregroundColor(.white)


//
//                Picker("Odaberi svoj smer", selection: $nazivSmera) {
//                    ForEach(smerovi, id: \.id) { smer in
//                        Text(smer.nazivSmera)
//                            .foregroundColor(.white)
//                    }
//                }
//                .pickerStyle(.menu)
                

                Button {

                    Task {
                        await postPredmet()

                    }
                } label: {
                    Text("Prosledi")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .orange], startPoint: .top, endPoint: .bottomTrailing))
                        )
                }.offset(y:60)
                //                .alert("Uspesno ste uneli smer", isPresented: $showingAlert) {
                //                    Button("OK", role: .cancel) { }
                //                }

            }
            .frame(width: 350)
            .alert("Uspesno dodat predmet", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            .task {
                await getSmerovi()
            }
        }

    }


    func postPredmet() async{

        guard let url = URL(string: UrlHelper.myUrl + "/predmet/dodaj-predmet") else {
            return
        }
        let predmetData = Predmet(id: 0, naziv: naziv, godinaStudija: Int(godinaStudija)!, imeIPrezimeProfesora: imeIPrezimeProfesora, smerId: Int(smerId)!)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(predmetData)

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

struct DodavanjePredmeta_Previews: PreviewProvider {
    static var previews: some View {
        DodavanjePredmeta()
            .environmentObject(UserSettings())
    }
}
