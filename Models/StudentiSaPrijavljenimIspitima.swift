//
//  StudentiSaPrijavljenimIspitima.swift
//  DUNPprijava
//
//  Created by Lejla Buller on 4.5.23..
//

import Foundation
struct StudentiSaPrijavljenimIspitima: Codable, Identifiable {
    var id: Int? = 0
    
    var studentId: Int
    var predmetId: Int
    var imeIPrezimeStudenta : String
    var nazivPredmeta : String
    var polozen: Bool = false
    var ocena: Int = 0
}
