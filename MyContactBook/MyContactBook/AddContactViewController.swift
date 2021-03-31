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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText
        if let editContact = contact {
            nameTextField.text = editContact.firstName
            numberTextField.text = editContact.phone
        }
    }
    
    @IBAction func closeCancel(_ sender: UIButton) {
        if (titleLabel.text == "ADD NEW CONTACT") {
            nameTextField.text = nil
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
//        let contact1 = CNMutableContact()
//        contact1.givenName = "Vanya"
//        print(123)
//        contact1.familyName = "Sparrow"
//        contact1.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: NSString(string: "p@p.pl")),CNLabeledValue(label: CNLabelHome, value: NSString(string: "p@p.pl")),CNLabeledValue(label: CNLabelHome, value: NSString(string: "p@p.pl")),CNLabeledValue(label: CNLabelHome, value: NSString(string: "p@p.pl"))]
//
//        let store = CNContactStore()
//        let controller = CNContactViewController(forUnknownContact: contact1)
//        controller.contactStore = store
//        //controller.delegate = self
//        let navigationController = UINavigationController(rootViewController: controller)
//        self.present(navigationController, animated: true, completion: nil)
    }
}


