//
//  TableExampleViewController.swift
//  Go-RxSwift
//
//  Created by taekki on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class TableExampleViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, elem, cell in
                cell.textLabel?.text = "\(elem) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe { value in
                print("Tapped \(value)")
            }
            .disposed(by: disposeBag)
        
        // tableView.rx
        //     .itemAccessoryButtonTapped
        //     .subscribe { indexPath in
        //         print("Tapped @ \(indexPath)")
        //     }
        //     .disposed(by: disposeBag)
    }
}
