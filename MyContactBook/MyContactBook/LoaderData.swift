//
//  LoaderData.swift
//  MyContactBook
//
//  Created by user on 01.04.2021.
//

import Foundation

public class LoaderData{
    @Published var contactData = [Contact]()
    var jsonPath: String?
    
    init(jsonPath: String) {
        self.jsonPath = jsonPath
    }
    
    func load(){
        
    }
}
