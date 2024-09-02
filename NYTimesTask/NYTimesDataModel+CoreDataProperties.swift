//
//  NYTimesDataModel+CoreDataProperties.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//
//

import CoreData
import Foundation

extension NYTimesDataModel {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NYTimesDataModel> {
        return NSFetchRequest<NYTimesDataModel>(entityName: "NYTimesDataModel")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var newsUpdatedDate: String?
    @NSManaged public var newsPublishedDate: String?
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
}

extension NYTimesDataModel: Identifiable {
}
