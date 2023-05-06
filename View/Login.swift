import SwiftUI
import JWTDecode

struct Login: View {

    @State private var emailTxt = ""
    @State private var passwordTxt = ""
    @State private var response: String = "aaa"
    
    @State private var myToken: String = ""
    @State private var currentUserId: String = "aaa"

    @State private var showingAlert = false
    @State private var token : String = "token"
    @State public var role : String = ""
    
    @State private var messages : [String] = []
    @State var globalUserId : Int = 0
    @State var isLoading : Bool = false
    
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        ZStack {
            Color.black
            
            RoundedRectangle(cornerRadius: 30, style:
                    .continuous)
            .foregroundStyle(.linearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 1000, height: 400)
            .rotationEffect(.degrees(135))
            .offset(y: -350)
            
            VStack(spacing: 20){
                Image("logo-last")
                    .resizable()
                    .frame(width: 150, height: 130)
                    .offset(y:-90)
                Text("Ulogujte se")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset( y: -70)
                
                Group {
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
                }
                
                //ISPIS VALIDACIONE PORUKE
                ForEach(messages, id: \.self) { message in
                    Text(message)
                        .foregroundColor(Color.red)
                        .padding(.all, 4)
                        .background(Color.white)
                }
                
                Button {
                    

                    if validate() {
                        Task {
                            isLoading = true
                            await postLogin(emailTxt: emailTxt, passwordTxt: passwordTxt)
                        }
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
                }
                .padding(.top)
                .offset(y: 100)
                
                if isLoading {
                    ProgressView()
                }
                
                NavigationLink(destination: DefaultScreenStudent(), isActive: $settings.prikaziPocetnaStudent) {
                    EmptyView()
                }
                
                NavigationLink(destination: DefaultScreenSluzba(), isActive: $settings.prikaziPocetnaSluzba) {
                    EmptyView()
                }
                
//                Text(settings.uloga + "lalala")
//                    .foregroundColor(.white)
//                    .padding(.top)
//                    .offset(y: 80)
            }
            .frame(width: 350)
        }
        .ignoresSafeArea()
    }
    
    func getUserId( jsonString: String) -> Int {
        var userId : Int = 0
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    if let idValue = dict["id"] as? Int {
                        print(idValue)
                        userId = idValue
                    }
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        }
        return userId
    }
    
    
        func getUserToken( jsonString: String) -> String {
            var token : String = ""
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        if let tokenValue = dict["token"] as? String {
                            print(tokenValue)
                            token = tokenValue
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            }
            return token
        }
    
    func validate() -> Bool {
        messages = []
        if emailTxt.isEmpty {
            messages.append("Unesite email")
        }
        if passwordTxt.isEmpty {
            messages.append("Unesite password")
        }
        return messages.count == 0
    }

    
    func postLogin(emailTxt: String, passwordTxt: String) async{

        guard let url = URL(string: UrlHelper.myUrl + "/account/login") else {
            return
        }
        let userData = LoginInfo(email: emailTxt, password: passwordTxt)
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
                    self.token = getUserToken(jsonString: responseString)
                    DispatchQueue.main.async {
                        settings.isLoggedIn = true
                        settings.userId = getUserId(jsonString: responseString)
                        
                        do {
                            let jwt = try decode(jwt: token)
//                            self.role =  jwt.claim(name: "role").string ?? ""
                            settings.uloga = jwt.claim(name: "role").string ?? ""
                            
                        } catch {
                            print("Failed to decode JWT token: \(error.localizedDescription)")
                        }
                        
                        if settings.uloga == "Student" {
                            settings.prikaziPocetnaStudent = true
                        }
                        else if settings.uloga == "RadnikSluzbe"{
                            settings.prikaziPocetnaSluzba = true
                        }
                        isLoading = false

                    }
                }
            }
        }.resume()
    }
    
}
    struct Login_Previews: PreviewProvider {
        static var previews: some View {
            Login()
                .environmentObject(UserSettings())
        }
    }
    
