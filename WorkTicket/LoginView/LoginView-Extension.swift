//
//  LoginView-Extension.swift
//  WorkTicket
//
//  Created by Juan Landy on 24/10/22.
//

import Foundation
import UIKit

extension LoginViewController {
    
    //MARK: Keyboard handling
    func setKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0 - (keyboardSize.height / 2.0)
         }
     }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
     }
    
    //MARK: Navigation
    func navigateToDashboard(withUser userName:String) {
        guard let dashboardViewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "DashboardViewController") as? DashboardViewController else {return}
        dashboardViewController.userName =  userName
       let nav = UINavigationController(rootViewController: dashboardViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
        
}
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
