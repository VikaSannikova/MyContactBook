//
//  AddContactViewController.swift
//  MyContactBook
//
//  Created by user on 01.04.2021.
//

import UIKit
import ContactsUI
import Contacts

class AddContactViewController: UIViewController {
    
    var titleText: String = "ADD NEW CONTACT"
    var contact: Contact? = nil
    var indexPath: IndexPath? = nil

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        if let editContact = contact {
            firstNameTextField.text = editContact.firstName
            lastNameTextField.text = editContact.lastName
            numberTextField.text = editContact.phone
        }
    }
    
    @IBAction func closeCancel(_ sender: UIButton) {
        if (titleLabel.text == "ADD NEW CONTACT") {
            firstNameTextField.text = nil
            lastNameTextField.text = nil
            numberTextField.text = nil
            performSegue(withIdentifier: "unwindToContactList", sender: self)
        } else if (titleLabel.text == "EDIT"){
            performSegue(withIdentifier: "backToDetails", sender: sender)
        }
    }
    
    @IBAction func saveAndClose(_ sender: UIButton) {
        if (titleLabel.text == "ADD NEW CONTACT") {
            performSegue(withIdentifier: "unwindToContactListAndSave", sender: self)
        } else if (titleLabel.text == "EDIT"){
            performSegue(withIdentifier: "backToDetailsAndSave", sender: self)
        }
        
    }
}


