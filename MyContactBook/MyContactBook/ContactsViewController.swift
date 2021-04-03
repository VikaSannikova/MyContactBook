//
//  ContactsTableViewController.swift
//  MyContactBook
//
//  Created by user on 01.04.2021.
//

import UIKit
import Foundation
import Dispatch
import UserNotifications


protocol ContactsRepository {
    func getContacts() throws -> [Contact]
}
class GistConstactsRepository: ContactsRepository {
    private let path: String
    init(path: String) {
        self.path = path
    }
    func getContacts() throws -> [Contact] {
        let sem = DispatchSemaphore(value: 0)
        let url1 = URL(string: path)
        let request = URLRequest(url: url1!)
        var result: [Contact] = []
        //        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        //                defer {
        //                    sem.signal()
        //                }
        //                guard let data = data else {
        //                    return
        //                }
        //                do{
        //                    let postData = try JSONDecoder().decode([Contact].self, from: data)
        //                    result = postData
        //                } catch  {
        //                    let error = error
        //                    print(error.localizedDescription)
        //                }
        //        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.downloadTask(with: request){(tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                defer {
                    sem.signal()
                }
                let documentsUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                let destinationUrl = documentsUrl.appendingPathComponent(url1!.lastPathComponent)
                if !FileManager().fileExists(atPath: destinationUrl.path){
                    do {
                        if FileManager().fileExists(atPath: tempLocalUrl.path) {
                            try FileManager.default.copyItem(at: tempLocalUrl, to: destinationUrl)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                guard let data = try? Data(contentsOf: destinationUrl, options: .mappedIfSafe) else { return }
                let jsonDecoder = JSONDecoder()
                do{
                    result = try jsonDecoder.decode([Contact].self, from: data)
                } catch  {
                    let error = error
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
        sem.wait()
        return result
    }
}

class ContactsViewController: UITableViewController{
    var contacts : [Contact] = []
    var jsonURL: URL?
    var isGCD: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
//        let vika = Contact(firstName: "Vika", lastName: "Sannikova", email: "v.sannikova", phone: "88003553535", birthday: Date?(nil))
//        contacts.append(vika)
//        let vika1 = Contact(firstName: "Vika", lastName: "Sannikova", email: "v.sannikova", phone: "88003553535", birthday: Date?(nil))
//        contacts.append(vika1)
//        tableView.reloadData()
        
        let contactsRepo = GistConstactsRepository(path: "https://gist.githubusercontent.com/artgoncharov/d257658423edd46a9ead5f721b837b8c/raw/c38ace33a7c871e4ad3b347fc4cd970bb45561a3/contacts_data.json")
        if isGCD {
            let queueBackGround = DispatchQueue.global(qos: .background)
            queueBackGround.async {
                do {
                    self.contacts = try contactsRepo.getContacts()
                } catch {
                    let error = error
                    print(error.localizedDescription)
                }
                // обновление таблицы только на мэйн потоке
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            let opQueue = OperationQueue()
            let myOperation = MyOperation()
            opQueue.addOperation(myOperation)
            myOperation.completionBlock = {
                self.contacts = myOperation.contacts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contacts[indexPath.row]
        cell.textLabel?.text = contact.firstName
        cell.detailTextLabel?.text = contact.phone
        return cell
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToContactList(segue : UIStoryboardSegue) {
        if let viewController = segue.source as? AddContactViewController {
            switch segue.identifier {
            case "unwindToContactList":
                print(123)
            case "unwindToContactListAndSave":
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.medium
                guard let name = viewController.nameTextField.text, let number = viewController.numberTextField.text else {
                    return
                }
                let birhday = viewController.birthdayPicker.date
                let contact = Contact(firstName: name, lastName: "", email: "", phone: number, birthday: birhday)
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        print("Permission granted: \(granted)")
                    }
                
                let content = UNMutableNotificationContent()
                content.title = "\(name)'s birthday party"
                content.body = "at \(dateFormatter.string(from: birhday))"
                content.sound = .default
                let dateComponents = Calendar.current.dateComponents([.year, .day, .hour, .minute, .second], from: birhday)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                center.add(request) {(error) in
                    print(error.debugDescription)
                }
                if let indexPath = viewController.indexPath {
                    contacts[indexPath.row] = contact
                } else {
                    contacts.append(contact)
                }
                tableView.reloadData()
            default:
                print(456)
            }
            
        } else if let viewController = segue.source as? ContactDetailViewController {
            if viewController.isDeleted {
                guard let indexPath = viewController.indexPath else { return }
                contacts.remove(at: indexPath.row)
                tableView.reloadData()
            } else {
                guard let indexPath = viewController.indexPath else { return }
                contacts[indexPath.row] = viewController.myAppContact!
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetailSegue" {
            guard let viewNavigationController = segue.destination as? UINavigationController else { return }
            guard let viewController = viewNavigationController.topViewController as? ContactDetailViewController else { return }
            guard let index =  tableView.indexPathForSelectedRow else { return }
            let contact = contacts[index.row]
            viewController.myAppContact = contact
            viewController.indexPath = index
        }
    }
}

