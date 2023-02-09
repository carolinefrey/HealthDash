//
//  SettingsViewController.swift
//  HealthDash
//
//  Created by Caroline Frey on 2/8/23.
//

import UIKit

protocol SetTargetsDelegate: AnyObject {
    func didUpdateTargets(targetSleep: Double, targetWeight: Double, targetCalories: Double, targetSteps: Double)
}

class SettingsViewController: UIViewController {

    weak var delegate: SetTargetsDelegate?
    
    let userDefaults = UserDefaults(suiteName: "group.healthDashWidgetCache")
    
    // MARK: - UI Properties
    
    private var contentView = SettingsView()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = contentView
        contentView.targetSleepTextView.delegate = self
        contentView.targetWeightTextView.delegate = self
        contentView.targetCaloriesTextView.delegate = self
        contentView.targetStepsTextView.delegate = self
        contentView.saveSettingsButton.addTarget(self, action: #selector(saveTargets), for: .touchUpInside)
    }
    
    // MARK: - Functions

    @objc func saveTargets() {
        let targetSleep = Double(contentView.targetSleepTextView.text ?? "")
        let targetWeight = Double(contentView.targetWeightTextView.text ?? "")
        let targetCalories = Double(contentView.targetCaloriesTextView.text ?? "")
        let targetSteps = Double(contentView.targetStepsTextView.text ?? "")
        userDefaults?.set(targetSleep, forKey: "targetSleep")
        userDefaults?.set(targetWeight, forKey: "targetWeight")
        userDefaults?.set(targetCalories, forKey: "targetCalories")
        userDefaults?.set(targetSteps, forKey: "targetSteps")
        dismiss(animated: true)
        self.delegate?.didUpdateTargets(targetSleep: targetSleep ?? 0.0, targetWeight: targetWeight ?? 0.0, targetCalories: targetCalories ?? 0.0, targetSteps: targetSteps ?? 0.0)
    }
}

// MARK: - UITextFieldViewDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
