//
//  DashboardViewController.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit
import HealthKit
import WidgetKit

class DashboardViewController: UIViewController {
    
    var healthStore: HealthStore?

    // MARK: - UI Properties
    
    private var contentView: MainContentView!
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        contentView = MainContentView()
        view = contentView
        
        WidgetCenter.shared.reloadAllTimelines()
        
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
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        contentView.dashboardCollectionView.dataCollectionView.dataSource = self
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
        case .weight:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.weight ?? 0.0)
        case .activeEnergy:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.activeEnergy ?? 0.0)
        case .steps:
            cell.configureCell(dataType: array[indexPath.row], data: healthStore?.stepCount ?? 0.0)
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
        userDefaults?.setValue(sleep, forKey: "sleep")
        userDefaults?.setValue(weight, forKey: "weight")
        userDefaults?.setValue(activeEnergy, forKey: "activeEnergy")
        userDefaults?.setValue(steps, forKey: "steps")
        
        DispatchQueue.main.async { [weak self] in
            self?.contentView.dashboardCollectionView.dataCollectionView.reloadData()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

