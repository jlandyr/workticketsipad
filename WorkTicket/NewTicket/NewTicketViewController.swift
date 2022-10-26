//
//  NewTicketViewController.swift
//  WorkTicket
//
//  Created by Juan Landy on 26/10/22.
//

import UIKit

class NewTicketViewController: UIViewController {

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var callback : ((Ticket) -> Void)?
    var identifier : String?
    
    private var selectedDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dateDidChange(_ sender: Any) {
        selectedDate = datePicker.date
    }
    
    @IBAction func didSelectSave(_ sender: Any) {
        if let name = textName.text, !name.isEmpty, let address = textAddress.text, !address.isEmpty, let date = selectedDate, let id = identifier {
            callback?(Ticket(name: name, address: address, date: date, identifier: id))
            dismiss(animated: true)
        }
    }
}
