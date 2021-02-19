//
//  RocketDetailViewModel.swift
//  NoName
//
//  Created by nhannlt on 1/29/21.
//

import Foundation
import RxSwiftExt
import RxSwift
import RxCocoa
import RxDataSources

struct RocketDetailModelContract {
    struct Input: InputType {
      
    }
    struct Output: OutputType {
      
    }
    struct Dependency: DependencyType {
       
    }
}

final class RocketDetailViewModel: BaseViewModel<RocketDetailModelContract.Input, RocketDetailModelContract.Output, RocketDetailModelContract.Dependency> {
    
    override func viewDidBind() {

    }
    
}
