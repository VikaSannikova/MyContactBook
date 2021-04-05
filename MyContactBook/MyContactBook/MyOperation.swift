//
//  MyOperation.swift
//  MyContactBook
//
//  Created by user on 01.04.2021.
//

import Foundation

class MyOperation: Operation {
    
    var contacts : [Contact] = []

    override func main() {
        let contactsRepo = GistConstactsRepository(path: "https://gist.githubusercontent.com/artgoncharov/61c471db550238f469ad746a0c3102a7/raw/590dcd89a6aa10662c9667138c99e4b0a8f43c67/contacts_data2.json")
        do {
            contacts = try contactsRepo.getContacts()
        } catch {
            let error = error
            print(error.localizedDescription)
        }
    }
}

