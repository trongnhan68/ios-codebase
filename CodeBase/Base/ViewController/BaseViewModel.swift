//
//  BaseViewController.swift
//  Music One
//
//  Created by nhannlt on 12/24/20.
//

import Foundation
import RxSwift

class BaseViewModel<InputElement: InputType, OutputElement: OutputType, DependencyElement: DependencyType>: BaseViewModelType {
    
    typealias Input = InputElement
    typealias Output = OutputElement
    typealias Dependency = DependencyElement
    
    let input: Input
    let output: Output
    let dependency: Dependency
    
    let disposeBag = DisposeBag()
    
    init(input: Input, output: Output, dependency: Dependency) {
        self.input = input
        self.output = output
        self.dependency = dependency
    }
    
    func viewDidBind() {
        
    }
}
