//
//  EventDetailsController.swift
//  SeatGeekAPI
//
//  Created by Mark Kim on 2/11/21.
//

import UIKit

class EventDetailsController: UIViewController {
    
    let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let dateAndTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "somedate"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "someplace"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupViews()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
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
