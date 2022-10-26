//
//  LoginViewModel.swift
//  WorkTicket
//
//  Created by Juan Landy on 25/10/22.
//

import Foundation

final class LoginViewModel : NSObject {
    
    private lazy var managerLogin = LoginInteractor.init(manager: LoginAPI()).manager
    
    override init() {
        super.init()
    }
    
    func validateUser(withUserName userName: String, password: String, onComplete: @escaping (Result<Void,Error>) -> Void) {
        managerLogin.validateUser(withUserName: userName, password: password) { result in
            switch result {
            case .failure(let error):onComplete(.failure(error))
            case .success(): onComplete(.success(Void()))
            }
        }
    }
}
