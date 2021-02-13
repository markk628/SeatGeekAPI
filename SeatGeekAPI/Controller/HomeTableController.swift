//
//  HomeTableController.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import UIKit

class HomeTableController: UIViewController {
    
    //MARK: Properties
    private let networkManager = NetworkManager()
    
    private var favoriteEvents: [String] = UserDefaults.standard.stringArray(forKey: "Favorites") ?? [String]()
    
    // table view must reload if it events are changed
    private var events: [Event] = [] {
        didSet {
            self.eventsTableView.reloadData()
        }
    }
    
    // for searchbar filtered events
    private var filteredEvents: [Event]!
    
    //MARK: Views
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search events"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var eventsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 150
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeEventsTableCell.self, forCellReuseIdentifier: HomeEventsTableCell.identifier)
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshEventsTable), for: .valueChanged)
        return refresh
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavBar()
        getEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupDetailControllerNavBar()
    }
    
    //MARK: Methods
    
    //MARK: front end related
    private func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 48/255, green: 25/255, blue: 52/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 48/255, green: 25/255, blue: 52/255, alpha: 1.0)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController = searchController
    }
    
    // Navigation bar for EventDetailsController
    private func setupDetailControllerNavBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor(red: 48/255, green: 25/255, blue: 52/255, alpha: 1.0)
        self.view.addSubview(eventsTableView)
        
        if #available(iOS 10.0, *) {
            eventsTableView.refreshControl = refreshControl
        } else {
            eventsTableView.addSubview(refreshControl)
        }
        
        NSLayoutConstraint.activate([
            eventsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            eventsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            eventsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            eventsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    //MARK: Back end related
    private func getEvents() {
        networkManager.getEvents() { result in
            switch result {
            case let .success(pulledEvents):
                self.events = pulledEvents
                DispatchQueue.main.async {
                    self.eventsTableView.reloadData()
                }
                self.refreshControl.endRefreshing()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @objc func refreshEventsTable() {
        getEvents()
    }
}

//MARK: Extensions

//MARK: UITableView
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
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                cell.details = event
                if self.favoriteEvents.contains("\(event.id)") {
                    cell.favoriteButtonImageView.isHidden = false
                }
            }
        }
        return cell
    }
}

//MARK: UISearchBar
extension HomeTableController: UISearchBarDelegate {
    
    // Method that repopulates cells in the table view based on what the search text is
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredEvents = []
        
        if searchText.isEmpty {
            filteredEvents = events
        } else {
            for event in events {
                if event.short_title.lowercased().contains(searchText.lowercased()) ||
                    event.venue.city.lowercased().contains(searchText.lowercased()) ||
                    event.venue.state.lowercased().contains(searchText.lowercased()) {
                    filteredEvents.append(event)
                }
            }
            events = filteredEvents
        }
        self.eventsTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getEvents()
    }
}
