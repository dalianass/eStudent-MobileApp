
import Foundation

//func getPredmeti(predmeti: inout [Predmet]) async {
//    guard let url = URL(string: UrlHelper.myUrl + "/predmet") else {
//        print("Podaci nisu uspesno pokupljeni")
//        return
//    }
//
//    do{
//        let (data, _) = try await URLSession.shared.data(from: url)
//        
//        if let decodedResponse = try? JSONDecoder().decode([Predmet].self, from: data) {
//            predmeti = decodedResponse
//        }
//    }
//     catch {
//        print("Podaci nisu validni")
//        }
//}


//    func decodeJwtToken(ourToken: String)  -> Void {
//        let token = ourToken
//        do {
//            let jwt = try decode(jwt: token)
//            // Access the claims in the JWT token
//            let userId = jwt.claim(name: "sub").string ?? ""
//            let username = jwt.claim(name: "username").string ?? ""
//            // ...
//        } catch {
//            print("Failed to decode JWT token: \(error.localizedDescription)")
//        }
//    }

func getSmerovi(smerovi: inout [Smer]) async {
    guard let url = URL(string: UrlHelper.myUrl + "/smer") else {
        print("Podaci nisu uspesno pokupljeni")
        return
    }

    do{
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let decodedResponse = try? JSONDecoder().decode([Smer].self, from: data) {
            smerovi = decodedResponse
        }
    }
     catch {
        print("Podaci nisu validni")
        }
}

//func postLogin(emailTxt: String, passwordTxt: String, response: inout String) async{
//    var responseMessage : String = ""
//    guard let url = URL(string: UrlHelper.myUrl + "/account/login") else {
//        return
//    }
//    let userData = LoginInfo(email: emailTxt, password: passwordTxt)
//    let jsonEncoder = JSONEncoder()
//    let jsonData = try? jsonEncoder.encode(userData)
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.httpBody = jsonData
//    
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        if let data = data {
//            if let responseString = String(data: data, encoding: .utf8) {
////                response = "Uspesno"
//                responseMessage = responseString
////                currentUserId = getUserId(jsonString: self.response)
////                showingAlert = true
//                
//            }
//        }
//        
//    }.resume()
//    response = responseMessage
//}


