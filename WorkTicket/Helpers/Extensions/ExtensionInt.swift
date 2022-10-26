//
//  ExtensionInt.swift
//  WorkTicket
//
//  Created by Juan Landy on 26/10/22.
//

import Foundation

extension Int {
    func createArray() -> [Int] {
        var array = [Int]()
        for i in 0..<self{
            array.append(i)
        }
        return array
    }
}
