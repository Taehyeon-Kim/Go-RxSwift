//
//  PickerExampleViewController.swift
//  Go-RxSwift
//
//  Created by taekki on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift

final class PickerExampleViewController: UIViewController {
    
    private let pickerView1 = UIPickerView()
    private let pickerView2 = UIPickerView()
    private let pickerView3 = UIPickerView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureHierarchy()
        setupPickerView()
    }
}

extension PickerExampleViewController {
    
    private func configureHierarchy() {
        view.addSubview(pickerView1)
        // pickerView1.backgroundColor = .red
        pickerView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pickerView1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pickerView1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pickerView1.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        view.addSubview(pickerView2)
        // pickerView2.backgroundColor = .yellow
        pickerView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView2.topAnchor.constraint(equalTo: pickerView1.bottomAnchor),
            pickerView2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pickerView2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pickerView2.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        
        view.addSubview(pickerView3)
        // pickerView3.backgroundColor = .blue
        pickerView3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView3.topAnchor.constraint(equalTo: pickerView2.bottomAnchor),
            pickerView3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pickerView3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pickerView3.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupPickerView() {
        
        // PickerView1
        Observable.just([1, 2, 3])
            .bind(to: pickerView1.rx.itemTitles) { row, item in
                // print(row, item)
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe { models in
                print("Model selected 1: \(models)")
            }
            .disposed(by: disposeBag)
        
     
        // PickerView2
        Observable.just([1, 2, 3])
            .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(
                    string: "\(item)",
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.cyan,
                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                    ]
                )
            }
            .disposed(by: disposeBag)
        
        // PickerView3
        /// View for row : 행의 관한 뷰 설정
        Observable.just([UIColor.red, UIColor.green, UIColor.brown])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
    }
}
