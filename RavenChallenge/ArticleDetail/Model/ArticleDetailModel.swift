//
//  ArticleDetailModel.swift
//  RavenChallenge
//
//  Created by Dardo Matias Mansilla on 07/07/2024.
//

import Foundation

struct ArticleDetailModel {
    let title: String
    let abstract: String
    let byline: String
    let publishedDate: String
    var thumbnail: String?
    var thumbnailData: Data?
    
    static func transform(entity: Article) -> ArticleDetailModel {
        let thumbnailMediumData = entity.media.first?.mediaMetadata.first(where: { $0.format == "mediumThreeByTwo440" })
        return .init(title: entity.title,
                     abstract: entity.abstract,
                     byline: entity.byline,
                     publishedDate: entity.publishedDate,
                     thumbnail: thumbnailMediumData?.url)
    }
    
    static func transform(entity: FavoriteArticle) -> ArticleDetailModel? {
        guard let title = entity.title,
              let abstract = entity.abstract,
              let byline = entity.byline,
              let publishedDate = entity.publishedDate
        else { return nil }
        return .init(title: title,
                     abstract: abstract,
                     byline: byline,
                     publishedDate: publishedDate,
                     thumbnailData: entity.thumbnailData)
    }
}
