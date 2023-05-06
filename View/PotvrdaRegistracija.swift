
import SwiftUI

struct PotvrdaRegistracija: View {
    @State private var emails = [String]()
    @State private var responsePotvrdi : String = ""
    @State private var showingAlertPotvrdjeno = false
    @State private var showingAlertObrisano = false
    
    var body: some View {
        
        VStack{
            
            
            Text("Potvrda registracija")
                .foregroundColor(.pink)
                .font(.system(size: 25, weight: .bold, design: .rounded))
                            
            List(emails, id: \.self) {
                email in
                VStack{
                    Text(email)
                        .font(.headline)
                    
                    Button {
                        Task{
                            await postPotvrdiRegistraciju(email:email)
                        }
                    } label: {
                        Text("Potvrdi registraciju")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 350, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.pink, .orange], startPoint: .top, endPoint: .bottomTrailing))
                            )
                    }
                    .alert("Uspesno potvrdjena registracija \(responsePotvrdi)", isPresented: $showingAlertPotvrdjeno) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    //                Button {
                    //                    Task{
                    //                        await deleteRegistraciju(email:email)
                    //                    }
                    //                } label: {
                    //                    Text("Obrisi registraciju")
                    //                        .bold()
                    //                        .foregroundColor(.white)
                    //                        .frame(width: 350, height: 40)
                    //                        .background(
                    //                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                    //                                .fill(.linearGradient(colors: [.blue, .orange], startPoint: .top, endPoint: .bottomTrailing))
                    //                        )
                    //                }
                    //                .alert("Uspesno obrisana registracija", isPresented: $showingAlertObrisano) {
                    //                    Button("OK", role: .cancel) { }
                    //                }
                }
            }
            .navigationTitle("Potvrda registracija")
            .task() {
                await getNepotvrdjeneRegistracije()
            }
        }
    }
    
    
    
    func getNepotvrdjeneRegistracije() async {
        guard let url = URL(string: UrlHelper.myUrl + "/account/users-waiting-for-approval") else {
            print("Podaci nisu uspesno pokupljeni")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([String].self, from: data) {
                self.emails = decodedResponse
            }
        }
        catch {
            print("Podaci nisu validni")
        }
    }
    
    func postPotvrdiRegistraciju(email: String) async{
        
        guard let url = URL(string: UrlHelper.myUrl + "/account/confirm-email?email=\(email)") else {
            return
        }
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(email)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        await URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    self.responsePotvrdi = responseString
                    showingAlertPotvrdjeno = true
                    }
                }
                
            
            
        }.resume()
    }
    
    func deleteRegistraciju(email: String) async {
        guard let url = URL(string: UrlHelper.myUrl + "/account/delete-user?email=\(email)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if response.statusCode == 200 {
                print("DELETE request successful")
                showingAlertObrisano = true
            } else {
                print("DELETE request failed with status code: \(response.statusCode)")
            }
        }
        
        task.resume()
    }
}

struct PotvrdaRegistracija_Previews: PreviewProvider {
    static var previews: some View {
        PotvrdaRegistracija()
    }
}
