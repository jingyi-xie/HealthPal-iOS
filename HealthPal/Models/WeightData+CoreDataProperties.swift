//
//  WeightData+CoreDataProperties.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/27.
//
//

import Foundation
import CoreData


extension WeightData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeightData> {
        return NSFetchRequest<WeightData>(entityName: "WeightData")
    }

    @NSManaged public var time: Date?
    @NSManaged public var value: Int64
    @NSManaged public var unit: String?

}

extension WeightData : Identifiable {

}
