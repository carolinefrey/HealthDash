//
//  HeaderCollectionReusableView.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/19/23.
//

import UIKit

protocol HeaderCollectionReusableViewDelegate: AnyObject {
    func tapRefreshDataButton()
}

class HeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - UI Properties
    
    static let identifier = "HeaderCollectionReusableView"
    
    weak var delegate: HeaderCollectionReusableViewDelegate?

//    private let headerLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont(name: "Oxygen-Regular", size: 24)
//        label.text = "Today"
//        label.textAlignment = .left
//        label.textColor = UIColor(named: "Navy")
//        return label
//    }()
    
    lazy var refreshButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 44, weight: .light)
        let icon = UIImage(systemName: "arrow.clockwise.heart", withConfiguration: config)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: "Navy")
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(refreshHealthData), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Selector Function
    
    @objc func refreshHealthData(_ sender: UIButton) {
        delegate?.tapRefreshDataButton()
    }
    
    // MARK: - UISetup
    
    public func configure() {
//        addSubview(headerLabel)
        addSubview(refreshButton)
        
        NSLayoutConstraint.activate([
//            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
//            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            refreshButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}
