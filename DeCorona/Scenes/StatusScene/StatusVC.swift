//
//  StatusVC.swift
//  DeCorona
//
//  Created by Mazen on 11/26/2020.
//  Copyright © 2020 Mazen Halawi. All rights reserved.
//

import UIKit

class StatusVC: UIViewController {
    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var containerBackground:UIView!
    @IBOutlet weak var spinnerMain:UIActivityIndicatorView!
    @IBOutlet weak var btnEnableNotifications:UIButton!
    @IBOutlet weak var tblDirections:UITableView!
    @IBOutlet weak var lblLocation:UILabel!
    @IBOutlet weak var lblCoordinates:UILabel!
    @IBOutlet weak var lblCasesPer100k:UILabel!
    @IBOutlet weak var lblCases:UILabel!
    @IBOutlet weak var lblDeaths:UILabel!
    @IBOutlet weak var lblDeathRate:UILabel!
    @IBOutlet weak var lblLastUpdated:UILabel!
    @IBOutlet weak var containerIndicator:UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    private var presenter: StatusPresenterInput!
    private var index = 0
    private var didOpenSettings = false
    var refreshController:UIRefreshControl?
    
    convenience init(presenter: StatusPresenterInput) {
        self.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if didOpenSettings {
            
            spinnerMain.startAnimating()
            presenter.getLatestStatusUpdate()
            didOpenSettings = false
            
        } else {
            spinnerMain.startAnimating()
            presenter.getLatestStatusUpdate()
        }
        
    }
    
    @IBAction func enableNotifications_click(_ sender: UIButton) {
        
    }
    
    private func setupScrollView() {
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        refreshController = UIRefreshControl()
        refreshController!.attributedTitle = NSAttributedString(string: "Fetching latest data", attributes: attributes)
        refreshController!.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        refreshController?.tintColor = UIColor.white
        
        scrollView.refreshControl = self.refreshController
    }
    
    private func setupTableView() {
        tblDirections.estimatedRowHeight = UITableView.automaticDimension
        tblDirections.rowHeight = 50
        tblDirections.dataSource = self
        tblDirections.delegate = self
        tblDirections.register(UINib(nibName: "DirectionCell", bundle: Bundle(for: DirectionCell.self)), forCellReuseIdentifier: "cellDirection")
        tableHeight.constant = 50
    }
    
    private func changeBackground() {
        let green = COLOR_GREEN
        let red = COLOR_RED
        let yellow = COLOR_YELLOW

        let colors = [red, yellow, green]

        UIView.animate(withDuration: 2) {
            self.containerBackground.backgroundColor = colors[self.index]
            self.containerBackground.alpha = 0.9
        }

        index += 1
        if index >= colors.count { index = 0; }
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { [weak self] (success) in
                self?.didOpenSettings = success
            })
        }
    }
    
    private func clearUI() {
        self.containerIndicator?.backgroundColor = UIColor.clear
        self.lblCasesPer100k.text = ""
        self.lblLocation.text = ""
        self.lblCases.text = ""
        self.lblDeaths.text = ""
        self.lblDeathRate.text = ""
        self.lblCoordinates.text = ""
        self.lblLastUpdated.text = ""
        self.tblDirections.reloadData()
    }
    
    private func animateIndicator() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = self.presenter.condition.color.cgColor
        animation.toValue =  UIColor.clear.cgColor
        animation.duration = 1
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        self.containerIndicator.layer.add(animation, forKey: "backgroundColor")
    }
    
    @objc private func refreshData() {
        self.presenter.getLatestStatusUpdate()
    }
}

extension StatusVC : StatusPresenterOutput {
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.clearUI()
            self?.containerIndicator?.backgroundColor = self?.presenter.condition.color
            self?.lblCasesPer100k.text = self?.presenter.casesPer100k
            self?.lblLocation.text = self?.presenter.location
            self?.lblCases.text = self?.presenter.cases
            self?.lblDeaths.text = self?.presenter.deaths
            self?.lblDeathRate.text = self?.presenter.deathRate
            self?.lblCoordinates.text = self?.presenter.coordinates
            self?.lblLastUpdated.text = self?.presenter.lastUpdated
            self?.tblDirections.reloadData()
            
            self?.animateIndicator()
            self?.dismissSpinners()
        }
    }
    
    func dismissSpinners() {
        DispatchQueue.main.async { [weak self] in
            self?.spinnerMain.stopAnimating()
            self?.refreshController?.endRefreshing()
        }
    }
    
    func alert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismissSpinners()
            UIAlertController.showAlert(vc: self,
            title: title,
            message: message)
        }
    }
    
    func alertLocationServiceDisabled() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismissSpinners()
            UIAlertController.showAlert(vc: self,
                                        title: "Location Required",
                                        message: "You have disabled location services. We require your current location to fetch relevant data. Would you like to enable the service now?",
                                        actions: [
                                            UIAlertAction(title: "No",
                                                      style: .destructive,
                                                      handler: { [weak self] (_) in self?.dismissSpinners()}),
                                            UIAlertAction(title: "Yes",
                                                      style: .default,
                                                      handler: { [weak self] (_) in self?.openSettings();
                                                        
                                            })
                                        ])
        }
    }
    
}


extension StatusVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellDirection") as? DirectionCell else {
            fatalError("StatusVC - cellForRowAt generated an error. Could not deque cell.")
        }
        
        cell.configure(step: indexPath.row + 1, content: presenter.contentForCell(at: indexPath), condition: presenter.condition)
        
        return cell
    }
    
    
}

extension StatusVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UINib(nibName: "HeaderView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableHeight.constant = tableView.contentSize.height
            tableView.layoutIfNeeded()
        }
    }
}
