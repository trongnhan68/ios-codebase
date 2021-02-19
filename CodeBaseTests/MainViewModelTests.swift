//
//  MainViewModelTests.swift
//  NoNameTests
//
//  Created by nhannlt on 1/29/21.
//

import XCTest
import RxSwift
import RxCocoa
import RxSwiftExt

@testable import NoName

class MainViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTapMedia() throws {
        let disposeBag = DisposeBag()
        let viewModel = MainViewModel(input: MainViewModelContract.Input(),
                                      output: MainViewModelContract.Output(),
                                      dependency: MainViewModelContract.Dependency(youtubeSearchNetwork: YoutTubeSearchNetwork(), rocketListNetwork: RocketListNetwork()))
        
        let expect = expectation(description: "Did call play media")
        viewModel.output.openRocket
            .subscribe( onNext: { value in
                XCTAssertTrue(!(value.isEmpty))
                expect.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expect], timeout: 0.1)
        viewModel.input.didTapMedia.accept(MainViewContract.MediaDisplayItem())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
