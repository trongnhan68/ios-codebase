//
//  MainViewController.swift
//  Music One
//
//  Created by nhannlt on 12/23/20.
//

import UIKit

import Alamofire
import AlamofireImage
import RxSwiftExt
import RxDataSources
import WebKit

protocol MediaItemType {
    var id: String { get }
    var title: String { get }
    var subtitle: String { get }
    var time: String { get }
    var url: String { get }
    var thumbURL: String { get }
}

struct MainViewContract {
    
    struct MediaDisplayItem: MediaItemType {
        
        var id: String = ""
        
        var title: String = ""
        
        var subtitle: String = ""
        
        var time: String = ""
        
        var url: String = ""
        
        var thumbURL: String = ""
    }
    
    struct MediaSectionItem: IdentifiableType, Equatable {
        typealias Identity = String
        var identity: String {
            return displayItem.id
        }
        var displayItem: MediaDisplayItem
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.identity == rhs.identity
        }
    }
    
    struct MediaSection: AnimatableSectionModelType {
        init(original: MainViewContract.MediaSection, items: [MainViewContract.MediaSectionItem]) {
            self = original
        }
        
        typealias Identity = String
        var identity: String
        var header: String
        init(header: String, items: [MainViewContract.MediaSectionItem]) {
            self.header = header
            self.items = items
            self.identity = items.reduce(into: "", { $0 += $1.identity })
        }
        var items: [MainViewContract.MediaSectionItem]
        
    }
    
}

class MainViewController: BaseViewController<MainViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var webview: WKWebView!
    override func setupView() {
        tableView.register(MainMediaItemCell.self, forCellReuseIdentifier: "MainMediaItemCell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView
            .rx
            .modelSelected(MainViewContract.MediaSectionItem.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.viewModel?.input.didTapMedia.accept(item.displayItem)
            }).disposed(by: disposeBag)
    }
    
    override func setupViewModel() {
        viewModel = MainViewModel(input: MainViewModelContract.Input(),
                                  output: MainViewModelContract.Output(),
                                  dependency: MainViewModelContract.Dependency(youtubeSearchNetwork: YoutTubeSearchNetwork(), rocketListNetwork: RocketListNetwork()))
    }
    
    override func subscribeViewModelOutput() {
        let datasource: RxTableViewSectionedAnimatedDataSource = RxTableViewSectionedAnimatedDataSource<MainViewContract.MediaSection> { (datasource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainMediaItemCell", for: indexPath) as! MainMediaItemCell
            cell.bind(item: item.displayItem)
            return cell
            
        }
        viewModel?.output.datasource.bind(to: tableView.rx.items(dataSource: datasource)).disposed(by: disposeBag)
        
        viewModel?.output.playMedia
            .subscribe(onNext: { [weak self] id in
                self?.playVideo(id: id)
            })
            .disposed(by: disposeBag)
        
        viewModel?.output.openRocket
            .subscribe(onNext: { [weak self] id in
                self?.openRocket(id: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func playVideo(id: String) {
    }
    private func openRocket(id: String) {
//        let viewController: RocketDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RocketDetailViewController") as! RocketDetailViewController
//        self.present(viewController, animated: true, completion: nil)
        self.performSegue(withIdentifier: "presentInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? RocketDetailViewController {
            print("")
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
}

final class MainMediaItemCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var thumbImageView: UIImageView!
    
    private func setupView() {
        self.selectionStyle = .none
        thumbImageView = UIImageView()
        thumbImageView.contentMode = .scaleAspectFit
        contentView.addSubview(thumbImageView)
        thumbImageView.snp.makeConstraints { maker in
            maker.width.height.equalTo(160)
            maker.center.equalToSuperview()
            maker.edges.equalToSuperview().inset(32)
        }
    }
    
    func bind(item: MainViewContract.MediaDisplayItem) {
        if let url = URL(string: item.thumbURL) {
            thumbImageView.af.setImage(withURL: url)
        }
    }
}
