//
//  NYTimesTaskTests.swift
//  NYTimesTaskTests
//
//  Created by Monish Kumar on 02/09/24.
//

import CoreData
@testable import NYTimesTask
import XCTest

final class NYTimesTaskTests: XCTestCase {
    var viewController: ListViewController!
    var mockPersistenceManager: MockPersistenceManager!

    override func setUp() {
        super.setUp()
        // Initialize the view controller and other dependencies
        viewController = ListViewController()
        mockPersistenceManager = MockPersistenceManager()
        PersistenceManager.shared = mockPersistenceManager
    }

    override func tearDown() {
        viewController = nil
        mockPersistenceManager = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        // Test that viewDidLoad sets up the UI correctly
        viewController.loadViewIfNeeded()

        XCTAssertNotNil(viewController.tableView)
        XCTAssertEqual(viewController.title, "NY Times")
    }

    func testFetchControllerInitialization() {
        // Test that the fetch controller is initialized correctly
        let fetchController = viewController.fetchController
        XCTAssertNotNil(fetchController)
        XCTAssertEqual(fetchController.fetchRequest.sortDescriptors?.first?.key, "newsPublishedDate")
    }

    func testCreateListEntityFromModel() {
        // Test that the createListEntityFrom(model:) method creates and configures the Core Data entity
        let model = ResultModel(uri: "", url: "www.google.com", id: 0, assetID: 1, publishedDate: "27/10/1997", updated: "27/10/1997", section: "", nytdsection: "", adxKeywords: "", byline: "Author", title: "Hello", abstract: "", desFacet: [], orgFacet: [], perFacet: [], geoFacet: [], etaID: 1, media: [])

        let entity = viewController.createListEntityFrom(model: model) as? NYTimesDataModel

        XCTAssertNotNil(entity)
        XCTAssertEqual(entity?.title, model.title)
        XCTAssertEqual(entity?.newsPublishedDate, model.publishedDate)
    }

    func testTableViewDelegate() {
        // Test UITableViewDelegate methods
        viewController.loadViewIfNeeded()

        let indexPath = IndexPath(row: 0, section: 0)
        viewController.tableView(viewController.tableView, didSelectRowAt: indexPath)
        // Check that the correct view controller is presented
        // Note: This might need more setup depending on your navigation setup
    }
}

// Mock Persistence Manager
class MockPersistenceManager: PersistenceManager {
    override init() {
        super.init()
    }
}
