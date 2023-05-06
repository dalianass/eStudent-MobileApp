import Foundation

//handling login/logout
class UserSettings : ObservableObject {
    @Published var isLoggedIn : Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "login")
            //UserDefaults ovde cuva stanje i nakon iskljucivanja aplikacije
        }
    }
    
    @Published var userId : Int {
        didSet {
            UserDefaults.standard.set(userId, forKey: "userId")
            //UserDefaults ovde cuva stanje i nakon iskljucivanja aplikacije
        }
    }

    @Published var uloga : String {
        didSet {
            UserDefaults.standard.set(uloga, forKey: "uloga")
            //UserDefaults ovde cuva stanje i nakon iskljucivanja aplikacije
        }
    }
    
    @Published var prikaziPocetnaStudent : Bool {
        didSet {
            UserDefaults.standard.set(prikaziPocetnaStudent, forKey: "prikazPocetneZaStudenta")
            //UserDefaults ovde cuva stanje i nakon iskljucivanja aplikacije
        }
    }
    
    @Published var prikaziPocetnaSluzba : Bool {
        didSet {
            UserDefaults.standard.set(prikaziPocetnaSluzba, forKey: "prikazPocetneZaSluzbu")
            //UserDefaults ovde cuva stanje i nakon iskljucivanja aplikacije
        }
    }

    init() {
        self.isLoggedIn = false
        self.userId = 0
        self.uloga = ""
        self.prikaziPocetnaSluzba = false
        self.prikaziPocetnaStudent = false
    }
}
