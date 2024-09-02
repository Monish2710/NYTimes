//
//  APIClient.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import UIKit

struct APIClient {
    static func getNYTimesDetails() async throws -> DataResponseModel? {
        let apiUrl = URL(string: "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=x2gTwp3LfLER5oxUEqYwYSGHTNCWAx9C")
        guard let urlValue = apiUrl else {
            return nil
        }
        let request = URLRequest(url: urlValue)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(NYTimeResponse.self, from: data)
        return response.results
    }
}
