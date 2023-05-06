import Foundation
struct Smer: Codable {
    var id: Int
    var nazivSmera: String
    var prijavaOn: Bool = false
    var predmeti : [Predmet] = []
}
