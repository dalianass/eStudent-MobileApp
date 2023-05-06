import SwiftUI

struct UnosOcenaSluzba: View {
    @State private var studentiSaPrijavljenimIspitima = [StudentPrijavaFullData]()
    
    //poput komponente
    private func PrijavaDetailedView(studentPrijava : StudentPrijavaFullData) -> some View {
        NavigationLink(destination: UnosOcenaDetailed(studentPrijava: studentPrijava)) {
            VStack(alignment: .leading) {
                Text(studentPrijava.imeIPrezimeStudenta)
                    .font(.headline)
                
                Text(studentPrijava.nazivPredmeta)
                    .font(.headline)
                    .foregroundColor(.pink)
                
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Prijavljeni ispiti studenata")
                .foregroundColor(.pink)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
            List {
                ForEach(studentiSaPrijavljenimIspitima) { studentSaIspitima in
                    PrijavaDetailedView(studentPrijava: studentSaIspitima)
                }
            }
            .task() {
                await getPrijavljeniIspitiSvihStudenata()
                print(studentiSaPrijavljenimIspitima)
            }
        }
    }
    
    
    
    
    func getPrijavljeniIspitiSvihStudenata() async {
        guard let url = URL(string: UrlHelper.myUrl + "/predmetUser") else {
            print("Podaci nisu uspesno pokupljeni")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([StudentPrijavaFullData].self, from: data) {
                self.studentiSaPrijavljenimIspitima = decodedResponse
            }
        }
        catch {
            print("Podaci nisu validni")
        }
    }
}

struct UnosOcenaSluzba_Previews: PreviewProvider {
    static var previews: some View {
        UnosOcenaSluzba()
            .environmentObject(UserSettings())
    }
}
