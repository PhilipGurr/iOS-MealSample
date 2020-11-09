//
//  Meal.swift
//  FirstApp
//
//  Created by Philip Gurr on 08.11.20.
//

import UIKit

class Meal : NSObject, NSCoding {
    var name: String
    var photo: UIImage?
    
    static let DocsDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl = DocsDir.appendingPathComponent("meals")
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
            return nil
        }
        
        let photo = coder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(name: name, photo: photo)
    }
    
    init?(name: String, photo: UIImage?) {
        if(name.isEmpty) {
            return nil
        }
        self.name = name
        self.photo = photo
    }
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
    }
}
