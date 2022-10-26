//
//  LoginInteractor.swift
//  WorkTicket
//
//  Created by Juan Landy on 25/10/22.
//

import Foundation

final class LoginInteractor {
    
    var manager : LoginManager
    
    init(manager: LoginManager) {
        self.manager = manager
    }
}

protocol LoginManager {
    func validateUser(withUserName userName: String, password:String, onComplete: @escaping (Result<Void,Error>) -> Void)
}
