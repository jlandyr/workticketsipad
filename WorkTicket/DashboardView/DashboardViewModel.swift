//
//  DashboardViewModel.swift
//  WorkTicket
//
//  Created by Juan Landy on 26/10/22.
//

import Foundation

final class DashboardViewModel  {
    
    private var userName : String?
    private let sqliteDbStore = SqliteStore()
    
    init(userName: String){
        self.userName = userName
    }
    
    func getTickets(onComplete: @escaping (Result<[Ticket],Error>) -> Void) {
        guard let identifier = self.userName else {
            onComplete(.failure(NSError(domain: "No identifier available", code: 100)))
            return
        }
        do{
            let tickets = try sqliteDbStore.read(identifier: identifier)
            onComplete(.success(tickets))
        }catch{
            onComplete(.failure(error))
        }
    }
    
    func saveTicket(ticket: Ticket, onComplete: @escaping (Result<Void,Error>) -> Void) {
        sqliteDbStore.create(record: ticket) { result in
            switch result {
            case .failure(let error): onComplete(.failure(error))
            case .success(): onComplete(.success(Void()))
            }
        }
    }
    
    func updateTicket(ticket:Ticket, onComplete: @escaping(Result<Void,Error>) -> Void){
        do {
            onComplete(.success(try sqliteDbStore.update(record: ticket)))
        }catch{
            onComplete(.failure(error))
        }
        
    }
    
    func deleteTicket(ticket: Ticket, onComplete: @escaping(Result<Void,Error>) -> Void){
        do{
            onComplete(.success(try sqliteDbStore.delete(id: ticket.key)))
        }catch{
            onComplete(.failure(error))
        }
    }
}


