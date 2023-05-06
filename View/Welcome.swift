
import SwiftUI

struct Welcome: View {
    @State private var prikaziRegister = false
    @State private var prikaziLogin = false

    var body: some View {
//        NavigationView{
            ZStack{
                Color(.black)
                //            Color(hex: 0x292929)
                    .ignoresSafeArea()
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.linearGradient(colors: [ .orange, .pink], startPoint: .top, endPoint: .bottomTrailing))
                    .ignoresSafeArea()
                    .rotationEffect(.degrees(-134))
                    .opacity(0.9)
                    .offset(y: -500)
                
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.linearGradient(colors: [ .orange, .pink], startPoint: .top, endPoint: .bottomTrailing))
                    .ignoresSafeArea()
                    .rotationEffect(.degrees(134))
                    .opacity(0.9)
                    .offset(y: -500)
                
                VStack{
                    
                    Image("final")
                        .resizable()
                        .frame(width: 200, height: 180)
                        .offset(y: -120)
                    
                    //                Spacer(minLength: 100)
                    
                    Group{
                        Button {
                            
                            prikaziRegister = true
                        } label: {
                            Text("Registruj se")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 270, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.linearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottomTrailing))
                                )
                        }
                        
                        Button {
                            
                            prikaziLogin = true
                        } label: {
                            Text("Uloguj se")
                                .bold()
                                .foregroundColor(.white)
                                .frame(width: 270, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.linearGradient(colors: [Color(hex: 0x474747)], startPoint: .top, endPoint: .bottomTrailing))
                                )
                        }
                        //                .padding(.top)
                        //                .offset(y: 30)
                    }
                    .offset(y:90)
                    
                    NavigationLink(destination: Register(), isActive: $prikaziRegister) {
                        EmptyView()
                    }
                    
                    NavigationLink(destination: Login(), isActive: $prikaziLogin) {
                        EmptyView()
                    }
                }
            }
        }
    }
//}
    
    struct Welcome_Previews: PreviewProvider {
        static var previews: some View {
            Welcome()
                .environmentObject(UserSettings())
        }
    }
    
    extension Color {
        init(hex: Int) {
            self.init(red: Double((hex >> 16) & 0xFF) / 255.0,
                      green: Double((hex >> 8) & 0xFF) / 255.0,
                      blue: Double(hex & 0xFF) / 255.0)
        }
    }

