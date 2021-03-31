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
        let contactsRepo = GistConstactsRepository(path: "https://gist.githubusercontent.com/artgoncharov/d257658423edd46a9ead5f721b837b8c/raw/c38ace33a7c871e4ad3b347fc4cd970bb45561a3/contacts_data.json")
        do {
            contacts = try contactsRepo.getContacts()
        } catch {
            let error = error
            print(error.localizedDescription)
        }
    }
}

