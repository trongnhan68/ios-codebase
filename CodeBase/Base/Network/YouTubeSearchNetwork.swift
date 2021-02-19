//
//  YouTubeSearchNetwork.swift
//  Music One
//
//  Created by nhannlt on 12/25/20.
//

import Alamofire
import Foundation
import UIKit
import RxSwift
import RxCocoa

final class YoutTubeSearchNetwork: NetworkRequest {

    var url: String {
        return "https://www.googleapis.com/youtube/v3"
    }
    
    var path: String {
        return "/search"
    }
    
    var sessionKey: String {
        return "AIzaSyBHCh9eR044XlCehPrseb2hZCWJbt4JYAo" // apikey
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseParams: [String : String] {
        return ["path" : "snippet", "key": sessionKey]
    }
    
    var headers: HTTPHeaders {
        return HTTPHeaders([.accept("application/json")])
    }
    
    typealias ResponseType = YouTubeSearchResponse
    
    func get(params: [String : String]) -> Single<ResponseType> {
        var parameters = params
        baseParams.forEach { (key, value) in parameters[key] = value }
        
        return Observable.create { [weak self] (observer) -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            let url = URL(string: self.url)!.appendingPathComponent(self.path)
            let _ = AF.request(url,
                                method: self.method,
                                parameters: parameters,
                                headers: self.headers)
                .response { (response) in
                    switch response.result {
                    case .success(let data):
                        if let data = data,
                           let response = try? JSONDecoder().decode(YouTubeSearchResponse.self, from: data) {
                            observer.onNext(response)
                        } else {
                            observer.onError(AppError.unknow)
                        }
                    case .failure(let afError):
                        observer.onError(afError)
                    }
                    observer.onCompleted()
                }
            return Disposables.create()
        }.asSingle()
    }
    
    struct YouTubeSearchResponse: Codable {

        let kind: String
        let etag: String
        let nextPageToken: String
        let regionCode: String
        let pageInfo: PageInfo
        let items: [Items]

        private enum CodingKeys: String, CodingKey {
            case kind = "kind"
            case etag = "etag"
            case nextPageToken = "nextPageToken"
            case regionCode = "regionCode"
            case pageInfo = "pageInfo"
            case items = "items"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            kind = try values.decode(String.self, forKey: .kind)
            etag = try values.decode(String.self, forKey: .etag)
            nextPageToken = try values.decode(String.self, forKey: .nextPageToken)
            regionCode = try values.decode(String.self, forKey: .regionCode)
            pageInfo = try values.decode(PageInfo.self, forKey: .pageInfo)
            items = try values.decode([Items].self, forKey: .items)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(kind, forKey: .kind)
            try container.encode(etag, forKey: .etag)
            try container.encode(nextPageToken, forKey: .nextPageToken)
            try container.encode(regionCode, forKey: .regionCode)
            try container.encode(pageInfo, forKey: .pageInfo)
            try container.encode(items, forKey: .items)
        }
    }
    struct PageInfo: Codable {

        let totalResults: Int
        let resultsPerPage: Int

        private enum CodingKeys: String, CodingKey {
            case totalResults = "totalResults"
            case resultsPerPage = "resultsPerPage"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            totalResults = try values.decode(Int.self, forKey: .totalResults)
            resultsPerPage = try values.decode(Int.self, forKey: .resultsPerPage)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(totalResults, forKey: .totalResults)
            try container.encode(resultsPerPage, forKey: .resultsPerPage)
        }

    }
    
    struct Items: Codable {

        let kind: String
        let etag: String
        let id: Id
        let snippet: Snippet?

        private enum CodingKeys: String, CodingKey {
            case kind = "kind"
            case etag = "etag"
            case id = "id"
            case snippet = "snippet"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            kind = try values.decode(String.self, forKey: .kind)
            etag = try values.decode(String.self, forKey: .etag)
            id = try values.decode(Id.self, forKey: .id)
            snippet = try? values.decode(Snippet.self, forKey: .snippet)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(kind, forKey: .kind)
            try container.encode(etag, forKey: .etag)
            try container.encode(id, forKey: .id)
            try container.encode(snippet, forKey: .snippet)
        }
    }
    
    struct Id: Codable {

        let kind: String
        let videoId: String

        private enum CodingKeys: String, CodingKey {
            case kind = "kind"
            case videoId = "videoId"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            kind = try values.decode(String.self, forKey: .kind)
            videoId = try values.decode(String.self, forKey: .videoId)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(kind, forKey: .kind)
            try container.encode(videoId, forKey: .videoId)
        }

    }
    
    struct Snippet: Codable {

        let publishedAt: String
        let channelId: String
        let title: String
        let description: String
        let thumbnails: Thumbnails
        let channelTitle: String
        let liveBroadcastContent: String
        let publishTime: String

        private enum CodingKeys: String, CodingKey {
            case publishedAt = "publishedAt"
            case channelId = "channelId"
            case title = "title"
            case description = "description"
            case thumbnails = "thumbnails"
            case channelTitle = "channelTitle"
            case liveBroadcastContent = "liveBroadcastContent"
            case publishTime = "publishTime"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            publishedAt = try values.decode(String.self, forKey: .publishedAt)
            channelId = try values.decode(String.self, forKey: .channelId)
            title = try values.decode(String.self, forKey: .title)
            description = try values.decode(String.self, forKey: .description)
            thumbnails = try values.decode(Thumbnails.self, forKey: .thumbnails)
            channelTitle = try values.decode(String.self, forKey: .channelTitle)
            liveBroadcastContent = try values.decode(String.self, forKey: .liveBroadcastContent)
            publishTime = try values.decode(String.self, forKey: .publishTime)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(publishedAt, forKey: .publishedAt)
            try container.encode(channelId, forKey: .channelId)
            try container.encode(title, forKey: .title)
            try container.encode(description, forKey: .description)
            try container.encode(thumbnails, forKey: .thumbnails)
            try container.encode(channelTitle, forKey: .channelTitle)
            try container.encode(liveBroadcastContent, forKey: .liveBroadcastContent)
            try container.encode(publishTime, forKey: .publishTime)
        }

    }
    
    struct Thumbnails: Codable {

        let defaultField: DefaultField
        let medium: Medium
        let high: High

        private enum CodingKeys: String, CodingKey {
            case defaultField = "default"
            case medium = "medium"
            case high = "high"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            defaultField = try values.decode(DefaultField.self, forKey: .defaultField)
            medium = try values.decode(Medium.self, forKey: .medium)
            high = try values.decode(High.self, forKey: .high)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(defaultField, forKey: .defaultField)
            try container.encode(medium, forKey: .medium)
            try container.encode(high, forKey: .high)
        }

    }

    struct DefaultField: Codable {

        let url: String
        let width: Int
        let height: Int

        private enum CodingKeys: String, CodingKey {
            case url = "url"
            case width = "width"
            case height = "height"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            url = try values.decode(String.self, forKey: .url)
            width = try values.decode(Int.self, forKey: .width)
            height = try values.decode(Int.self, forKey: .height)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(url, forKey: .url)
            try container.encode(width, forKey: .width)
            try container.encode(height, forKey: .height)
        }

    }
    struct Medium: Codable {

        let url: String
        let width: Int
        let height: Int

        private enum CodingKeys: String, CodingKey {
            case url = "url"
            case width = "width"
            case height = "height"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            url = try values.decode(String.self, forKey: .url)
            width = try values.decode(Int.self, forKey: .width)
            height = try values.decode(Int.self, forKey: .height)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(url, forKey: .url)
            try container.encode(width, forKey: .width)
            try container.encode(height, forKey: .height)
        }

    }
    
    
    struct High: Codable {

        let url: String
        let width: Int
        let height: Int

        private enum CodingKeys: String, CodingKey {
            case url = "url"
            case width = "width"
            case height = "height"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            url = try values.decode(String.self, forKey: .url)
            width = try values.decode(Int.self, forKey: .width)
            height = try values.decode(Int.self, forKey: .height)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(url, forKey: .url)
            try container.encode(width, forKey: .width)
            try container.encode(height, forKey: .height)
        }

    }
}
