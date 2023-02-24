//
//  DashboardViewController.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit
import SwiftUI
import HealthKit
import WidgetKit

enum UserDefaultsKey: String {
    case sleep = "sleep"
    case weight = "weight"
    case activeEnergy = "activeEnergy"
    case steps = "steps"
    case targetSleep = "targetSleep"
    case targetWeight = "targetWeight"
    case targetCalories = "targetCalories"
    case targetSteps = "targetSteps"
    case sleepHistory = "sleepHistory"
    case weightHistory = "weightHistory"
    case activeEnergyHistory = "activeEnergyHistory"
    case stepsHistory = "stepsHistory"
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
    
    lazy var refreshButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title3)
        let icon = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(tapRefreshDataButton))
        button.tintColor = UIColor(named: "Navy")
        return button
    }()
    
    lazy var viewGraphButton: UIBarButtonItem = {
        let config = UIImage.SymbolConfiguration(textStyle: .title3)
        let icon = UIImage(systemName: "chart.line.uptrend.xyaxis", withConfiguration: config)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(presentGraphView))
        button.tintColor = UIColor(named: "Navy")
        return button
    }()
        
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        navigationItem.leftBarButtonItem = viewGraphButton
        navigationItem.rightBarButtonItems = [refreshButton, settingsButton]

        contentView = MainContentView()
        view = contentView
        
        contentView.dashboardCollectionView.dataSource = self
//        contentView.dashboardCollectionView.reloadData()
        
        healthStore = HealthStore()
        
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
    }
    
    // MARK: - Functions

    @objc func presentSettingsView() {
        let settingsVC = SettingsViewController()
        settingsVC.delegate = self
        present(settingsVC, animated: true)
    }
    
    @objc func tapRefreshDataButton() {
       refreshData()
    }
    
    @objc func presentGraphView() {
        let graphVC = GraphViewController()
        present(graphVC, animated: true)
    }
    
    private func refreshData() {
        let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
        
        healthStore?.getHealthData()
        healthStore?.getHealthDataHistory()
        
        let sleep = healthStore?.sleepDuration
        let weight = healthStore?.weight
        let activeEnergy = healthStore?.activeEnergy
        let steps = healthStore?.stepCount
        
        let sleepHistory: [Double] = healthStore?.sleepDurationHistory ?? []
        let weightHistory: [Double] = healthStore?.weightHistory ?? []
        let activeEnergyHistory: [Double] = healthStore?.activeEnergyHistory ?? []
        let stepsHistory: [Double] = healthStore?.stepCountHistory ?? []
        
        //send data to shared app group (so widget can access)
        userDefaults?.setValue(sleep, forKey: UserDefaultsKey.sleep.rawValue)
        userDefaults?.setValue(weight, forKey: UserDefaultsKey.weight.rawValue)
        userDefaults?.setValue(activeEnergy, forKey: UserDefaultsKey.activeEnergy.rawValue)
        userDefaults?.setValue(steps, forKey: UserDefaultsKey.steps.rawValue)
        
        userDefaults?.set(sleepHistory, forKey: UserDefaultsKey.sleepHistory.rawValue)
        userDefaults?.set(weightHistory, forKey: UserDefaultsKey.weightHistory.rawValue)
        userDefaults?.set(activeEnergyHistory, forKey: UserDefaultsKey.activeEnergyHistory.rawValue)
        userDefaults?.set(stepsHistory, forKey: UserDefaultsKey.stepsHistory.rawValue)
        
        DispatchQueue.main.async { [weak self] in
            self?.contentView.dashboardCollectionView.reloadData()
            WidgetCenter.shared.reloadAllTimelines()
        }
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
//            cell.configureGraphs(dataType: array[indexPath.row], data: healthStore?.sleepDurationHistory ?? [])
        case .weight:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.weight ?? 0.0)
//            cell.configureGraphs(dataType: array[indexPath.row], data: healthStore?.weightHistory ?? [])
        case .activeEnergy:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.activeEnergy ?? 0.0)
//            cell.configureGraphs(dataType: array[indexPath.row], data: healthStore?.activeEnergyHistory ?? [])
        case .steps:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.stepCount ?? 0.0)
//            cell.configureGraphs(dataType: array[indexPath.row], data: healthStore?.stepCountHistory ?? [])
        }
        return cell
    }
}

// MARK: - SetTargetsDelegate

extension DashboardViewController: SetTargetsDelegate {
    func didUpdateTargets(targetSleep: Double, targetWeight: Double, targetCalories: Double, targetSteps: Double) {
        contentView.dashboardCollectionView.reloadData()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
