//
//  GraphViewController.swift
//  HealthMetricDash
//
//  Created by Caroline Frey on 2/15/23.
//

import UIKit
import SwiftUI

class GraphViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - UI Setup

    private func configureViews() {
        let weightViewController = UIHostingController(rootView: WeightHistoryView())
        guard let weightGraphView = weightViewController.view else {
            return
        }
        
        let stepsViewController = UIHostingController(rootView: StepsHistoryView())
        guard let stepsGraphView = stepsViewController.view else {
            return
        }
        
        let activeEnergyViewController = UIHostingController(rootView: ActiveEnergyHistoryView())
        guard let activeEnergyGraphView = activeEnergyViewController.view else {
            return
        }
        
        let sleepViewController = UIHostingController(rootView: SleepHistoryView())
        guard let sleepGraphView = sleepViewController.view else {
            return
        }
        
        view.addSubview(weightGraphView)
        weightGraphView.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(stepsViewController)
        view.addSubview(stepsGraphView)
        stepsGraphView.translatesAutoresizingMaskIntoConstraints = false
        stepsViewController.didMove(toParent: self)
        
        addChild(activeEnergyViewController)
        view.addSubview(activeEnergyGraphView)
        activeEnergyGraphView.translatesAutoresizingMaskIntoConstraints = false
        activeEnergyViewController.didMove(toParent: self)
        
        addChild(sleepViewController)
        view.addSubview(sleepGraphView)
        sleepGraphView.translatesAutoresizingMaskIntoConstraints = false
        sleepViewController.didMove(toParent: self)
    
        NSLayoutConstraint.activate([
            weightGraphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weightGraphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightGraphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weightGraphView.heightAnchor.constraint(equalToConstant: 300),
            
            stepsGraphView.topAnchor.constraint(equalTo: weightGraphView.bottomAnchor),
            stepsGraphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stepsGraphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stepsGraphView.heightAnchor.constraint(equalToConstant: 300),
            
            activeEnergyGraphView.topAnchor.constraint(equalTo: stepsGraphView.bottomAnchor),
            activeEnergyGraphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activeEnergyGraphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activeEnergyGraphView.heightAnchor.constraint(equalToConstant: 300),
            
            sleepGraphView.topAnchor.constraint(equalTo: activeEnergyGraphView.bottomAnchor),
            sleepGraphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sleepGraphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sleepGraphView.heightAnchor.constraint(equalToConstant: 300),
            
            
            view.heightAnchor.constraint(equalToConstant: 1500)
//            view.bottomAnchor.constraint(equalTo: sleepGraphView.bottomAnchor),
        ])
    }

}
