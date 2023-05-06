import Foundation
struct PrijavaIspitaInfo: Codable {
    var studentId: Int
    var predmetId: Int
    var polozen: Bool = false
    var ocena: Int = 0
}
