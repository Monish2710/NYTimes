//
//  File.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 03/09/24.
//

import Foundation

struct NYTimesAPIClient: APIClientProtocol {
    typealias DataType = DataResponseModel

    func fetchData() async throws -> DataResponseModel {
        return try await APIClient.getNYTimesDetails() ?? []
    }
}
