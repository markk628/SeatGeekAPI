//
//  HomeEventsTableCell.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import UIKit
import Kingfisher

class HomeEventsTableCell: UITableViewCell {
    
    //MARK: Properties
    static var identifier: String = "HomeEventsCell"
    
    var details: Event? {
        didSet {
            guard let details = details else { return }
            let imageUrl = URL(string: details.performers.first!.image)
            eventImageView.kf.setImage(with: imageUrl)
            self.titleLabel.text = details.short_title
            self.locationLabel.text = "\(details.venue.city), \(details.venue.state)"
            let splitDateAndTime = details.datetime_utc.components(separatedBy: "T")
            self.dateLabel.text = AppService.formatDate(date: splitDateAndTime.first!)
            self.timeLabel.text = AppService.formatTime(time: splitDateAndTime.last!)
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
    
    private let titleAndDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationDateTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateAndTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setting up the views
    private func setupViews() {
        selectionStyle = .gray
        self.addSubview(eventImageView)
        self.addSubview(titleAndDescriptionStackView)

        [titleLabel, locationDateTimeStackView].forEach {
            titleAndDescriptionStackView.addArrangedSubview($0)
        }

        [locationLabel, dateAndTimeStackView].forEach {
            locationDateTimeStackView.addArrangedSubview($0)
        }

        [dateLabel, timeLabel].forEach {
            dateAndTimeStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            eventImageView.heightAnchor.constraint(equalToConstant: 80),
            eventImageView.widthAnchor.constraint(equalTo: eventImageView.heightAnchor),
            eventImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            eventImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            titleAndDescriptionStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleAndDescriptionStackView.leadingAnchor.constraint(equalTo: self.eventImageView.trailingAnchor, constant: 20),
            titleAndDescriptionStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleAndDescriptionStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            titleLabel.heightAnchor.constraint(equalTo: titleAndDescriptionStackView.heightAnchor, multiplier: 0.5),
            locationDateTimeStackView.heightAnchor.constraint(equalTo: titleAndDescriptionStackView.heightAnchor, multiplier: 0.5),
            
            locationLabel.heightAnchor.constraint(equalTo: locationDateTimeStackView.heightAnchor, multiplier: 0.5),
            dateAndTimeStackView.heightAnchor.constraint(equalTo: locationDateTimeStackView.heightAnchor, multiplier: 0.5),
            
            dateLabel.heightAnchor.constraint(equalTo: dateAndTimeStackView.heightAnchor, multiplier: 0.5),
            timeLabel.heightAnchor.constraint(equalTo: dateAndTimeStackView.heightAnchor, multiplier: 0.5)
        ])
    }
}
