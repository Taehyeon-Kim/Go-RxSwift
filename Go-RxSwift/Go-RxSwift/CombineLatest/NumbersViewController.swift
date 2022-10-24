//
//  NumbersViewController.swift
//  Go-RxSwift
//
//  Created by taekki on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift

final class NumbersViewController: UIViewController {
    
    private let textField1 = UITextField()
    private let textField2 = UITextField()
    private let textField3 = UITextField()
    private let resultLabel = UILabel()
    
    private lazy var textFieldVStackView = UIStackView(
        arrangedSubviews: [
            textField1,
            textField2,
            textField3,
            resultLabel
        ])
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        combineNumbers()
    }
}

extension NumbersViewController {
    
    private func layout() {
        view.backgroundColor = .systemBackground
        
        textFieldVStackView.backgroundColor = .yellow
        textFieldVStackView.axis = .vertical
        textFieldVStackView.distribution = .fillEqually
        
        textField1.backgroundColor = .systemGray
        textField1.placeholder = "첫번째 숫자를 입력해주세요."
        
        textField2.backgroundColor = .systemGray2
        textField2.placeholder = "두번째 숫자를 입력해주세요."
        
        textField3.backgroundColor = .systemGray3
        textField3.placeholder = "세번째 숫자를 입력해주세요."
        
        resultLabel.text = "➡️ 덧셈 결과는 과연?"
        
        view.addSubview(textFieldVStackView)
        textFieldVStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textFieldVStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textFieldVStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textFieldVStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textFieldVStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension NumbersViewController {
    
    private func combineNumbers() {
        Observable.combineLatest(
            textField1.rx.text.orEmpty,
            textField2.rx.text.orEmpty,
            textField3.rx.text.orEmpty
        ) { val1, val2, val3 -> Int in
            
            // 다음과 같이 작성하게 되면 에러가 발생하게 된다.
            // return Int(val1) + Int(val2) + Int(val3)
            /*
             The compiler is unable to type-check this expression in reasonable time;
             try breaking up the expression into distinct sub-expressions
             */
            // 그 이유는 Int 타입이 반환되어야 하는데,
            // 각각의 TextField에 "" 값이 들어오게 되면 계산 자체를 할 수가 없기 때문이다.
            
            return Int(val1) ?? 0 + Int(val2) ?? 0 + Int(val3) ?? 0
        }
        .map { $0.description }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
}
