import SwiftUI


struct Register: View {
    @State private var response: String = "aaa"
    @State private var emailTxt : String = ""
    @State private var passwordTxt: String = ""
    @State private var passwordPonovljenTxt: String = ""
    @State private var usernameTxt : String = ""
    @State private var userSurnameTxt : String = ""
    @State private var brojIndeksaTxt : String = ""
    @State private var nazivSmeraTxt : String = ""
    @State private var godinaStudijaTxt : String = ""
    
    @State private var prikaziPocetna = false
    @State private var prikaziLogin = false
    
    @State private var showingAlert = false
    @State private var messages : [String] = []
    @State private var smerovi = [Smer]()
    @State var isLoading : Bool = false
    
    @State private var selectedOption : String = ""
    var body: some View {
        ZStack {
            Color.black
            .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 30, style:
                    .continuous)
            .foregroundStyle(.linearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 1000, height: 400)
            .rotationEffect(.degrees(135))
            .offset(y: -350)
            
            ScrollView {
                VStack( spacing: 20){
                    Text("Registracija")
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    Group {
                        
                        TextField("Ime", text: $usernameTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: usernameTxt.isEmpty) {
                                Text("Ime")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                        TextField("Prezime", text: $userSurnameTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: userSurnameTxt.isEmpty) {
                                Text("Prezime")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                    }
                    Group {
                        TextField("Naziv smera", text: $nazivSmeraTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: nazivSmeraTxt.isEmpty) {
                                Text("Naziv smera")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
//                        Text("Naziv smera: \(nazivSmeraTxt)")
//                            .foregroundColor(.white)
                            
                            
                        
//                        Picker("Odaberi svoj smer", selection: $nazivSmeraTxt) {
//                            ForEach(options, id: \.self) {
//                                Text($0)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                        Picker("Odaberi svoj smer", selection: $nazivSmeraTxt) {
//                            ForEach(smerovi, id: \.id) {
//                                Text($0.nazivSmera)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                        
                        
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                        
                        
                        TextField("Broj indeksa", text: $brojIndeksaTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: brojIndeksaTxt.isEmpty) {
                                Text("Broj indeksa")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                    }
                    
                    
                    Group {
                        
                        TextField("Godina studija", text: $godinaStudijaTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: godinaStudijaTxt.isEmpty) {
                                Text("Godina studija")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                    }
                    Group{
                        
                        TextField("Email", text: $emailTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: emailTxt.isEmpty) {
                                Text("Email")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                        SecureField("Password", text: $passwordTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: passwordTxt.isEmpty) {
                                Text("Password")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                        SecureField("Ponovi password", text: $passwordPonovljenTxt)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .placeholder(when: passwordPonovljenTxt.isEmpty) {
                                Text("Ponovi password")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                    }
                    
                    Group{
                        
                        //ISPIS VALIDACIONE PORUKE
                        ForEach(messages, id: \.self) { message in
                            Text(message)
                                .foregroundColor(Color.red)
                                .padding(.all, 4)
                                .background(Color.white)
                        }
                        
                        NavigationLink(destination: Login(), isActive: $prikaziLogin) {
                            EmptyView()
                        }
                        
                        //                    NavigationLink(destination: PrijavaIspita(), isActive: $prikaziPocetna) {
                        //                        EmptyView()
                        //                    }
//                        Text(response)
//                            .foregroundColor(.white)
                        
                        if isLoading {
                            ProgressView()
                        }
                        
                        Button {
                            if validate() {
                                Task {
                                    isLoading = true
                                    await postRegister()
                                }
                            }
                        }
                    label: {
                        Text("Prosledi")
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.pink, .orange], startPoint: .top, endPoint: .bottomTrailing))
                            )
                    }
                    .alert("Sacekajte da sluzba odobri vasu registraciju. Stici ce vam mejl kao obavestenje potvrde.", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                        
                    }
                    Button {
                        prikaziLogin = true
                    } label: {
                        Text("Vec imate nalog? Ulogujte se")
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                }
                .offset(y:30)
            .frame(width: 350)
            }
        }
    }
    
    func validate() -> Bool {
        messages = []
        if emailTxt.isEmpty {
            messages.append("Unesite email")
        }
        if passwordTxt.isEmpty {
            messages.append("Unesite password")
        }
        if passwordPonovljenTxt.isEmpty {
            messages.append("Ponovite password")
        }
        if usernameTxt.isEmpty {
            messages.append("Unesite ime")
        }
        if userSurnameTxt.isEmpty {
            messages.append("Unesite prezime")
        }
        if brojIndeksaTxt.isEmpty {
            messages.append("Unesite broj indeksa")
        }
        if nazivSmeraTxt.isEmpty {
            messages.append("Unesite naziv smera")
        }
        if godinaStudijaTxt.isEmpty {
            messages.append("Unesite godinu studija")
        }
        
        if(passwordTxt.description != passwordPonovljenTxt.description) {
            messages.append("Passwordi se ne poklapaju, pokusajte ponovo")
        }
        return messages.count == 0
    }
    
    
    func postRegister()  async {
        guard let url = URL(string: UrlHelper.myUrl + "/account/register") else {
            return
        }
        
        let userData : RegisterInfo = RegisterInfo(userName: usernameTxt, prezime: userSurnameTxt, email: emailTxt, password: passwordTxt, nazivSmera: nazivSmeraTxt, godinaStudija: godinaStudijaTxt, brojIndeksa: brojIndeksaTxt)
        
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
                    //                    NavigationLink(destination: Login())
                    prikaziLogin = true
                    isLoading = false
                }
            }
        }.resume()
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
            .environmentObject(UserSettings())
    }
}

