//
//  TicketTableViewCell.swift
//  WorkTicket
//
//  Created by Juan Landy on 25/10/22.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTicketNumber: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    
    static let identifier = String(describing: TicketTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var ticket : Ticket? {
        didSet{
            guard let ticket = ticket else {return}
            labelTicketNumber.text = ticket.identifier
            labelName.text = ticket.name
            labelAddress.text = ticket.address
        }
    }
    
}
