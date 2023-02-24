//
//  DashboardCollectionViewCell.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit
import SwiftUI

enum Data: CaseIterable {
    case sleep, weight, activeEnergy, steps
}

class DashboardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    static let dashboardCollectionViewCellIdentifier = "DashboardCollectionViewCell"
    
    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
    
    lazy var host: UIHostingController = {
        return UIHostingController(rootView: SwiftUICell())
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func embed(in parent: UIViewController) {
        parent.addChild(host)
        host.didMove(toParent: parent)
    }
    
    deinit {
        host.willMove(toParent: nil)
        host.view.removeFromSuperview()
        host.removeFromParent()
    }
    
    func configureCell(dataType: Data, data: Double) {
//        switch dataType {
//        case .sleep:
//            icon.image = UIImage(systemName: "bed.double.fill")
//
//            //convert seconds to hours & minutes
//            let secondsInAnHour = 3600.0
//            let hours = data / secondsInAnHour
//            let remainder = hours.truncatingRemainder(dividingBy: 1)
//            let minutesRemaining = remainder * 60
//            let hoursFormatted = String(format: "%.0f", hours)
//            let minutes = String(format: "%.0f", minutesRemaining)
//
//            if data == 0 {
//                dataText.text = "no data"
//            } else {
//                dataText.text = "\(hoursFormatted) hrs \(minutes) min"
//                dataLabel.text = "in bed"
//            }
//            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetSleep.rawValue) ?? 0.0)
//            circularProgressView.progress = Float(data / target)
//        case .weight:
//            icon.image = UIImage(systemName: "figure.arms.open")
//            if data == 0 {
//                dataText.text = "no data"
//            } else {
//                dataText.text = "\(data)"
//                dataLabel.text = "pounds"
//            }
//            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetWeight.rawValue) ?? 0.0)
//            circularProgressView.progress = Float(data / target)
//        case .activeEnergy:
//            icon.image = UIImage(systemName: "flame.fill")
//            let formattedValue = String(format: "%.0f", data)
//
//            if data == 0 {
//                dataText.text = "no data"
//            } else {
//                dataText.text = "\(formattedValue)"
//                dataLabel.text = "calories burned"
//            }
//            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetCalories.rawValue) ?? 0.0)
//            circularProgressView.progress = Float(data / target)
//        case .steps:
//            icon.image = UIImage(systemName: "shoeprints.fill")
//            let formattedValue = String(format: "%.0f", data)
//            if data == 0 {
//                dataText.text = "no data"
//            } else {
//                dataText.text = "\(formattedValue)"
//                dataLabel.text = "steps"
//            }
//            let target = Double(userDefaults?.double(forKey: UserDefaultsKey.targetSteps.rawValue) ?? 0.0)
//            circularProgressView.progress = Float(data / target)
//        }
    }

    // MARK: - UI Setup

    private func configureViews() {
        host.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(host.view)
        
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
