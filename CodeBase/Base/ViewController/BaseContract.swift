//
//  BaseViewController.swift
//  Music One
//
//  Created by nhannlt on 12/24/20.
//

import Foundation

protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Dependency
    
    func viewDidBind()
}

protocol DependencyType {
    
}

protocol InputType {
    
}

protocol OutputType {
    
}
