//
//  Category.swift
//  Todoey
//
//  Created by Mesut Gedik on 9.01.2023.


import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item> ()
}
