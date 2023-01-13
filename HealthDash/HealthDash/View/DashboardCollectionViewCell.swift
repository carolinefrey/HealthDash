//
//  DashboardCollectionViewCell.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit

enum Data: CaseIterable {
    case sleep, weight, activeEnergy, steps
}

class DashboardCollectionViewCell: UICollectionViewCell {

    // MARK: - UI Properties
    
    static let dashboardCollectionViewCellIdentifier = "DashboardCollectionViewCell"
    
    let backgroundCell: UIView = {
        let cell = UIView()
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundColor = .white
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 20
        return cell
    }()
    
    let icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = UIColor(named: "Navy")
        return icon
    }()
    
    let dataText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "123"
        text.textAlignment = .center
        text.textColor = UIColor(named: "Navy")
        text.font = UIFont(name: "Oxygen-Regular", size: 36)
        return text
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureCell(dataType: Data, data: Double) {
        switch dataType {
        case .sleep:
            icon.image = UIImage(systemName: "bed.double.fill")
            dataText.text = "\(data)"
        case .weight:
            icon.image = UIImage(systemName: "figure.arms.open")
            dataText.text = "\(data)"
        case .activeEnergy:
            icon.image = UIImage(systemName: "flame.fill")
            dataText.text = "\(data)"
        case .steps:
            icon.image = UIImage(systemName: "shoeprints.fill")
            dataText.text = "\(data)"
        }
    }

    
    // MARK: - UI Setup

    private func configureViews() {
        addSubview(backgroundCell)
        addSubview(icon)
        addSubview(dataText)
        
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            icon.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            icon.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 5),
            icon.heightAnchor.constraint(equalToConstant: 35),
            icon.widthAnchor.constraint(equalToConstant: 35),
            
            dataText.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            dataText.centerXAnchor.constraint(equalTo: backgroundCell.centerXAnchor),
        ])
    }
}
