//
//  DashboardViewController.swift
//  WorkTicket
//
//  Created by Juan Landy on 25/10/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = tableDataSource
            tableView.delegate = self
        }
    }
    
    private var tableDataSource: TicketTableViewDiffibleDataSource!
    var userName : String?
    private var dashboardViewModel : DashboardViewModel!
    var sortedTickets : [[Ticket]] = []
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        setUpTableDataSource()
        guard let user = userName else {return}
        setViewModel(with: user)
        getTickets()
    }
    
    //MARK: Navigation buttons action
    @IBAction func didSelectCalendar(_ sender: UIBarButtonItem) {
        guard let calendarViewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else {return}
        calendarViewController.sortedTickets = self.sortedTickets
        calendarViewController.modalPresentationStyle = .formSheet
        self.present(calendarViewController,animated: true)
    }
    @IBAction func didSelectSync(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func didSelectCreateNewTicket(_ sender: UIBarButtonItem) {
        guard let name = userName else {return}
        guard let newTicketViewController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "NewTicketViewController") as? NewTicketViewController else {return}
        newTicketViewController.object = (name,nil)
        newTicketViewController.callback = {[weak self] ticket in
            guard let self = self else {return}
            self.saveTicket(ticket: ticket)
        }
        newTicketViewController.modalPresentationStyle = .formSheet
        self.present(newTicketViewController, animated: true)
    }
    
    @IBAction func didSelectMenu(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"Work ticket", style: .default, handler: {[weak self] (action) in
            guard let self = self else {return}
            if let ticket = self.sortedTickets.first?.first {
                self.navigateToTicket(ticket: ticket)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Get directions", style: .default, handler: {[weak self] (action) in
            guard let self = self else {return}
            self.navigateToDirections()
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.barButtonItem = buttonMenu
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension DashboardViewController {
    
    private func setViewModel(with userName: String) {
        dashboardViewModel = DashboardViewModel(userName: userName)
    }
    
    private func getTickets(){
        dashboardViewModel.getTickets {[weak self] result in
            guard let self = self else {return}
            switch result {
            case.failure(let error): self.showAlert(title: "error", message: error.localizedDescription)
            case .success(let tickets):
                self.updateSnapshot(tickets: tickets)
            }
        }
    }
    
    private func saveTicket(ticket:Ticket){
        dashboardViewModel.saveTicket(ticket: ticket) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error): self.showAlert(title: "error", message: error.localizedDescription)
            case .success():
                self.getTickets()
                self.navigateToTicket(ticket: ticket)
            }
        }
    }
    
    func updateTicket(ticket:Ticket) {
        dashboardViewModel.updateTicket(ticket: ticket) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error): self.showAlert(title: "error", message: error.localizedDescription)
            case .success():
                self.getTickets()
            }
        }
    }
    
    func deleteTicket(ticket:Ticket){
        dashboardViewModel.deleteTicket(ticket: ticket) { result in
            switch result {
            case .failure(let error): self.showAlert(title: "error", message: error.localizedDescription)
            case .success(): self.getTickets()
            }
        }
    }
    
    private func groupTicketsByDate(_ tickets: [Ticket]) -> [[Ticket]] {
        var array : [[Ticket]] = []
        let sortedArray = tickets.sorted(by: {$0.date < $1.date})
        for i in 0..<sortedArray.count{
            let matchA = sortedArray[i]
            if array.count > 0{
                var isEqual = false
                for x in 0..<array.count{
                    for y in 0..<array[x].count{
                        let matchB = array[x][y]
                        if Calendar.current.isDate(matchA.date, inSameDayAs: matchB.date){//same day
                            array[x].append(matchA)
                            isEqual = true
                            break
                        }
                    }
                }
                if !isEqual{
                    array.append([matchA])
                }
            }else{
                array.append([matchA])
            }
        }
        return array
    }
    
    //MARK: TableViewDiffibleDataSource
    private func setUpTableDataSource() {
        tableDataSource = TicketTableViewDiffibleDataSource(tableView: tableView, cellProvider: { tableView, indexPath, ticket in
            let cell = tableView.dequeueReusableCell(withIdentifier: TicketTableViewCell.identifier) as! TicketTableViewCell
            cell.ticket = ticket
            cell.didSelectViewTicket = {[weak self] ticket in
                guard let self = self else {return}
                self.navigateToTicket(ticket: ticket)
            }
            return cell
        })
    }

    private func updateSnapshot(animated: Bool = true, tickets: [Ticket]) {
        sortedTickets = groupTicketsByDate(tickets)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ticket>()
        snapshot.appendSections(sortedTickets.count.createArray())
        for (index, item) in sortedTickets.enumerated() {
            snapshot.appendItems(item,toSection: index)
        }
        tableDataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func registerTableView(){
        tableView.register(UINib(nibName: TicketTableViewCell.identifier, bundle: nil), forCellReuseIdentifier:  TicketTableViewCell.identifier)
    }
}


