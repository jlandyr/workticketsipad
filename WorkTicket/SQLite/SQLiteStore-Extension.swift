//
//  SQLiteStore-Extension.swift
//  WorkTicket
//
//  Created by Juan Landy on 24/10/22.
//

import Foundation
import SQLite3

extension SqliteStore {
    
    ///"INSERT INTO Tickets (Name, Address, Date, Identifier) VALUES (?,?,?,?)"
    func create(record: Ticket, onComplete: @escaping (Result<Void,Error>) -> Void){
        
        // ensure statements are created on first usage if nil
        guard self.prepareInsertEntryStmt() == SQLITE_OK else {return onComplete(.failure(NSError(domain: "error prepareInsertEntryStmt", code: 0))) }
        
        defer {
            // finalize the prepared statement on exit.
            sqlite3_finalize(self.insertEntryStmt)
        }
        
        //Inserting name in insertEntryStmt prepared statement
        if sqlite3_bind_int(self.insertEntryStmt, 1, Int32(record.date.timeIntervalSince1970)) != SQLITE_OK {
            onComplete(.failure(NSError(domain: "sqlite3_bind_int(insertEntryStmt)", code: 0)))
        }
        if sqlite3_bind_text(self.insertEntryStmt, 2, (record.name as NSString).utf8String, -1, nil) != SQLITE_OK {
            onComplete(.failure(NSError(domain: "sqlite3_bind_text(insertEntryStmt)", code: 0)))
        }
        
        //Inserting address in insertEntryStmt prepared statement
        if sqlite3_bind_text(self.insertEntryStmt, 3, (record.address as NSString).utf8String, -1, nil) != SQLITE_OK {
            onComplete(.failure(NSError(domain: "sqlite3_bind_text", code: 0)))
        }
        
        //Inserting date in insertEntryStmt prepared statement
        if sqlite3_bind_double(self.insertEntryStmt, 4, record.date.timeIntervalSince1970) != SQLITE_OK {
            onComplete(.failure(NSError(domain: "sqlite3_bind_text(insertEntryStmt)", code: 0)))
        }
        
        //Inserting address in insertEntryStmt prepared statement
        if sqlite3_bind_text(self.insertEntryStmt, 5, (record.identifier as NSString).utf8String, -1, nil) != SQLITE_OK {
            onComplete(.failure(NSError(domain: "sqlite3_bind_text", code: 0)))
        }
        
        //executing the query to insert values
        if sqlite3_step(self.insertEntryStmt) == SQLITE_DONE {
            onComplete(.success(Void()))
        } else {
            onComplete(.failure(NSError(domain: "sqlite3_step(insertEntryStmt)", code: 0)))
        }
    }
    
