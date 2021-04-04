//
//  ContactDetailViewController.swift
//  MyContactBook
//
//  Created by user on 01.04.2021.
//

import UIKit
import ContactsUI
import Contacts

class ContactDetailViewController: UIViewController, CNContactViewControllerDelegate {
    var myAppContact : Contact? = nil
    var isDeleted : Bool = false
    var indexPath: IndexPath? = nil
    @IBOutlet weak var contactFirstName: UILabel!
    @IBOutlet weak var contactLastName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var contactBirthdayParty: UILabel!
    @IBOutlet weak var contactAvatar: ContactAvatarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactFirstName.text = myAppContact?.firstName
        contactLastName.text = myAppContact?.lastName
        contactNumber.text = myAppContact?.phone
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        contactAvatar.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        if let bitrhday = myAppContact?.birthday  {
            contactBirthdayParty.text = dateFormatter.string(from: bitrhday)
        }
        guard let fn = myAppContact?.firstName.character(at: 0), let ln = myAppContact?.lastName.character(at: 0) else { return }
        contactAvatar.initials = "\(fn.uppercased())\(ln.uppercased())"
    }
    
    //MARK: - Button actions

    @IBAction func doneBack(_ sender: Any) {
        performSegue(withIdentifier: "unwindToContacts", sender: self)
        NotificationCenter.default.post(name: Notification.Name("editContact"), object: myAppContact)
    }
    
    @IBAction func deleteContact(_ sender: Any) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToContacts", sender: self)
        NotificationCenter.default.post(name: Notification.Name("deleteContact"), object: myAppContact)
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
        let recentCall = RecentCall(contact: myAppContact, time: time)
        NotificationCenter.default.post(name: Notification.Name("addContact"), object: recentCall)
    }
    @IBAction func tapContactAvatar(_ sender: Any) {
        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
                       options: [],
                       animations: {
                        let parentFrame = self.view.frame
                        let contactAvatarFrame = self.contactAvatar.frame
                        let tmp = (parentFrame.width-10)/contactAvatarFrame.width
                        self.contactAvatar.transform = CGAffineTransform(scaleX: tmp, y: tmp)
                       })
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editContact") {
//            guard let viewController = segue.destination as? AddContactViewController else { return }
//            viewController.titleText = "EDIT"
//            viewController.contact = self.contact
//            viewController.indexPath = self.indexPath
            let myCNContact = CNMutableContact()
            myCNContact.givenName = self.myAppContact?.firstName ?? ""
            myCNContact.familyName = self.myAppContact?.lastName ?? ""
            myCNContact.emailAddresses = [CNLabeledValue(label: "email", value: NSString(string: myAppContact?.email ?? ""))]
            let phoneNumber = CNLabeledValue(label: "phone number", value: CNPhoneNumber(stringValue: myAppContact?.phone ?? ""))
            myCNContact.phoneNumbers.append(phoneNumber)
            if let birthday = myAppContact?.birthday {
                myCNContact.birthday = NSCalendar.current.dateComponents([.day, .month, .year, .calendar], from: birthday)
            }
            
            let controller = CNContactViewController(for: myCNContact)
            controller.contactStore = CNContactStore()
            controller.title = "Contact"
            controller.allowsEditing = true
            controller.allowsActions = false
            controller.delegate = self
            let navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        myAppContact?.firstName = contact?.givenName ?? ""
        myAppContact?.lastName = contact?.familyName ?? ""
        //todo не позволяет по-другому вытащить название строчки
        myAppContact?.email = "\(contact!.emailAddresses[0].value)"
        myAppContact?.phone = "\(contact!.phoneNumbers[0].value.stringValue)"
        if let bd = contact!.birthday?.date{
            myAppContact?.birthday = bd
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.medium
            contactBirthdayParty.text = dateFormatter.string(from: bd)
        }
        contactFirstName.text = myAppContact?.firstName
        contactNumber.text = myAppContact?.phone
    }
    
    
    @IBAction func backToDetails(segue : UIStoryboardSegue) {
        if let viewController = segue.source as? AddContactViewController {
            switch segue.identifier {
            case "backToDetails":
                print(123)
            case "backToDetailsAndSave":
                guard let firstName = viewController.firstNameTextField.text,let lastName = viewController.lastNameTextField.text, let number = viewController.numberTextField.text else {
                    return
                }
                myAppContact?.firstName = firstName
                myAppContact?.lastName = lastName
                myAppContact?.phone = number
                contactFirstName.text = myAppContact?.firstName
                contactLastName.text = myAppContact?.lastName
                contactNumber.text = myAppContact?.phone
            default:
                print("what")
            }
        }
    }
}

extension String {
 
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
 
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}




