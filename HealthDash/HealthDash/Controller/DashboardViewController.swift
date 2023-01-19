//
//  DashboardViewController.swift
//  HealthDash
//
//  Created by Caroline Frey on 1/11/23.
//

import UIKit
import HealthKit

class DashboardViewController: UIViewController {
    
    private var healthStore: HealthStore?
    var stepCount = 0.0
    var weight = 0.0
    var sleepDuration = 0.0
    var activeEnergy = 0.0

    // MARK: - UI Properties
    
    private var contentView: MainContentView!
    
    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

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
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        contentView.dashboardCollectionView.dataCollectionView.dataSource = self
    }
    
    func getHealthData() {
        healthStore?.calculateSteps { steps in
            if steps > 0 {
                self.stepCount = steps
            }
        }
        
        healthStore?.retrieveWeight { weight in
            if weight > 0 {
                self.weight = weight
            }
        }
        
        healthStore?.calculateActiveEnergy { calories in
            if calories > 0 {
                self.activeEnergy = calories
            }
        }
        
        healthStore?.calculateSleep { duration in
            if duration > 0 {
                self.sleepDuration = duration
            }
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
            cell.configureCell(dataType: array[indexPath.row], data: sleepDuration)
        case .weight:
            cell.configureCell(dataType: array[indexPath.row], data: weight)
        case .activeEnergy:
            cell.configureCell(dataType: array[indexPath.row], data: activeEnergy)
        case .steps:
            cell.configureCell(dataType: array[indexPath.row], data: stepCount)
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
        getHealthData()
        DispatchQueue.main.async { [weak self] in
            self?.contentView.dashboardCollectionView.dataCollectionView.reloadData()
        }
    }
}

