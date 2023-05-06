
import SwiftUI

struct UnosOcenaDetailed: View {
    var studentPrijava: StudentPrijavaFullData
    
    @State var presentEditPrijavaSheet = false
    @Environment(\.presentationMode) var presentationMode
    
    //argument funkcije je funkcija
    private func editButton(action: @escaping () -> Void) -> some View {
        Button(action: { action() }) {
            Text("Unesi zapisnik")
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text("Podaci o prijavi")) {
                Text("Ime i prezime: " + studentPrijava.imeIPrezimeStudenta)
                Text("Naziv prijavljenog ispita: " + studentPrijava.nazivPredmeta)
            }
            

//            Section(header: Text("Podaci")) {
//                Text(studentPrijava.polozen)
//                Text(studentPrijava.ocena)
//            }
            
            
        }
        .navigationBarTitle("Prijava: " + studentPrijava.imeIPrezimeStudenta)
        .navigationBarItems(trailing: editButton{
            self.presentEditPrijavaSheet.toggle()
        })
        .onAppear(){
            print("UnosOcenaDetailedView onAppear pokrenuto za \(self.studentPrijava.imeIPrezimeStudenta)")
        }
        .onDisappear(){
            print("UnosOcenaDetailedView onDisappear pokrenuto!")
        }
        .sheet(isPresented: self.$presentEditPrijavaSheet) {
            PrijavaEdit(studentPrijava: studentPrijava)
        }
    }
}

struct UnosOcenaDetailed_Previews: PreviewProvider {
    static var previews: some View {
        let prijava = StudentPrijavaFullData(studentId: 1, predmetId: 5, imeIPrezimeStudenta: "Enisa", nazivPredmeta: "Neki predmet")
        return
        NavigationView{
            UnosOcenaDetailed(studentPrijava: prijava)
                .environmentObject(UserSettings())
        }
        
    }
}
