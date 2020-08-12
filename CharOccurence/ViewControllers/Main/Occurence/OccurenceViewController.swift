//
//  OccurenceViewController.swift
//  CharOccurence
//
//  Created by Oleksii Kaharov on 10.08.2020.
//  Copyright © 2020 hialex. All rights reserved.
//

import UIKit

class OccurenceViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var generatedTextHeader: UIView!
    @IBOutlet weak var generatedTextHeaderButton: UIButton!
    
    // MARK: - Variables
    var viewModel: OccurenceViewModel = OccurenceViewModel()
    var isTextVisible: Bool = true {
        didSet {
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    // MARK: - VC Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCustomNib()
    }
    
    // MARK: - Functions
    private func registerCustomNib() {
        tableView.register(UINib(nibName: CharsOccurenceHeader.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: CharsOccurenceHeader.identifier)
        tableView.register(UINib(nibName: TextHeaderView.identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: TextHeaderView.identifier)
    }
    
    // MARK: - IBActions
    @IBAction func onLogoutTapped(_ sender: UIBarButtonItem) {
        viewModel.logout(success: {
            self.performSegue(withIdentifier: Segues.ToAuth, sender: self)
        }, failure: { (error) in
            self.present(ErrorAlertManager.shared.alert(error), animated: true, completion: nil)
        })
    }
    
    @IBAction func onGenerateTextTapped(_ sender: UIButton) {
        viewModel.getText(locale: viewModel.selectedLocale, success: {
            self.tableView.reloadSections(IndexSet(integersIn: 1...2), with: .automatic)
        }, failure: { (error) in
            self.present(ErrorAlertManager.shared.alert(error), animated: true, completion: nil)
        })
    }
}

extension OccurenceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return (viewModel.generatedText.count > 1 && isTextVisible) ? 1 : 0
        case 2: return viewModel.charsOccurency.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocaleTableViewCell.identifier, for: indexPath) as? LocaleTableViewCell else { return UITableViewCell() }
            
            cell.localePicker.delegate = self
            
            cell.localePicker.text = viewModel.selectedLocale
            
            let localePicker = UIPickerView()
            localePicker.delegate = self
            localePicker.dataSource = self
            
            var toolBar: UIToolbar {
                let bar = UIToolbar()
                let reset = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
                reset.tintColor = CustomColors.BlackToWhite
                let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                bar.items = [flexButton, reset]
                bar.sizeToFit()
                return bar
            }
            
            cell.localePicker.inputAccessoryView = toolBar
            cell.localePicker.inputView = localePicker
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            
            cell.generatedTextLabel.text = viewModel.generatedText
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CharTableViewCell.identifier, for: indexPath) as? CharTableViewCell else { return UITableViewCell() }
            
            if let dict = viewModel.charsOccurency[indexPath.row].first {
                cell.charLabel.text = "Char \" " + String(dict.key) + " \""
                cell.occurenceLabel.text = String(dict.value) + " times"
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension OccurenceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2: return (viewModel.generatedText.count > 1 && viewModel.charsOccurency.count > 0) ? 30 : 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TextHeaderView.identifier) as? TextHeaderView else { return nil }
            header.generatedTextHeaderButton.setTitle(isTextVisible ? "Hide generated text" : "Show generated text", for: .normal)
            header.delegate = self
            
            return header
        case 2:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CharsOccurenceHeader.identifier) as? CharsOccurenceHeader else { return nil }
            
            return header
            
        default: return nil
        }
    }
}

extension OccurenceViewController: UITextFieldDelegate {
    
}

extension OccurenceViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LocaleTableViewCell else { return }
        
        viewModel.selectedLocale = viewModel.locales[row]
        cell.localePicker.text = viewModel.selectedLocale
    }
}

extension OccurenceViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.locales.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.locales[row]
    }
}

extension OccurenceViewController {
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension OccurenceViewController: TextHeaderViewDelegate {
    func showTextTapped() {
        isTextVisible.toggle()
    }
}
