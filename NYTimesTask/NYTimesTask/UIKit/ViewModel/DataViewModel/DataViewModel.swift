//
//  DataViewModel.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import Foundation
import UIKit

class DataViewModel {
    var showError: (() -> Void)?
    var showLoading: (() -> Void)?
    var hideLoading: (() -> Void)?

    func getResponseData(completion: @escaping (DataResponseModel) -> Void) {
        showLoading?()
        Task {
            do {
                self.hideLoading?()
                guard let response = try await APIClient.getNYTimesDetails() else { return }
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                self.showError?()
                print("Request failed with error: \(error)")
            }
        }
    }
}
