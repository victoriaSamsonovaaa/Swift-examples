//
//  Flight+CoreDataProperties.swift
//  ticketsReservation
//
//  Created by Victoria Samsonova on 14.05.24.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var cityTo: String?
    @NSManaged public var cityFrom: String?
    @NSManaged public var company: String?
    @NSManaged public var duration: String?
    @NSManaged public var price: String?

}
