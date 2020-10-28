//
//  WeightData+CoreDataProperties.swift
//  HealthPal
//
//  Created by Jaryn on 2020/10/28.
//
//

import Foundation
import CoreData


extension WeightData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeightData> {
        return NSFetchRequest<WeightData>(entityName: "WeightData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var unit: String?
    @NSManaged public var value: Int64

}

extension WeightData : Identifiable {

}
