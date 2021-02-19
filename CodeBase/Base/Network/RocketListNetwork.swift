//
//  RocketListNetwork.swift
//  NoName
//
//  Created by nhannlt on 1/29/21.
//

import Alamofire
import Foundation
import UIKit
import RxSwift
import RxCocoa

final class RocketListNetwork: NetworkRequest {

    var url: String {
        return "https://api.spacexdata.com/v4"
    }
    
    var path: String {
        return "/launches"
    }
    
    var sessionKey: String {
        return "" // apikey
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseParams: [String : String] {
        return [:]
    }
    
    var headers: HTTPHeaders {
        return HTTPHeaders([.accept("application/json")])
    }
    
    typealias ResponseType = [RocketPage]
    
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
                           let response = try? JSONDecoder().decode([RocketPage].self, from: data) {
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
    

    struct RocketPage: Codable {

        let fairings: Fairings?
        let links: Links?
        let staticFireDateUtc: String?
        let staticFireDateUnix: Int?
        let tbd: Bool?
        let net: Bool?
        let window: Int?
        let rocket: String?
        let success: Bool?
        let details: String?
        let crew: [Any]?
        let ships: [Any]?
        let capsules: [Any]?
        let payloads: [String]?
        let launchpad: String?
        let autoUpdate: Bool?
        let launchLibraryId: Any?
        let failures: [Failures]?
        let flightNumber: Int?
        let name: String?
        let dateUtc: String?
        let dateUnix: Int?
        let dateLocal: String?
        let datePrecision: String?
        let upcoming: Bool?
        let cores: [Cores]?
        let id: String?

        private enum CodingKeys: String, CodingKey {
            case fairings = "fairings"
            case links = "links"
            case staticFireDateUtc = "static_fire_date_utc"
            case staticFireDateUnix = "static_fire_date_unix"
            case tbd = "tbd"
            case net = "net"
            case window = "window"
            case rocket = "rocket"
            case success = "success"
            case details = "details"
            case crew = "crew"
            case ships = "ships"
            case capsules = "capsules"
            case payloads = "payloads"
            case launchpad = "launchpad"
            case autoUpdate = "auto_update"
            case launchLibraryId = "launch_library_id"
            case failures = "failures"
            case flightNumber = "flight_number"
            case name = "name"
            case dateUtc = "date_utc"
            case dateUnix = "date_unix"
            case dateLocal = "date_local"
            case datePrecision = "date_precision"
            case upcoming = "upcoming"
            case cores = "cores"
            case id = "id"
        }

        init(from decoder: Decoder) throws {
            do {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                fairings = try? values.decode(Fairings.self, forKey: .fairings)
                links = try? values.decode(Links.self, forKey: .links)
                staticFireDateUtc = try? values.decode(String.self, forKey: .staticFireDateUtc)
                staticFireDateUnix = try? values.decode(Int.self, forKey: .staticFireDateUnix)
                tbd = try? values.decode(Bool.self, forKey: .tbd)
                net = try? values.decode(Bool.self, forKey: .net)
                window = try? values.decode(Int.self, forKey: .window)
                rocket = try? values.decode(String.self, forKey: .rocket)
                success = try? values.decode(Bool.self, forKey: .success)
                details = try? values.decode(String.self, forKey: .details)
                crew = [] // TODO: Add code for decoding `crew`, It was empty at the time of model creation.
                ships = [] // TODO: Add code for decoding `ships`, It was empty at the time of model creation.
                capsules = [] // TODO: Add code for decoding `capsules`, It was empty at the time of model creation.
                payloads = try? values.decode([String].self, forKey: .payloads)
                launchpad = try? values.decode(String.self, forKey: .launchpad)
                autoUpdate = try values.decode(Bool.self, forKey: .autoUpdate)
                launchLibraryId = nil // TODO: Add code for decoding `launchLibraryId`, It was null at the time of model creation.
                failures = try? values.decode([Failures].self, forKey: .failures)
                flightNumber = try? values.decode(Int.self, forKey: .flightNumber)
                name = try? values.decode(String.self, forKey: .name)
                dateUtc = try? values.decode(String.self, forKey: .dateUtc)
                dateUnix = try values.decode(Int.self, forKey: .dateUnix)
                dateLocal = try? values.decode(String.self, forKey: .dateLocal)
                datePrecision = try? values.decode(String.self, forKey: .datePrecision)
                upcoming = try? values.decode(Bool.self, forKey: .upcoming)
                cores = try? values.decode([Cores].self, forKey: .cores)
                id = try? values.decode(String.self, forKey: .id)
            } catch { error
                throw error
            }
            
            
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(fairings, forKey: .fairings)
            try container.encode(links, forKey: .links)
            try container.encode(staticFireDateUtc, forKey: .staticFireDateUtc)
            try container.encode(staticFireDateUnix, forKey: .staticFireDateUnix)
            try container.encode(tbd, forKey: .tbd)
            try container.encode(net, forKey: .net)
            try container.encode(window, forKey: .window)
            try container.encode(rocket, forKey: .rocket)
            try container.encode(success, forKey: .success)
            try container.encode(details, forKey: .details)
            // TODO: Add code for encoding `crew`, It was empty at the time of model creation.
            // TODO: Add code for encoding `ships`, It was empty at the time of model creation.
            // TODO: Add code for encoding `capsules`, It was empty at the time of model creation.
            try container.encode(payloads, forKey: .payloads)
            try container.encode(launchpad, forKey: .launchpad)
            try container.encode(autoUpdate, forKey: .autoUpdate)
            // TODO: Add code for encoding `launchLibraryId`, It was null at the time of model creation.
            try container.encode(failures, forKey: .failures)
            try container.encode(flightNumber, forKey: .flightNumber)
            try container.encode(name, forKey: .name)
            try container.encode(dateUtc, forKey: .dateUtc)
            try container.encode(dateUnix, forKey: .dateUnix)
            try container.encode(dateLocal, forKey: .dateLocal)
            try container.encode(datePrecision, forKey: .datePrecision)
            try container.encode(upcoming, forKey: .upcoming)
            try container.encode(cores, forKey: .cores)
            try container.encode(id, forKey: .id)
        }

    }

    struct Fairings: Codable {

        let reused: Bool
        let recoveryAttempt: Bool
        let recovered: Bool
        let ships: [Any]?

        private enum CodingKeys: String, CodingKey {
            case reused = "reused"
            case recoveryAttempt = "recovery_attempt"
            case recovered = "recovered"
            case ships = "ships"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            reused = try values.decode(Bool.self, forKey: .reused)
            recoveryAttempt = try values.decode(Bool.self, forKey: .recoveryAttempt)
            recovered = try values.decode(Bool.self, forKey: .recovered)
            ships = [] // TODO: Add code for decoding `ships`, It was empty at the time of model creation.
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(reused, forKey: .reused)
            try container.encode(recoveryAttempt, forKey: .recoveryAttempt)
            try container.encode(recovered, forKey: .recovered)
            // TODO: Add code for encoding `ships`, It was empty at the time of model creation.
        }

    }
    
    struct Links: Codable {

        let patch: Patch?
        let reddit: Reddit?
        let flickr: Flickr?
        let presskit: Any?
        let webcast: String
        let youtubeId: String
        let article: String
        let wikipedia: String

        private enum CodingKeys: String, CodingKey {
            case patch = "patch"
            case reddit = "reddit"
            case flickr = "flickr"
            case presskit = "presskit"
            case webcast = "webcast"
            case youtubeId = "youtube_id"
            case article = "article"
            case wikipedia = "wikipedia"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            patch = try values.decode(Patch.self, forKey: .patch)
            reddit = try values.decode(Reddit.self, forKey: .reddit)
            flickr = try values.decode(Flickr.self, forKey: .flickr)
            presskit = nil // TODO: Add code for decoding `presskit`, It was null at the time of model creation.
            webcast = try values.decode(String.self, forKey: .webcast)
            youtubeId = try values.decode(String.self, forKey: .youtubeId)
            article = try values.decode(String.self, forKey: .article)
            wikipedia = try values.decode(String.self, forKey: .wikipedia)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(patch, forKey: .patch)
            try container.encode(reddit, forKey: .reddit)
            try container.encode(flickr, forKey: .flickr)
            // TODO: Add code for encoding `presskit`, It was null at the time of model creation.
            try container.encode(webcast, forKey: .webcast)
            try container.encode(youtubeId, forKey: .youtubeId)
            try container.encode(article, forKey: .article)
            try container.encode(wikipedia, forKey: .wikipedia)
        }

    }
    
    
    struct Patch: Codable {

        let small: String
        let large: String

        private enum CodingKeys: String, CodingKey {
            case small = "small"
            case large = "large"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            small = try values.decode(String.self, forKey: .small)
            large = try values.decode(String.self, forKey: .large)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(small, forKey: .small)
            try container.encode(large, forKey: .large)
        }

    }
    
    struct Reddit: Codable {

        let campaign: Any?
        let launch: Any?
        let media: Any?
        let recovery: Any?

        private enum CodingKeys: String, CodingKey {
            case campaign = "campaign"
            case launch = "launch"
            case media = "media"
            case recovery = "recovery"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            campaign = nil // TODO: Add code for decoding `campaign`, It was null at the time of model creation.
            launch = nil // TODO: Add code for decoding `launch`, It was null at the time of model creation.
            media = nil // TODO: Add code for decoding `media`, It was null at the time of model creation.
            recovery = nil // TODO: Add code for decoding `recovery`, It was null at the time of model creation.
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            // TODO: Add code for encoding `campaign`, It was null at the time of model creation.
            // TODO: Add code for encoding `launch`, It was null at the time of model creation.
            // TODO: Add code for encoding `media`, It was null at the time of model creation.
            // TODO: Add code for encoding `recovery`, It was null at the time of model creation.
        }

    }
    
    
    struct Flickr: Codable {

        let small: [Any]?
        let original: [Any]?

        private enum CodingKeys: String, CodingKey {
            case small = "small"
            case original = "original"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            small = [] // TODO: Add code for decoding `small`, It was empty at the time of model creation.
            original = [] // TODO: Add code for decoding `original`, It was empty at the time of model creation.
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            // TODO: Add code for encoding `small`, It was empty at the time of model creation.
            // TODO: Add code for encoding `original`, It was empty at the time of model creation.
        }

    }
    
    
    struct Failures: Codable {

        let time: Int
        let altitude: Any?
        let reason: String

        private enum CodingKeys: String, CodingKey {
            case time = "time"
            case altitude = "altitude"
            case reason = "reason"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            time = try values.decode(Int.self, forKey: .time)
            altitude = nil // TODO: Add code for decoding `altitude`, It was null at the time of model creation.
            reason = try values.decode(String.self, forKey: .reason)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(time, forKey: .time)
            // TODO: Add code for encoding `altitude`, It was null at the time of model creation.
            try container.encode(reason, forKey: .reason)
        }

    }

    struct Cores: Codable {

        let core: String
        let flight: Int
        let gridfins: Bool
        let legs: Bool
        let reused: Bool
        let landingAttempt: Bool
        let landingSuccess: Any?
        let landingType: Any?
        let landpad: Any?

        private enum CodingKeys: String, CodingKey {
            case core = "core"
            case flight = "flight"
            case gridfins = "gridfins"
            case legs = "legs"
            case reused = "reused"
            case landingAttempt = "landing_attempt"
            case landingSuccess = "landing_success"
            case landingType = "landing_type"
            case landpad = "landpad"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            core = try values.decode(String.self, forKey: .core)
            flight = try values.decode(Int.self, forKey: .flight)
            gridfins = try values.decode(Bool.self, forKey: .gridfins)
            legs = try values.decode(Bool.self, forKey: .legs)
            reused = try values.decode(Bool.self, forKey: .reused)
            landingAttempt = try values.decode(Bool.self, forKey: .landingAttempt)
            landingSuccess = nil // TODO: Add code for decoding `landingSuccess`, It was null at the time of model creation.
            landingType = nil // TODO: Add code for decoding `landingType`, It was null at the time of model creation.
            landpad = nil // TODO: Add code for decoding `landpad`, It was null at the time of model creation.
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(core, forKey: .core)
            try container.encode(flight, forKey: .flight)
            try container.encode(gridfins, forKey: .gridfins)
            try container.encode(legs, forKey: .legs)
            try container.encode(reused, forKey: .reused)
            try container.encode(landingAttempt, forKey: .landingAttempt)
            // TODO: Add code for encoding `landingSuccess`, It was null at the time of model creation.
            // TODO: Add code for encoding `landingType`, It was null at the time of model creation.
            // TODO: Add code for encoding `landpad`, It was null at the time of model creation.
        }

    }
}
