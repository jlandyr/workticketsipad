//
//  ExtensionDate.swift
//  WorkTicket
//
//  Created by Juan Landy on 26/10/22.
//

import Foundation

extension Date {
 
    ///Returns a string if the is "today", was "yesterday" or is gonna be "tomorrow" or by default the date in DateFormatter()dateStyle.long
    var checkDate: String{
        if Calendar.current.isDateInToday(self){
            return "Today"
        }
        if Calendar.current.isDateInYesterday(self){
            return "Yesterday"
        }
        if Calendar.current.isDateInTomorrow(self){
            return "Tomorrow"
        }
        return self.dateLong
    }
    
    var dateShort: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    ///Returns date in format dd MMMM, HH:MM
    var dateMedium: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    ///Returns date in DateFormatter().dateStyle = .long
    var dateLong: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
