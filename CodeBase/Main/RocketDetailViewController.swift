//
//  RocketDetailViewController.swift
//  NoName
//
//  Created by nhannlt on 1/29/21.
//


import UIKit

import Alamofire
import AlamofireImage
import RxSwiftExt
import RxDataSources

final class RocketDetailViewController: BaseViewController<RocketDetailViewModel> {
    
    override func setupViewModel() {
        viewModel = RocketDetailViewModel(input: RocketDetailModelContract.Input(),
                                  output: RocketDetailModelContract.Output(),
                                  dependency: RocketDetailModelContract.Dependency())
    }
    
    override func subscribeViewModelOutput() {
       
    }
    
    private func playVideo(id: String) {
    }
    private func openRocket(id: String) {
        
    }
}
