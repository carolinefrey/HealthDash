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
    var stepCount = -1.0
    var weight = -1.0
    var sleepDuration = -1.0
    var activeEnergy = -1.0

    // MARK: - UI Properties
    
    private var contentView: MainContentView!

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
            
        contentView = MainContentView()
        view = contentView
        
        configureCollectionView()
        
        healthStore = HealthStore()
        
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                //TODO: more code here?
            }
        }
        getStepsData()
        getWeightData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        contentView.dashboardCollectionView.dataCollectionView.dataSource = self
    }
    
    func getStepsData() {
        healthStore?.calculateSteps(completion: { steps in
            if steps > 0 {
                self.stepCount = steps
            }
        })
    }
    
    func getWeightData() {
        healthStore?.retrieveWeight(completion: { weight in
            if weight > 0 {
                self.weight = weight
            }
        })
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
}

