//
//  HomeTableController.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import UIKit

class HomeTableController: UIViewController {
    
    let networkManager = NetworkManager()
    
    var events: [Event] = [] {
        didSet {
            self.eventsTableView.reloadData()
        }
    }
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search events"
        return searchController
    }()
    
    lazy var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 150
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeEventsTableCell.self, forCellReuseIdentifier: HomeEventsTableCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 48/255, green: 25/255, blue: 52/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 48/255, green: 25/255, blue: 52/255, alpha: 1.0)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController = searchController
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor(red: 48/255, green: 25/255, blue: 52/255, alpha: 1.0)
        self.view.addSubview(eventsTableView)
        
        NSLayoutConstraint.activate([
            eventsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            eventsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func getEvents() {
        networkManager.getEvents() { result in
            switch result {
            case let .success(pulledEvents):
                self.events = pulledEvents
            case let .failure(error):
                print(error)
            }
        }
    }
}

//MARK: Extensions

extension HomeTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        let vc = EventDetailsController()
        vc.details = event
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeEventsTableCell.identifier, for: indexPath) as! HomeEventsTableCell
        let event = events[indexPath.row]
        cell.details = event
        return cell
    }
}
