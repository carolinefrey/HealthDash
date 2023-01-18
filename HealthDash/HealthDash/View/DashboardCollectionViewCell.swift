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
        text.textAlignment = .center
        text.textColor = UIColor(named: "Navy")
        text.font = UIFont(name: "Oxygen-Regular", size: 36)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    let dataLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.textColor = UIColor(named: "Navy")
        text.font = UIFont(name: "Oxygen-Regular", size: 18)
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
            
            //convert seconds to hours & minutes
            let secondsInAnHour = 3600.0
            let hours = data / secondsInAnHour
            let remainder = hours.truncatingRemainder(dividingBy: 1)
            let minutesRemaining = remainder * 60
            let hoursFormatted = String(format: "%.0f", hours)
            let minutes = String(format: "%.0f", minutesRemaining)
            
            dataText.text = "\(hoursFormatted) hrs \(minutes) min"
            dataLabel.text = "in bed"
        case .weight:
            icon.image = UIImage(systemName: "figure.arms.open")
            dataText.text = "\(data)"
            dataLabel.text = "pounds"
        case .activeEnergy:
            icon.image = UIImage(systemName: "flame.fill")
            let formattedValue = String(format: "%.0f", data)
            dataText.text = "\(formattedValue)"
            dataLabel.text = "calories burned"
        case .steps:
            icon.image = UIImage(systemName: "shoeprints.fill")
            let formattedValue = String(format: "%.0f", data)
            dataText.text = "\(formattedValue)"
            dataLabel.text = "steps"
        }
    }

    
    // MARK: - UI Setup

    private func configureViews() {
        addSubview(backgroundCell)
        addSubview(icon)
        addSubview(dataText)
        addSubview(dataLabel)
        
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            icon.topAnchor.constraint(equalTo: backgroundCell.topAnchor, constant: 10),
            icon.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 5),
            icon.heightAnchor.constraint(equalToConstant: 35),
            icon.widthAnchor.constraint(equalToConstant: 35),
            
            dataText.centerXAnchor.constraint(equalTo: backgroundCell.centerXAnchor),
            dataText.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            dataText.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 10),
            dataText.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10),
            
            dataLabel.centerXAnchor.constraint(equalTo: backgroundCell.centerXAnchor),
            dataLabel.topAnchor.constraint(equalTo: dataText.bottomAnchor),
        ])
    }
}
