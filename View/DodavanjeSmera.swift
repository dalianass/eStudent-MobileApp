
import SwiftUI

struct DodavanjeSmera: View {
    @State private var nazivSmera: String = ""
    
    @State private var response: String = ""
    
    @State private var responsePrijava: String = "aaa"
    @State private var isOn : Bool = false
    
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20){
                
                Text("Dodaj smer")
                    .foregroundColor(.pink)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(y:-120)
               
                TextField("Naziv smera", text: $nazivSmera)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: nazivSmera.isEmpty) {
                        Text("Unesite naziv smera")
                            .foregroundColor(.white)
                            .bold()
                    }
                 Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Toggle("Aktiviraj prijavu ispita", isOn: $isOn)
                            .padding()
                            .foregroundColor(.black)
                            .background(.white)
                            .onChange(of: isOn) { newValue in
                                Task {
                                    // Call a function when the toggle button is toggled
                                    await updatePrijava(isOn: newValue)
                                }


                            }


                Text("Prijava status: " + isOn.description)
                    .foregroundColor(.white)
                
                Button {

                    Task {
                        await postSmer()
                        showingAlert = true
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
                .alert("Uspesno ste uneli smer", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
//                .padding(.top)
//                .offset(y: 100)
                
                
            }
            .frame(width: 350)
            
        }
    }
    
    
    func postSmer() async{
        
        guard let url = URL(string: UrlHelper.myUrl + "/smer/dodaj-smer") else {
            return
        }
        let smerData = Smer(id: 0, nazivSmera: nazivSmera)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(smerData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        await URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    self.response = responseString
    //                currentUserId = getUserId(jsonString: self.response)
    //                showingAlert = true
                    
                }
            }
        }.resume()
    }
    

    func updatePrijava(isOn: Bool) async {
        guard let url = URL(string: UrlHelper.myUrl + "/prijava/1") else {
            return
        }
           
            let prijavaData = Prijava(id: 1, prijavaAktivna: isOn)
        
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(prijavaData)
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
    
            await URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle the response here
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        self.responsePrijava = responseString
    
                    }
                }
            }.resume()
        }



}


struct DodavanjeSmera_Previews: PreviewProvider {
    static var previews: some View {
        DodavanjeSmera()
            .environmentObject(UserSettings())
    }
}
