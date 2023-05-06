//
//  StudentPrijavaFullData.swift
//  DUNPprijava
//
//  Created by Lejla Buller on 4.5.23..
//

import Foundation

struct StudentPrijavaFullData: Codable, Identifiable {
//    var id: ObjectIdentifier
    var id: Int?
//    var id : String = UUID()
    var studentId: Int
    var predmetId: Int
    var imeIPrezimeStudenta : String
    var nazivPredmeta : String
    var polozen: Bool = false
    var ocena: Int = 0
}


