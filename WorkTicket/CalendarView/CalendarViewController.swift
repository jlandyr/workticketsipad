//
//  CalendarViewController.swift
//  WorkTicket
//
//  Created by Juan Landy on 27/10/22.
//

import UIKit

class CalendarViewController: UIViewController {

    var sortedTickets : [[Ticket]] = [[]]
    private var calendarView = UICalendarView()
    private var labelTitle : UILabel = {
        let label = UILabel()
        label.text = "Due dates for tickets"
        label.font = UIFont(name: "Helvetica-Bold", size: 17)
        return label
    }()
    private var buttonAccept : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10.0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setCalendar()
        setDatesRanges()
    }

    private func setConstraints(){
        self.view.addSubview(labelTitle)
        self.view.addSubview(calendarView)
        self.view.addSubview(buttonAccept)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        buttonAccept.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonAccept.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10),
            buttonAccept.widthAnchor.constraint(equalToConstant: 200),
            buttonAccept.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setCalendar(){
        calendarView.calendar = Calendar.current
        calendarView.delegate = self
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        
        buttonAccept.addTarget(self, action: #selector(self.didSelectAccept), for: .touchUpInside)
    }
    
    
    private func setDatesRanges(){
        calendarView.availableDateRange = DateInterval.init(start: sortedTickets.first?.first?.date ?? Date(), end: sortedTickets.last?.last?.date ?? Date())
    }
    
    @objc private func didSelectAccept(){
        dismiss(animated: true)
    }
}

extension CalendarViewController : UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print("didSelectDate: \(String(describing: dateComponents?.date))")
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        return sortedTickets.contains{Calendar.current.isDate($0.first?.date ?? Date(), inSameDayAs: dateComponents?.date ?? Date())}
    }
}

extension CalendarViewController : UICalendarViewDelegate {
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if sortedTickets.contains(where: {Calendar.current.isDate($0.first?.date ?? Date(), inSameDayAs: dateComponents.date ?? Date())}) {
            return UICalendarView.Decoration.default(color: .systemGreen, size: .large)
        }
        return nil
    }
}
