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
    
    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
    
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
    
    let progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.trackTintColor = .red
        bar.tintColor = .green
        return bar
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
            
            if data == 0 {
                dataText.text = "no data"
            } else {
                dataText.text = "\(hoursFormatted) hrs \(minutes) min"
                dataLabel.text = "in bed"
            }
            configureProgressBars(dataType: .sleep, data: data)
        case .weight:
            icon.image = UIImage(systemName: "figure.arms.open")
            if data == 0 {
                dataText.text = "no data"
            } else {
                dataText.text = "\(data)"
                dataLabel.text = "pounds"
            }
            configureProgressBars(dataType: .weight, data: data)
        case .activeEnergy:
            icon.image = UIImage(systemName: "flame.fill")
            let formattedValue = String(format: "%.0f", data)
            
            if data == 0 {
                dataText.text = "no data"
            } else {
                dataText.text = "\(formattedValue)"
                dataLabel.text = "calories burned"
            }
            configureProgressBars(dataType: .activeEnergy, data: data)
        case .steps:
            icon.image = UIImage(systemName: "shoeprints.fill")
            let formattedValue = String(format: "%.0f", data)
            if data == 0 {
                dataText.text = "no data"
            } else {
                dataText.text = "\(formattedValue)"
                dataLabel.text = "steps"
            }
            configureProgressBars(dataType: .steps, data: data)
        }
    }

    func configureProgressBars(dataType: Data, data: Double) {
        var target = 0.0
        
        switch dataType {
        case .sleep:
            target = Double(userDefaults?.double(forKey: "targetSleep") ?? 0.0)
        case .weight:
            target = Double(userDefaults?.double(forKey: "targetWeight") ?? 0.0)
        case .activeEnergy:
            target = Double(userDefaults?.double(forKey: "targetCalories") ?? 0.0)
        case .steps:
            target = Double(userDefaults?.double(forKey: "targetSteps") ?? 0.0)
        }
        
        let progress = Float(data / target)
        progressBar.setProgress(progress, animated: false)
    }

    
    // MARK: - UI Setup

    private func configureViews() {
        addSubview(backgroundCell)
        addSubview(icon)
        addSubview(dataText)
        addSubview(dataLabel)
        addSubview(progressBar)
        
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
            
            progressBar.centerXAnchor.constraint(equalTo: backgroundCell.centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: dataLabel.bottomAnchor, constant: 20),
            progressBar.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -10)
        ])
    }
}
