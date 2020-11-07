//
//  LocationData+CoreDataProperties.swift
//  HealthPal
//
//  Created by Jaryn on 2020/11/7.
//
//

import Foundation
import CoreData


extension LocationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationData> {
        return NSFetchRequest<LocationData>(entityName: "LocationData")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?

}

extension LocationData : Identifiable {

}
