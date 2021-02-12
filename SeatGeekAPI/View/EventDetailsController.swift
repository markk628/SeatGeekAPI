//
//  EventDetailsController.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import UIKit
import Kingfisher

class EventDetailsController: UIViewController {
    
    var details: Event? {
        didSet {
            guard let details = details else { return }
            let imageUrl = URL(string: details.performers.first!.image)
            eventImageView.kf.setImage(with: imageUrl)
            self.title = details.short_title
            let splitDateAndTime = details.datetime_utc.components(separatedBy: "T")
            self.dateAndTimeLabel.text = "\(AppService.formatDate(date: splitDateAndTime.first!)) \(AppService.formatTime(time: splitDateAndTime.last!))"
            self.locationLabel.text = "\(details.venue.city), \(details.venue.state)"
        }
    }
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dateAndTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
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

}




