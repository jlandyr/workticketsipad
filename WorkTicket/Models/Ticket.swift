//
//  Ticket.swift
//  WorkTicket
//
//  Created by Juan Landy on 24/10/22.
//

import Foundation

struct Ticket : Hashable {
    var name : String
    var address: String
    var date: Date
    var identifier : String // user name -> isucorp
    var key: Int
}
