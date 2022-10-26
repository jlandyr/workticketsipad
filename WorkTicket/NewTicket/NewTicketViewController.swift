//
//  NewTicketViewController.swift
//  WorkTicket
//
//  Created by Juan Landy on 26/10/22.
//

import UIKit

class NewTicketViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textAddress: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //
    var callback : ((Ticket) -> Void)?
    private var selectedDate = Date()
    var object : (identifier: String, ticket:Ticket?)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTicket()
    }
    
    private func setTicket(){
        guard let ticket = object?.ticket else {return}
        labelTitle.text = "Update ticket"
        textName.text = ticket.name
        textAddress.text = ticket.address
        datePicker.date = ticket.date
        selectedDate = ticket.date
    }
    
    @IBAction func dateDidChange(_ sender: Any) {
        selectedDate = datePicker.date
    }
    
    @IBAction func didSelectSave(_ sender: Any) {
        if let name = textName.text, !name.isEmpty, let address = textAddress.text, !address.isEmpty, let id = object?.identifier {
            callback?(Ticket(name: name, address: address, date: selectedDate, identifier: id, key: object?.ticket?.key ?? 0))
            dismiss(animated: true)
        }
    }
}
