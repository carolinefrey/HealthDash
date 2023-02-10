//
//  DashboardViewController.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit
import HealthKit
import WidgetKit

enum UserDefaultsKey: String {
    case sleep = "sleep"
    case weight = "weight"
    case activeEnergy = "activeEnergy"
    case steps = "steps"
}

class DashboardViewController: UIViewController {
    
    var healthStore: HealthStore?
    
    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")

    // MARK: - UI Properties
    
    private var contentView: MainContentView!
    
    lazy var settingsButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title3)
        let icon = UIImage(systemName: "gear", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(presentSettingsView))
        button.tintColor = UIColor(named: "Navy")
        return button
    }()
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        navigationItem.rightBarButtonItem = settingsButton

        contentView = MainContentView()
        view = contentView
        
        configureCollectionView()
        contentView.greetingView.configureGreeting()
                
        healthStore = HealthStore()
        
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
        
        healthStore?.getHealthData()
        
        let sleep = healthStore?.sleepDuration
        let weight = healthStore?.weight
        let activeEnergy = healthStore?.activeEnergy
        let steps = healthStore?.stepCount
        
        //send data to shared app group (so widget can access)
        userDefaults?.setValue(sleep, forKey: "sleep")
        userDefaults?.setValue(weight, forKey: "weight")
        userDefaults?.setValue(activeEnergy, forKey: "activeEnergy")
        userDefaults?.setValue(steps, forKey: "steps")
        
        DispatchQueue.main.async { [weak self] in
            self?.contentView.dashboardCollectionView.dataCollectionView.reloadData()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        contentView.dashboardCollectionView.dataCollectionView.dataSource = self
    }
    
    @objc func presentSettingsView() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        present(settingsVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DashboardCollectionViewCell.dashboardCollectionViewCellIdentifier, for: indexPath) as! DashboardCollectionViewCell

        var array = [Data]()
        Data.allCases.forEach { data in
            array.append(data)
        }
        
        switch array[indexPath.row] {
        case .sleep:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.sleepDuration ?? 0.0)
            cell.configureProgressBars(dataType: array[indexPath.row], data: healthStore?.sleepDuration ?? 0.0)
        case .weight:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.weight ?? 0.0)
            cell.configureProgressBars(dataType: array[indexPath.row], data: healthStore?.weight ?? 0.0)
        case .activeEnergy:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.activeEnergy ?? 0.0)
            cell.configureProgressBars(dataType: array[indexPath.row], data: healthStore?.activeEnergy ?? 0.0)
        case .steps:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.stepCount ?? 0.0)
            cell.configureProgressBars(dataType: array[indexPath.row], data: healthStore?.stepCount ?? 0.0)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        header.configure()
        header.delegate = self
        return header
    }
}

// MARK: - HeaderCollectionReusableViewDelegate

extension DashboardViewController: HeaderCollectionReusableViewDelegate {
    func tapRefreshDataButton() {
        
        let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
        
        healthStore?.getHealthData()
        
        let sleep = healthStore?.sleepDuration
        let weight = healthStore?.weight
        let activeEnergy = healthStore?.activeEnergy
        let steps = healthStore?.stepCount
        
        //send data to shared app group (so widget can access)
        userDefaults?.setValue(sleep, forKey: UserDefaultsKey.sleep.rawValue)
        userDefaults?.setValue(weight, forKey: UserDefaultsKey.weight.rawValue)
        userDefaults?.setValue(activeEnergy, forKey: UserDefaultsKey.activeEnergy.rawValue)
        userDefaults?.setValue(steps, forKey: UserDefaultsKey.steps.rawValue)
        
        DispatchQueue.main.async { [weak self] in
            self?.contentView.dashboardCollectionView.dataCollectionView.reloadData()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

// MARK: - SetTargetsDelegate

extension DashboardViewController: SetTargetsDelegate {
    func didUpdateTargets(targetSleep: Double, targetWeight: Double, targetCalories: Double, targetSteps: Double) {
        contentView.dashboardCollectionView.dataCollectionView.reloadData()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
