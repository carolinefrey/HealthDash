//
//  DashboardTableViewCell.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit
import SwiftUI

enum Data: CaseIterable {
    case sleep, weight, activeEnergy, steps
}

class DashboardTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    
    static let dashboardTableViewCellIdentifier = "DashboardTableViewCell"
    
    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
    
    let circularProgressView: CircularProgressView = {
        let progress = CircularProgressView(frame: CGRect(x: 10, y: 10, width: 120, height: 120), lineWidth: 10, rounded: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progressColor = UIColor(named: "Navy")!
        progress.trackColor = UIColor(named: "TrackColor")!
        return progress
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
        text.font = UIFont(name: "Oxygen-Regular", size: 26)
        text.adjustsFontSizeToFitWidth = true
        return text
    }()
    
    let dataLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.textColor = UIColor(named: "Navy")
        text.font = UIFont(name: "Oxygen-Regular", size: 14)
        return text
    }()
    
    var metricHistoryGraph = UIView()

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetSleep.rawValue) ?? 0.0)
            circularProgressView.progress = Float(data / target)
        case .weight:
            icon.image = UIImage(systemName: "figure.arms.open")
            if data == 0 {
                dataText.text = "no data"
            } else {
                dataText.text = "\(data)"
                dataLabel.text = "pounds"
            }
            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetWeight.rawValue) ?? 0.0)
            circularProgressView.progress = Float(data / target)
            
        case .activeEnergy:
            icon.image = UIImage(systemName: "flame.fill")
            let formattedValue = String(format: "%.0f", data)

            if data == 0 {
                dataText.text = "no data"
            } else {
                dataText.text = "\(formattedValue)"
                dataLabel.text = "calories burned"
            }
            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetCalories.rawValue) ?? 0.0)
            circularProgressView.progress = Float(data / target)
        case .steps:
            icon.image = UIImage(systemName: "shoeprints.fill")
            let formattedValue = String(format: "%.0f", data)
            if data == 0 {
                dataText.text = "no data"
            } else {
                dataText.text = "\(formattedValue)"
                dataLabel.text = "steps"
            }
            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetSteps.rawValue) ?? 0.0)
            circularProgressView.progress = Float(data / target)
        }
    }
    
    func configureGraphs(dataType: Data) {
        switch dataType {
        case .sleep:
            let data = userDefaults?.object(forKey: UserDefaultsKey.sleepHistory.rawValue) as? [Double] ?? [Double]()
            let sleepHistoryGraph = UIHostingController(rootView: HealthMetricHistory(dataHistory: data))
            metricHistoryGraph = sleepHistoryGraph.view
        case .weight:
            let data = userDefaults?.object(forKey: UserDefaultsKey.weightHistory.rawValue) as? [Double] ?? [Double]()
            let weightHistoryGraph = UIHostingController(rootView: HealthMetricHistory(dataHistory: data))
            metricHistoryGraph = weightHistoryGraph.view
        case .activeEnergy:
            let data = userDefaults?.object(forKey: UserDefaultsKey.activeEnergyHistory.rawValue) as? [Double] ?? [Double]()
            let calorieHistoryGraph = UIHostingController(rootView: HealthMetricHistory(dataHistory: data))
            metricHistoryGraph = calorieHistoryGraph.view
        case .steps:
            let data = userDefaults?.object(forKey: UserDefaultsKey.stepsHistory.rawValue) as? [Double] ?? [Double]()
            let stepsHistoryGraph = UIHostingController(rootView: HealthMetricHistory(dataHistory: data))
            metricHistoryGraph = stepsHistoryGraph.view
        }
    }

    // MARK: - UI Setup

    private func configureViews() {
        addSubview(circularProgressView)
        addSubview(icon)
        addSubview(dataText)
        addSubview(dataLabel)
        addSubview(metricHistoryGraph)
        metricHistoryGraph.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            circularProgressView.topAnchor.constraint(equalTo: topAnchor),
            circularProgressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            circularProgressView.widthAnchor.constraint(equalToConstant: 140),
            circularProgressView.heightAnchor.constraint(equalToConstant: 140),
            
            icon.topAnchor.constraint(equalTo: circularProgressView.topAnchor, constant: 25),
            icon.centerXAnchor.constraint(equalTo: circularProgressView.centerXAnchor),
            icon.heightAnchor.constraint(equalToConstant: 25),
            icon.widthAnchor.constraint(equalToConstant: 25),

            dataText.centerXAnchor.constraint(equalTo: circularProgressView.centerXAnchor),
            dataText.centerYAnchor.constraint(equalTo: circularProgressView.centerYAnchor),
            dataText.leadingAnchor.constraint(equalTo: circularProgressView.leadingAnchor, constant: 20),
            dataText.trailingAnchor.constraint(equalTo: circularProgressView.trailingAnchor, constant: -20),

            dataLabel.centerXAnchor.constraint(equalTo: circularProgressView.centerXAnchor),
            dataLabel.topAnchor.constraint(equalTo: dataText.bottomAnchor),
            
            metricHistoryGraph.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            metricHistoryGraph.leadingAnchor.constraint(equalTo: circularProgressView.trailingAnchor, constant: 25),
            metricHistoryGraph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            metricHistoryGraph.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
