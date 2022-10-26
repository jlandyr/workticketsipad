//
//  ExtensionUIViewController.swift
//  WorkTicket
//
//  Created by Juan Landy on 25/10/22.
//

import Foundation
import UIKit

extension UIViewController {
    ///UIAlertController
    func showAlert(title:String, message:String?){
        
        let alert = UIAlertController(title: title, message: message ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        if let popOver = alert.popoverPresentationController {
            popOver.sourceView = self.view
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    ///Custom UIAlertController with callback and .default & .cancel style UIAlertAction
    func alert(withTitle title:String?, message:String, okTitle:String, cancelTitle:String, okTitleStyle: UIAlertAction.Style, onOk: @escaping (() -> Void), onCancel: @escaping (() -> Void) ) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: okTitleStyle) { (_) in
            onOk()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            onCancel()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        //check for iPad
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        if let popOver = alert.popoverPresentationController {
            popOver.sourceView = self.view
        }
        return alert
    }
}
