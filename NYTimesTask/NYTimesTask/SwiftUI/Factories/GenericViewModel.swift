//
//  GenericViewModel.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 03/09/24.
//

import Combine
import Foundation

protocol APIClientProtocol {
    associatedtype DataType: Decodable
    func fetchData() async throws -> DataType
}

class GenericViewModel<T: Decodable>: ObservableObject {
    @Published var data: T?
    @Published var error: Error?

    private let apiClient: any APIClientProtocol

    init(apiClient: any APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchData() async {
        do {
            let fetchedData = try await apiClient.fetchData()
            DispatchQueue.main.async {
                self.data = fetchedData as? T
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error
            }
        }
    }
}
