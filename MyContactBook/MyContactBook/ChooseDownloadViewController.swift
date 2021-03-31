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
    }
    @IBAction func clickDispatch(_ sender: UIButton) {
    }
    @IBAction func clickOperation(_ sender: UIButton) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dispatchDownload" {
            guard let viewTabBarController = segue.destination as? UITabBarController else { return }
            guard let viewNavigationController = viewTabBarController.customizableViewControllers?[0] as? UINavigationController else { return }
            guard let viewController = viewNavigationController.topViewController as? ContactsViewController else { return }
            print(222)
            let isGCD = true
            viewController.isGCD = isGCD
        } else {
            guard let viewTabBarController = segue.destination as? UITabBarController else { return }
            guard let viewNavigationController = viewTabBarController.customizableViewControllers?[0] as? UINavigationController else { return }
            guard let viewController = viewNavigationController.topViewController as? ContactsViewController else { return }
            print(222)
            let isGCD = false
            viewController.isGCD = isGCD
        }
    }
}

