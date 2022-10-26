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

}
