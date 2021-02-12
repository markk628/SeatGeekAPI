//
//  EventDetailsController.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import UIKit
import Kingfisher

enum Favorite: CaseIterable {
    case yes
    case no
}

protocol FavoriteObserver: class {
    func didFavorite(to favorite: Favorite)
}

class EventDetailsController: UIViewController, FavoriteObserver {
    
    //MARK: Properties
    private var favoriteEvents: [String] = UserDefaults.standard.stringArray(forKey: "Favorites") ?? [String]()
            
    var details: Event? {
        didSet {
            DispatchQueue.global(qos: .userInteractive).async {
                guard let details = self.details else { return }
                let imageUrl = URL(string: details.performers.first!.image)
                DispatchQueue.main.async {
                    self.eventImageView.kf.setImage(with: imageUrl)
                    self.title = details.short_title
                    let splitDateAndTime = details.datetime_utc.components(separatedBy: "T")
                    self.dateAndTimeLabel.text = "\(AppService.formatDate(date: splitDateAndTime.first!)) \(AppService.formatTime(time: splitDateAndTime.last!))"
                    self.locationLabel.text = "\(details.venue.city), \(details.venue.state)"
                }
            }
        }
    }
    
    //MARK: Views
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateAndTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButtonImage: UIImage = {
        var image = UIImage()
        if favoriteEvents.contains("\(details!.id)") {
            image = UIImage(systemName: "heart.fill")!
        } else {
            image = UIImage(systemName: "heart")!
        }
        return image
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteButtonImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteButtonImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
    }
    
    //MARK: Methods
    
    //MARK: Front end related
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(eventImageView)
        self.view.addSubview(dateAndTimeLabel)
        self.view.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            eventImageView.heightAnchor.constraint(equalToConstant: 200),
            
            dateAndTimeLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 20),
            dateAndTimeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dateAndTimeLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dateAndTimeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            locationLabel.topAnchor.constraint(equalTo: dateAndTimeLabel.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    //MARK: Back end related
    internal func didFavorite(to favorite: Favorite) {
        if favorite == .yes {
            favoriteButtonImage = UIImage(systemName: "heart.fill")!
        } else if favorite == .no {
            favoriteButtonImage = UIImage(systemName: "heart")!
        }
    }
    
    @objc func favoriteButtonTapped() {
        let defaults = UserDefaults.standard
        if favoriteEvents.contains("\(details!.id)") {
            let newFavoriteEvents = favoriteEvents.filter { $0 != "\(details!.id)"}
            defaults.set(newFavoriteEvents, forKey: "Favorites")
            didFavorite(to: .no)
            print("removed from favorites")
        } else {
            
            favoriteEvents.append("\(details!.id)")
            defaults.set(favoriteEvents, forKey: "Favorites")
            didFavorite(to: .yes)
            print("added to favorites")
        }
    }

}




