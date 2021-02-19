//
//  MainViewModel.swift
//  Music One
//
//  Created by nhannlt on 12/24/20.
//

import Foundation
import RxSwiftExt
import RxSwift
import RxCocoa
import RxDataSources

struct MainViewModelContract {
    struct Input: InputType {
        let didTapMedia = PublishRelay<MediaItemType>()
    }
    struct Output: OutputType {
        let playMedia = PublishRelay<String>()
        let datasource = PublishRelay<[MainViewContract.MediaSection]>()
        let openRocket = PublishRelay<String>()
    }
    struct Dependency: DependencyType {
        var youtubeSearchNetwork: YoutTubeSearchNetwork
        var rocketListNetwork: RocketListNetwork
    }
}

class MainViewModel: BaseViewModel<MainViewModelContract.Input, MainViewModelContract.Output, MainViewModelContract.Dependency> {
    
    override func viewDidBind() {
        input.didTapMedia
            .subscribe(onNext: { [weak self] item in
                self?.output.openRocket.accept(item.id)
            })
            .disposed(by: disposeBag)
        dependency.rocketListNetwork.get(params: [:])
            .subscribe { [weak self] datas in
                guard let self = self else { return }
                let items = datas.map { (item) -> MainViewContract.MediaSectionItem in
                    let displayItem = MainViewContract.MediaDisplayItem(id: item.id ?? "",
                                                                        title: item.name ?? "",
                                                                        subtitle: item.links?.article ?? "",
                                                                        time: item.dateUtc ?? "",
                                                                        url: item.links?.patch?.large ?? "",
                                                                        thumbURL: item.links?.patch?.small ??  "")
                    
                    return MainViewContract.MediaSectionItem(displayItem: displayItem)
                }
                let sections = [MainViewContract.MediaSection(header: "", items: items)]
                self.output.datasource.accept(sections)
            } onFailure: { error in
                    print("")
                }.disposed(by: disposeBag)

    }
    
}
