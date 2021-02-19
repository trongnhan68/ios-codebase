//
//  Network.swift
//  Music One
//
//  Created by nhannlt on 12/25/20.
//

import Alamofire
import Foundation
import UIKit
import RxSwift
import RxCocoa


protocol NetworkRequest {
    associatedtype ResponseType
    var url: String { get }
    var path: String { get }
    var sessionKey: String { get }
    var method: HTTPMethod { get }
    var baseParams: [String : String] { get }
    
    var headers: HTTPHeaders { get }
    
    func get(params: [String : String]) -> Single<ResponseType>
}
