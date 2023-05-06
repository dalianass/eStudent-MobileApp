

import SwiftUI

struct PrijavaEdit: View {
    @State var studentPrijava: StudentPrijavaFullData
    @State private var responsePrijava: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack( alignment: .leading, spacing: 20) {
                
                Text("Unesi zapisnik: ")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .offset(y:-120)
                
                TextField("Ime i prezime studenta", text: $studentPrijava.imeIPrezimeStudenta)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: studentPrijava.imeIPrezimeStudenta.isEmpty) {
                        Text("Unesite ime i prezime studenta")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                
                TextField("Naziv predmeta", text: $studentPrijava.nazivPredmeta)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: studentPrijava.nazivPredmeta.isEmpty) {
                        Text("Unesite naziv predmeta")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Text("Unesite ocenu u nastavku:")
                    .foregroundColor(.pink)
                    .font(.system(size: 18, weight: .bold))
                    
                TextField("Ocena", value: $studentPrijava.ocena,  formatter: NumberFormatter())
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: String(studentPrijava.ocena).isEmpty) {
                        Text("Unesite ocenu")
                            .foregroundColor(.white)
                            .bold()
                    }
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                
                Toggle("Polozio/Nije polozio", isOn: $studentPrijava.polozen)
                    .toggleStyle(SwitchToggleStyle(tint: .gray))
                    .foregroundColor(.white)
                    .background(.pink)
                    .cornerRadius(5.0)
                
                
                //                TextField("Polozio/Nije polozio", text: $studentPrijava.polozen)
                //                    .foregroundColor(.white)
                //                    .textFieldStyle(.plain)
                //                    .placeholder(when: String(studentPrijava.ocena).isEmpty) {
                //                        Text("Unesite ocenu")
                //                            .foregroundColor(.white)
                //                            .bold()
                //                    }
                //                Rectangle()
                //                    .frame(width: 350, height: 1)
                //                    .foregroundColor(.white)
                //
                
                //

                
                Button {
                    
                    Task {
                                                await updateZapisnik()
                        
                    }
                } label: {
                    Text("Prosledi")
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 350, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .orange], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        
                }
                                .alert("Uspesno ste uneli zapisnik!", isPresented: $showingAlert) {
                                    Button("OK", role: .cancel) { }
                                }
                
            }
            .offset(y:30)
            .frame(width: 350)
        }
        
    }
    
    func updateZapisnik() async {
        guard let url = URL(string: UrlHelper.myUrl + "/PredmetUser") else {
            return
        }
        
        let prijavaData = PrijavaIspitaInfo(studentId: studentPrijava.studentId, predmetId: studentPrijava.predmetId, polozen: studentPrijava.polozen, ocena: studentPrijava.ocena)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(prijavaData)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response here
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    self.responsePrijava = responseString
                    print(responseString)
                    showingAlert = true
                }
            }
        }.resume()
    }

        
    }

struct PrijavaEdit_Previews: PreviewProvider {
    static var previews: some View {
        
        let prijava = StudentPrijavaFullData(studentId: 1, predmetId: 5, imeIPrezimeStudenta: "Enisa", nazivPredmeta: "Neki predmet")
        return
//        NavigationView{
            PrijavaEdit(studentPrijava: prijava)
            .environmentObject(UserSettings())
//        }
    }
}
