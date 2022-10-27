//
//  OverviewTicketCollectionViewCell.swift
//  WorkTicket
//
//  Created by Juan Landy on 27/10/22.
//

import UIKit

class OverviewTicketCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    static let identifier = String(describing: OverviewTicketCollectionViewCell.self)
    var didSelectGetDirections : (() -> ())?
    
    var ticket: Ticket?{
        didSet{
            guard let newTicket = ticket else {return}
            setTicket(ticket: newTicket)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setTicket(ticket:Ticket) {
        labelDate.text = ticket.date.dateLong
        labelDescription.text = ticket.name
        labelAddress.text = ticket.address
    }
    
    @IBAction func didSelectGetDirections(_ sender: Any) {
        didSelectGetDirections?()
    }
}
