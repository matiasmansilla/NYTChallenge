//
//  ArticlesModel.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 06/07/2024.
//

import Foundation

// Modelo para los metadatos de los medios
public struct MediaMetadata: Decodable {
    let url: String
    let format: String
    let height: Int
    let width: Int
}

// Modelo para los medios
public struct Media: Decodable {
    let type: String
    let subtype: String?
    let caption: String?
    let copyright: String?
    let approvedForSyndication: Int
    let mediaMetadata: [MediaMetadata]

    private enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetadata = "media-metadata"
    }
}

// Modelo para los artículos
public struct Article: Decodable {
    let uri: String
    let url: String
    let id: Int
    let assetId: Int
    let source: String
    let publishedDate: String
    let updated: String
    let section: String
    let subsection: String?
    let nytdsection: String
    let adxKeywords: String
    let column: String?
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let desFacet: [String]
    let orgFacet: [String]
    let perFacet: [String]
    let geoFacet: [String]
    let media: [Media]
    let etaId: Int

    private enum CodingKeys: String, CodingKey {
        case uri, url, id, source, updated, section, subsection, nytdsection, column, byline, type, title, abstract, media
        case assetId = "asset_id"
        case publishedDate = "published_date"
        case adxKeywords = "adx_keywords"
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case etaId = "eta_id"
    }
}

// Modelo para la respuesta completa
public struct ArticlesResponse: Decodable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [Article]

    private enum CodingKeys: String, CodingKey {
        case status, copyright, results
        case numResults = "num_results"
    }
}
