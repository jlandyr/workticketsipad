//
//  Dashboard-Extension.swift
//  WorkTicket
//
//  Created by Juan Landy on 25/10/22.
//

import Foundation
import UIKit

extension DashboardViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (contextualAction, view, boolValue) in
            guard let self = self else {return}
            let ticket = self.sortedTickets[indexPath.section][indexPath.row]
            let alert = self.alert(withTitle: "Delete", message: "Do you want to delete '\(ticket.name)'?", okTitle: "Yes, delete", cancelTitle: "Cancel", okTitleStyle: .destructive) {
                self.deleteTicket(ticket: ticket)
            } onCancel: {
            }
            self.present(alert, animated: true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Update") { [weak self]  (contextualAction, view, boolValue) in
            guard let self = self else {return}
            guard let name = self.userName else {return}
            guard let newTicketViewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "NewTicketViewController") as? NewTicketViewController else {return}
            let ticket = self.sortedTickets[indexPath.section][indexPath.row]
            newTicketViewController.object = (name,ticket)
            newTicketViewController.callback = {[weak self] ticket in
                guard let self = self else {return}
                self.updateTicket(ticket: ticket)
            }
            newTicketViewController.modalPresentationStyle = .formSheet
            self.present(newTicketViewController, animated: true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    func navigateToTicket(ticket:Ticket){
        guard let ticketDetailViewController = UIStoryboard(name: "WorkTicket", bundle: nil).instantiateViewController(withIdentifier: "TicketDetailViewController") as? TicketDetailViewController else {return}
        ticketDetailViewController.ticket = ticket
        self.navigationController?.pushViewController(ticketDetailViewController, animated: true)
    }
}

class TicketTableViewDiffibleDataSource: UITableViewDiffableDataSource<Int, Ticket> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let user = self.itemIdentifier(for: IndexPath(item: 0, section: section)) else { return nil }
        return "\(user.date.checkDate)"
    }
}


