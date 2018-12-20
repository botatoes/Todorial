//
//  Category.swift
//  Todorial
//
//  Created by Bo-ying Fu on 12/18/18.
//  Copyright © 2018 Botatoes. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    let items = List<Item>()
    
}
