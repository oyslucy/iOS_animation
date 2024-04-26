//
//  ToastViewController.swift
//  Animation
//
//  Created by 오연서 on 4/26/24.
//

import UIKit
import SnapKit
import Then

final class ToastViewController: UIViewController {
    
    // MARK: - UIView
    
    private let rabbitImage = UIImageView().then {
        $0.image = .rabbit
    }
    
    private lazy var clickButton = UIButton().then {
        $0.setTitle("click me!", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(doToast), for: .touchUpInside)
    }
    
    //private let toastView = ToastView()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground()
        initViews()
        initConstraints()
    }
    
    @objc func doToast() {
        let text = ["울지마", "파이팅", "눈물닦아", "오열중...", "왜울어?"].randomElement()!
        
        if(text == "왜울어?"){
            clickButton.shakeButton()
        }
        self.showToast(title: text)
    }
    
    func showToast(title: String) {
        let toastView = ToastView(title: title)
        toastView.layer.cornerRadius = 20
        
        self.view.addSubviews(toastView)
        
        toastView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
            $0.leading.equalToSuperview().inset(230)
            $0.height.equalTo(45)
            $0.width.equalTo(100)
        }
        
        UIView.animate(withDuration: 2.0) {
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
    
    // MARK: - init functions
    
    private func initBackground() {
        self.view.backgroundColor = .white
    }
    
    private func initViews() {
        self.view.addSubviews(rabbitImage, clickButton)
    }
    
    private func initConstraints() {
        
        rabbitImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(200)
        }
        
        clickButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(70)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(55)
        }
    }
}
