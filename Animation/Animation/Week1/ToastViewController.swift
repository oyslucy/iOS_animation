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
    
    var locationAngle = 0
    var isRotating = true
    
    // MARK: - UIView
    
    private let rabbitImage = UIImageView().then {
        $0.image = .rabbit
    }
    
    private lazy var moveLeftButton = UIButton().then {
        $0.setTitle("move me to left!", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(didMoveImageLeft), for: .touchUpInside)
    }
    
    private lazy var moveRightButton = UIButton().then {
        $0.setTitle("move me to right!", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(didMoveImageRight), for: .touchUpInside)
    }
    
    private lazy var rotateButton = UIButton().then {
        $0.setTitle("rotate me!", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(toggleRotation), for: .touchUpInside)
    }
    
    private lazy var clickButton = UIButton().then {
        $0.setTitle("click me!", for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(doToast), for: .touchUpInside)
    }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground()
        initViews()
        initConstraints()
    }
    
    @objc func didMoveImageLeft() {
        UIView.animate(withDuration: 0.5) { [self] in
            rabbitImage.transform = CGAffineTransform(translationX: -50, y: 0)
        }
    }
    
    @objc func didMoveImageRight() {
        UIView.animate(withDuration: 0.5) { [self] in
            rabbitImage.transform = CGAffineTransform(translationX: 50, y: 0)
        }
    }
    
    @objc private func toggleRotation() {
        isRotating ? doRotate() : doStopRotate()
    }
    
    @objc func doRotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2
        rotation.duration = 0.5
        rotation.repeatCount = Float.infinity  //무한번 회전
        rabbitImage.layer.add(rotation, forKey: "rotationAnimation")
        rotateButton.setTitle("Stop me!", for: .normal)
        isRotating.toggle()

    }
    
    @objc func doStopRotate() {
        rabbitImage.layer.removeAnimation(forKey: "rotationAnimation") //애니메이션 제거
        rotateButton.setTitle("Rotate me!", for: .normal)
        isRotating.toggle()
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
        self.view.addSubviews(moveLeftButton, moveRightButton, rabbitImage, rotateButton, clickButton)
    }
    
    private func initConstraints() {
        
        rabbitImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(200)
        }
        
        moveLeftButton.snp.makeConstraints {
            $0.top.equalTo(rabbitImage.snp.bottom).offset(150)
            $0.leading.equalToSuperview().inset(40)
            $0.height.equalTo(55)
            $0.width.equalTo(155)
        }
        
        moveRightButton.snp.makeConstraints {
            $0.top.height.width.equalTo(moveLeftButton)
            $0.trailing.equalToSuperview().inset(40)
        }
        
        rotateButton.snp.makeConstraints {
            $0.top.equalTo(moveLeftButton.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(55)
        }
        
        clickButton.snp.makeConstraints {
            $0.top.equalTo(rotateButton.snp.bottom).offset(5)
            $0.centerX.leading.trailing.height.equalTo(rotateButton)
        }
    }
}
