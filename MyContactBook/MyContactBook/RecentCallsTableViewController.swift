//
//  RecentCallsTableViewController.swift
//  MyContactBook
//
//  Created by user on 01.04.2021.
//

import UIKit

struct RecentCall {
    var contact: Contact?
    let time: String
    init(contact: Contact?, time: String) {
        self.contact = contact
        self.time = time
    }
}

class RecentCallsTableViewController: UITableViewController {
    var recentCalls : [RecentCall] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(addContactToRecentCallList(notification:)), name: Notification.Name("addContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editContactInRecentCallList(notification:)), name: Notification.Name("editContact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteContactFromRecentCallList(notification:)), name: Notification.Name("deleteContact"), object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentCalls.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCallCell", for: indexPath)
        let call = recentCalls[indexPath.row]
        cell.textLabel?.text = call.contact?.firstName
        cell.detailTextLabel?.text = call.time
        return cell
    }
    
    //MARK: - Observe Notifications
    
    @objc func addContactToRecentCallList( notification : Notification){
        guard let recentCall = notification.object as? RecentCall else { return }
        recentCalls.append(recentCall)
        self.tableView.reloadData()
    }
    
    @objc func editContactInRecentCallList(notification: Notification) {
        guard let recentCall = notification.object as? Contact else { return }
        for (index, item) in recentCalls.enumerated() {
            if item.contact?.id == recentCall.id {
                recentCalls[index] = RecentCall(contact: recentCall, time: item.time)
            }
        }
        self.tableView.reloadData()
    }

    @objc func deleteContactFromRecentCallList(notification: Notification) {
        guard let recentCall = notification.object as? Contact else { return }
        //Костыль
        var newRecentCalls = [RecentCall]()
        for item in recentCalls {
            if item.contact?.id != recentCall.id {
                newRecentCalls.append(item)
            }
        }
        recentCalls = newRecentCalls
        self.tableView.reloadData()
    }
}
