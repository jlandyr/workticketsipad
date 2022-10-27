//
//  TicketDetailViewController.swift
//  WorkTicket
//
//  Created by Juan Landy on 27/10/22.
//

import UIKit

class TicketDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    var ticket: Ticket?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard ticket != nil else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        registerCollectionView()
        collectionView.reloadData()
    }

    //MARK: Menu buttons
    @IBAction func didSelectMenu(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"Dashboard", style: .default, handler: { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Get directions", style: .default, handler: { [weak self] (action) in
            guard let self = self else {return}
            self.navigateToDirections()
        }))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.barButtonItem = buttonMenu
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: CollectionView
    private func registerCollectionView(){
        collectionView.register(UINib(nibName: "OverviewTicketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: OverviewTicketCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //MARK: Navigation
    func navigateToDirections(){
        guard let directionsViewController = UIStoryboard(name: "Directions", bundle: nil).instantiateViewController(withIdentifier: "DirectionsViewController") as? DirectionsViewController else {return}
        self.navigationController?.pushViewController(directionsViewController, animated: true)
    }
}

enum SegmentedOptions : CaseIterable {
    case Overview
    case WorkDetails
    case Purchasing
    case Finishing
    case Camera
    
    var title: String {
        switch self {
        case .Overview: return "Overview"
        case .WorkDetails: return "Work Details"
        case .Purchasing: return "Purchasing"
        case .Finishing: return "Finishing"
        case .Camera: return "Camera"
        }
    }
    
    var image : UIImage? {
        switch self {
        case .Overview: return nil
        case .WorkDetails: return nil
        case .Purchasing: return nil
        case .Finishing: return nil
        case .Camera: return UIImage(imageLiteralResourceName: "camera.fill")
        }
    }
    
}
