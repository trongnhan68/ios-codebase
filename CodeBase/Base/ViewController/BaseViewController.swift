//
//  BaseViewController.swift
//  Music One
//
//  Created by nhannlt on 12/24/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BaseViewController<VMType: BaseViewModelType>: UIViewController {
    let disposeBag = DisposeBag()
    
    typealias ViewModel = VMType
    var viewModel: ViewModel?
    
    final override func loadView() {
        super.loadView()
        setupView()
        setupViewModel()
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            viewModel?.viewDidBind()
        }
        
        subscribeViewModelOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    // MARK: Override Functions Start
    
    func subscribeViewModelOutput() {
        
    }
    
    func setupView() {
        
    }
    
    func setupViewModel() {
        
    }
    
    // MARK: Override Functions End
    
    deinit {
        print("deinit: \(String(describing: self))")
    }
}

