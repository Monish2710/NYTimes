//
//  ResponseModel.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import Foundation

// MARK: - NYTimeResponse

typealias DataResponseModel = [ResultModel]

struct NYTimeResponse: Codable {
    let status, copyright: String
    let numResults: Int
    let results: [ResultModel]

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}

// MARK: - Result

struct ResultModel: Codable, Identifiable {
    let uri: String
    let url: String
    let id, assetID: Int
    let publishedDate, updated, section: String
    let nytdsection, adxKeywords: String
    let byline: String
    let title, abstract: String
    let desFacet, orgFacet, perFacet, geoFacet: [String]
    let etaID: Int
    let media: [Media]

    enum CodingKeys: String, CodingKey {
        case uri, url, id
        case assetID = "asset_id"
        case publishedDate = "published_date"
        case updated, section, nytdsection
        case adxKeywords = "adx_keywords"
        case byline, title, abstract
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case etaID = "eta_id"
        case media
    }
}

// MARK: - Media

struct Media: Codable {
    let caption, copyright: String
    let approvedForSyndication: Int
    let mediaMetadata: [MediaMetadatum]

    enum CodingKeys: String, CodingKey {
        case caption, copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}

// MARK: - MediaMetadatum

struct MediaMetadatum: Codable {
    let url: String
    let height, width: Int
}
