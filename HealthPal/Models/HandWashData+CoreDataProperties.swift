//
//  HandWashData+CoreDataProperties.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/27.
//
//

import Foundation
import CoreData


extension HandWashData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HandWashData> {
        return NSFetchRequest<HandWashData>(entityName: "HandWashData")
    }

    @NSManaged public var time: Date?

}

extension HandWashData : Identifiable {

}
