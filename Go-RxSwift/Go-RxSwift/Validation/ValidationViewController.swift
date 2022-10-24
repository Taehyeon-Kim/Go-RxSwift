//
//  ValidationViewController.swift
//  Go-RxSwift
//
//  Created by taekki on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit


final class ValidationViewController: UIViewController {
    
    private let minEmailLength = 5
    private let minPasswordLength = 6
    
    private let emailTextField = UITextField()
    private let emailValidLabel = UILabel()
    
    private let passwordTextField = UITextField()
    private let passwordValidLabel = UILabel()
    
    private let doneButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        bind()
    }
    
    private func layout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailTextField)
        emailTextField.placeholder = "이메일을 입력하세요."
        emailTextField.borderStyle = .line
        emailTextField.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
        
        view.addSubview(emailValidLabel)
        emailValidLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.placeholder = "비밀번호를 입력하세요."
        passwordTextField.borderStyle = .line
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailValidLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        
        view.addSubview(passwordValidLabel)
        passwordValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        view.addSubview(doneButton)
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = .red
        doneButton.snp.makeConstraints {
            $0.top.equalTo(passwordValidLabel.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}

extension ValidationViewController {
    
    private func bind() {
        emailValidLabel.text = "Email has to be at least \(minEmailLength) characters."
        passwordValidLabel.text = "Email has to be at least \(minPasswordLength) characters."
        
        let emailValid = emailTextField.rx.text.orEmpty
            .map { $0.count >= self.minEmailLength }
            .share(replay: 1)

        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= self.minPasswordLength }
            .share(replay: 1)
        
        let resultValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
            // .debug("Result")
        
        emailValid
            .bind(to: emailValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        emailValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordValidLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        resultValid
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        resultValid
            .map { $0 ? UIColor.green : UIColor.red }
            .bind(to: doneButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .subscribe { [weak self] _ in
                self?.showAlert()
            }
            .disposed(by: disposeBag)
        
        /// share 테스트 위한 부분
        /// resultValid에 했을 때는 subscribed가 2번 일어나던데 무슨 차이인지 모르겠음
        let networkRequestAPI = Observable.of(100).debug("networkRequestAPI")

        let result = doneButton.rx.tap
            .flatMap { networkRequestAPI }
            .share(replay: 1)
        
        result
            .map { $0 > 0 }
            .bind(to: doneButton.rx.isHidden)
            .disposed(by: disposeBag)

        // bind(to:)는subscribe()의 별칭(Alias)으로 Subscribe()를 호출한 것과 동일
        result
            .map { "Count:\($0)" }
            .bind(to: passwordValidLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
