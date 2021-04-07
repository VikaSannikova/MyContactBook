//
//  ChooseDownloadViewController.swift
//  MyContactBook
//
//  Created by user on 31.03.2021.
//

import UIKit

class ChooseDownloadViewController: UIViewController {
    var IsDCG: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.register(defaults: [String : Any]())
    }
    @IBAction func clickDispatch(_ sender: UIButton) {
    }
    @IBAction func clickOperation(_ sender: UIButton) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userDefaults = UserDefaults.standard
        let startPage = userDefaults.string(forKey: "choose_start_page_id")
        guard let viewTabBarController = segue.destination as? UITabBarController else { return }
        guard let viewNavigationController = viewTabBarController.customizableViewControllers?[0] as? UINavigationController else { return }
        guard let viewController = viewNavigationController.topViewController as? ContactsViewController else { return }
        if startPage?.description == "Contact List" {
            viewTabBarController.selectedIndex = 0
        } else if startPage?.description == "Call History" {
            viewTabBarController.selectedIndex = 1
        }
        if segue.identifier == "dispatchDownload" {
            viewController.isGCD = true
        } else {
            viewController.isGCD = false
        }
    }
}

