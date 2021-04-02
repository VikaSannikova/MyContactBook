//
//  ContactDetailViewController.swift
//  MyContactBook
//
//  Created by user on 01.04.2021.
//

import UIKit
import ContactsUI
import Contacts

class ContactDetailViewController: UIViewController {
    var contact : Contact? = nil
    var isDeleted : Bool = false
    var indexPath: IndexPath? = nil
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactName.text = contact?.firstName
        contactNumber.text = contact?.phone

    }
    
    //MARK: - Button actions

    @IBAction func doneBack(_ sender: Any) {
        performSegue(withIdentifier: "unwindToContacts", sender: self)
        NotificationCenter.default.post(name: Notification.Name("editContact"), object: contact)
    }
    
    @IBAction func deleteContact(_ sender: Any) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToContacts", sender: self)
        NotificationCenter.default.post(name: Notification.Name("deleteContact"), object: contact)
    }
    @IBAction func callContact(_ sender: UIButton) {
        guard let callNumber = contactNumber.text else {return}
        var num = callNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        num = num.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        num = num.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        num = num.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
                
        guard let url = URL(string: "tel://\(num)") else { return }
        UIApplication.shared.open(url)
        print("WE MAKE CALL")
        let callTime = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: callTime)
        let minutes = calendar.component(.minute, from: callTime)
        let time = "\(hour):\(minutes)"
        let recentCall = RecentCall(contact: contact, time: time)
        NotificationCenter.default.post(name: Notification.Name("addContact"), object: recentCall)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editContact") {
//            guard let viewController = segue.destination as? AddContactViewController else { return }
//            viewController.titleText = "EDIT"
//            viewController.contact = self.contact
//            viewController.indexPath = self.indexPath
            let contact1 = CNMutableContact()
            contact1.givenName = self.contact?.firstName ?? ""
            contact1.familyName = self.contact?.lastName ?? ""
            contact1.emailAddresses = [CNLabeledValue(label: "email", value: NSString(string: contact?.email ?? ""))]
            
            let phoneNumber = CNLabeledValue(label: "phone number",
                                             value: CNPhoneNumber(stringValue: contact?.phone ?? ""))
            contact1.phoneNumbers.append(phoneNumber)
            let store = CNContactStore()
            let controller = CNContactViewController(forUnknownContact: contact1)
            controller.contactStore = store
            controller.allowsEditing = true
            controller.allowsActions = false
            //controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func backToDetails(segue : UIStoryboardSegue) {
        if let viewController = segue.source as? AddContactViewController {
            switch segue.identifier {
            case "backToDetails":
                print(123)
            case "backToDetailsAndSave":
                guard let name = viewController.nameTextField.text, let number = viewController.numberTextField.text else {
                    return
                }
                contact?.firstName = name
                contact?.phone = number
                contactName.text = contact?.firstName
                contactNumber.text = contact?.phone
            default:
                print("what")
            }
        }
    }
}