    ///"SELECT * FROM Tickets WHERE Identifier = ?"
    func read(identifier: String) throws -> [Ticket] {
        // ensure statements are created on first usage if nil
        guard self.prepareReadEntryStmt() == SQLITE_OK else { throw SQLiteError(message: "Error in prepareReadEntryStmt") }
        
        defer {
            // finalize the prepared statement on exit.
            sqlite3_finalize(self.readEntryStmt)
        }
        
        //Inserting identifier in readEntryStmt prepared statement
        if sqlite3_bind_text(self.readEntryStmt, 1, (identifier as NSString).utf8String, -1, nil) != SQLITE_OK {
            throw SQLiteError(message: "Error in inserting value in prepareReadEntryStmt")
        }
        var array : [Ticket] = []
        while (sqlite3_step(readEntryStmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(readEntryStmt, 0)
            guard let queryResultCol1 = sqlite3_column_text(readEntryStmt, 1) else {
                throw SQLiteError(message: "Query result name = is nil.")
            }
            let key = Int(id)
            let name = String(cString: queryResultCol1)
            guard let queryResultCol2 = sqlite3_column_text(readEntryStmt, 2) else {
                throw SQLiteError(message: "Query result address = is nil.")
            }
            let address = String(cString: queryResultCol2)
            
            let date = Date.init(timeIntervalSince1970: sqlite3_column_double(readEntryStmt, 3))
            
            guard let queryResultCol4 = sqlite3_column_text(readEntryStmt, 4) else {
                throw SQLiteError(message: "Query result identifier = is nil.")
            }
            let identifier = String(cString: queryResultCol4)
            
            let ticket = Ticket(name: name, address: address, date: date, identifier: identifier, key: key)
            array.append(ticket)
            print("Query Result:")
            print("\(key) | \(name) | \(address) | \(date.dateLong) | \(identifier)")
        }
        array.sort(by: {$0.date > $1.date})
        return array
    }
    
    ///"UPDATE Tickets SET Name = ?, Address = ?, Timestamp = ? WHERE Id = ?"
    func update(record: Ticket) throws {
        // ensure statements are created on first usage if nil
        guard self.prepareUpdateEntryStmt(with: record.key) == SQLITE_OK else { throw NSError(domain: "error delete prepareUpdateEntryStmt", code: 0)}
        
        defer {
            // finalize the prepared statement on exit.
            sqlite3_finalize(self.updateEntryStmt)
        }
        
        //Inserting name in updateEntryStmt prepared statement
        if sqlite3_bind_text(self.updateEntryStmt, 1, (record.name as NSString).utf8String, -1, nil) != SQLITE_OK {
            throw SQLiteError(message: "sqlite3_bind_text(updateEntryStmt)")
        }
        
        //Inserting address in updateEntryStmt prepared statement
        if sqlite3_bind_text(self.updateEntryStmt, 2, (record.address as NSString).utf8String, -1, nil) != SQLITE_OK {
            throw SQLiteError(message: "sqlite3_bind_text(updateEntryStmt)")
        }

        //Inserting date in updateEntryStmt prepared statement
        if sqlite3_bind_double(self.updateEntryStmt, 3, record.date.timeIntervalSince1970) != SQLITE_OK {
            throw SQLiteError(message: "sqlite3_bind_double(updateEntryStmt)")
        }
        
        //executing the query to update values
        let r = sqlite3_step(self.updateEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(updateEntryStmt) \(r)")
            throw SQLiteError(message: "sqlite3_step(updateEntryStmt)")
        }
    }
    
    ///"DELETE FROM Tickets WHERE Id = ?"
    func delete(id: Int) throws{
        // ensure statements are created on first usage if nil
        guard self.prepareDeleteEntryStmt(with: id) == SQLITE_OK else {
            throw NSError(domain: "error delete prepareDeleteEntryStmt", code: 0)
        }
        
        defer {
            // reset the prepared statement on exit.
            sqlite3_finalize(self.deleteEntryStmt)
        }
        
        //executing the query to delete row
        let r = sqlite3_step(self.deleteEntryStmt)
        if r != SQLITE_DONE {
            logDbErr("sqlite3_step(deleteEntryStmt) \(r)")
            throw SQLiteError(message: "sqlite3_bind_text(deleteEntryStmt)")
        }
    }
    
    /// INSERT/CREATE operation prepared statement
    func prepareInsertEntryStmt() -> Int32 {
        insertEntryStmt = nil
        guard insertEntryStmt == nil else { return SQLITE_OK }
        let sql = "INSERT INTO Tickets (Id, Name, Address, Timestamp, Identifier) VALUES (?,?,?,?,?)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &insertEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare insertEntryStmt")
        }
        return r
    }
    
    /// READ operation prepared statement
    func prepareReadEntryStmt() -> Int32 {
        readEntryStmt = nil
        let sql = "SELECT * FROM Tickets WHERE Identifier = ?"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &readEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare readEntryStmt")
        }
        return r
    }
    
    /// UPDATE operation prepared statement
    func prepareUpdateEntryStmt(with id:Int) -> Int32 {
        updateEntryStmt = nil
        let sql = "UPDATE Tickets SET Name = ?, Address = ?, Timestamp = ? WHERE Id = \(id)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &updateEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare updateEntryStmt")
        }
        return r
    }
    
    /// DELETE operation prepared statement
    func prepareDeleteEntryStmt(with id:Int) -> Int32 {
        deleteEntryStmt = nil
        let sql = "DELETE FROM Tickets WHERE Id = \(id)"
        //preparing the query
        let r = sqlite3_prepare(db, sql, -1, &deleteEntryStmt, nil)
        if  r != SQLITE_OK {
            logDbErr("sqlite3_prepare deleteEntryStmt")
        }
        return r
    }
}
