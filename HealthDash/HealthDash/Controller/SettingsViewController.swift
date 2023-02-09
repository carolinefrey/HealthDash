//
//  SettingsViewController.swift
//  HealthDash
//
//  Created by Caroline Frey on 2/8/23.
//

import UIKit

protocol SetTargetsDelegate: AnyObject {
    func didUpdateTargets(targetSleep: String)
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
        contentView.saveSettingsButton.addTarget(self, action: #selector(saveTargets), for: .touchUpInside)
    }
    
    // MARK: - Functions

    @objc func saveTargets() {
        let targetSleep = contentView.targetSleepTextView.text ?? ""
        userDefaults?.set("\(targetSleep)", forKey: "targetSleep")
        dismiss(animated: true)
        self.delegate?.didUpdateTargets(targetSleep: targetSleep)
    }
}

// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
