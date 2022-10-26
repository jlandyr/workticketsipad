//
//  SQLiteStore.swift
//  WorkTicket
//
//  Created by Juan Landy on 24/10/22.
//

import Foundation
import SQLite3
import os.log

final class SqliteStore {
    // Get the URL to db store file
    let dbURL: URL
    // The database pointer.
    var db: OpaquePointer?
    
    var insertEntryStmt: OpaquePointer?
    var readEntryStmt: OpaquePointer?
    var updateEntryStmt: OpaquePointer?
    var deleteEntryStmt: OpaquePointer?

    let oslog = OSLog(subsystem: "workTicket", category: "sqliteintegration")
    
    init() {
        do {
            do {
                dbURL = try FileManager.default
                    .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("database.db")
                os_log("URL: %s", dbURL.absoluteString)
            } catch {
                //TODO: Just logging the error and returning empty path URL here. Handle the error gracefully after logging
                os_log("Some error occurred. Returning empty path.")
                dbURL = URL(fileURLWithPath: "")
                return
            }
            
            try openDB()
            try createTables()
            } catch {
                //TODO: Handle the error gracefully after logging
                return
            }
    }
    
    
    // Open the DB at the given path. If file does not exists, it will create one for you
    func openDB() throws {
        if sqlite3_open(dbURL.path, &db) != SQLITE_OK { // error mostly because of corrupt database
            throw SQLiteError(message: "error opening database \(dbURL.absoluteString)")
        }
    }
    
    // Code to delete a db file. Useful to invoke in case of a corrupt DB and re-create another
    func deleteDB(dbURL: URL) {
        do {
            try FileManager.default.removeItem(at: dbURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createTables() throws {
        // create the tables if they dont exist.
        // ID | Name | Address | Timestamp | Identifier
        let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Tickets (Id INT PRIMARY KEY NOT NULL, Name TEXT NOT NULL, Address TEXT NOT NULL, Timestamp DOUBLE NOT NULL, Identifier TEXT NOT NULL)", nil, nil, nil)
        if (ret != SQLITE_OK) { // corrupt database.
            logDbErr("Error creating db table - Tickets")
            throw SQLiteError(message: "unable to create table Tickets")
        }
    }
    
    func logDbErr(_ msg: String) {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        os_log("ERROR %s : %s", log: oslog, type: .error, msg, errmsg)
    }
}

// Indicates an exception during a SQLite Operation.
class SQLiteError : Error {
    var message = ""
    var error = SQLITE_ERROR
    init(message: String = "") {
        self.message = message
    }
    init(error: Int32) {
        self.error = error
    }
}



