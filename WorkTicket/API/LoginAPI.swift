//
//  LoginAPI.swift
//  WorkTicket
//
//  Created by Juan Landy on 25/10/22.
//

import Foundation

final class LoginAPI : LoginManager {
    func validateUser(withUserName userName: String, password: String, onComplete: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            if userName == "isucorp", password == "isucorp" {
                onComplete(.success(Void()))
            } else {
                onComplete(.failure(NSError(domain: "username or password incorrects", code: 404)))
            }
            
        }
    }
}
