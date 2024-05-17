//
//  PanGestureViewController.swift
//  Animation
//
//  Created by 오연서 on 5/10/24.
//

import UIKit
import SnapKit
import Then

class PanGestureViewController: UIViewController {
    
    //MARK: - Property
    
    var timer: Timer? = nil
    var score: Int = 0
    var scores: [Int] = []
    var highScore: Int = 0
    
    //MARK: - UI

    private lazy var rabbit = UIImageView(image: .rabbit).then {
        $0.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didImageViewMoved(_:)))
        $0.addGestureRecognizer(gesture)
    }
    private let topEnemy = UIImageView(image: .shrimp)
    
    private let bottomEnemy = UIImageView(image: .shrimp)
    
    private let leadingEnemy = UIImageView(image: .shrimp)
    
    private let trailingEnemy = UIImageView(image: .shrimp)
    
    private let scoreLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    private let highScoreLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    private lazy var restartButton = UIButton().then {
        $0.setTitle("재도전!", for: .normal)
        $0.setTitleColor(.mainblue, for: .normal)
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(restartButtonTapped), for: .touchUpInside)
    }
    
    private lazy var doneButton = UIButton().then {
        $0.setTitle("게임종료!", for: .normal)
        $0.setTitleColor(.mainblue, for: .normal)
        $0.isHidden = true
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(doneButtonTapped)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBackground()
        initConstraints()
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    open func startTimer() {
        guard timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 0.5,
                                          target: self,
                                          selector: #selector(self.enemyMove),
                                          userInfo: nil,
                                          repeats: true)
        score = 0
        scoreLabel.isHidden = true
    }
    
    open func stopTimer() {
        timer?.invalidate()
        timer = nil
        [scoreLabel, highScoreLabel, doneButton, restartButton].forEach {
            $0.isHidden = false
        }
        [topEnemy, leadingEnemy, trailingEnemy, bottomEnemy].forEach {
            $0.isHidden = true
        }
    }
    
    @objc func doneButtonTapped() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.restartButton.transform = CGAffineTransform(rotationAngle: .pi)
        } completion: { _ in
            self.restartButton.transform = .identity
        }
    }
    
    @objc func restartButtonTapped() {
        initBackground()
        initConstraints()
        startTimer()
        [doneButton, restartButton, scoreLabel, highScoreLabel].forEach {
            $0.isHidden = true
        }
        [topEnemy, leadingEnemy, trailingEnemy, bottomEnemy].forEach {
            $0.isHidden = false
        }
    }
    
    func initBackground(){
        self.view.backgroundColor = .mainblue
    }
    
    func initConstraints() {
        self.view.addSubviews(rabbit, scoreLabel, highScoreLabel, doneButton, restartButton,
                              topEnemy, leadingEnemy, trailingEnemy, bottomEnemy)
        
        rabbit.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        highScoreLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(highScoreLabel.snp.bottom).offset(5)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(200)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        restartButton.snp.makeConstraints{
            $0.centerX.height.width.equalTo(doneButton)
            $0.top.equalTo(doneButton.snp.bottom).offset(5)
        }
        
        topEnemy.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        leadingEnemy.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        trailingEnemy.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        bottomEnemy.snp.makeConstraints {
            $0.bottom.centerX.equalToSuperview()
            $0.size.equalTo(50)
        }
    }
    
    @objc private func enemyMove() {
        var topEnemyY = self.topEnemy.frame.origin.y
        topEnemyY += 10
        self.topEnemy.frame = .init(origin: .init(x: self.topEnemy.frame.origin.x,
                                                  y: topEnemyY),
                                    size: self.topEnemy.frame.size)
        
        var bottomEnemyY = self.bottomEnemy.frame.origin.y
        bottomEnemyY -= 10
        self.bottomEnemy.frame = .init(origin: .init(x: self.bottomEnemy.frame.origin.x,
                                                     y: bottomEnemyY),
                                       size: self.bottomEnemy.frame.size)
        
        var leadingEnemyX = self.leadingEnemy.frame.origin.x
        leadingEnemyX += 10
        self.leadingEnemy.frame = .init(origin: .init(x: leadingEnemyX,
                                                      y: self.leadingEnemy.frame.origin.y),
                                        size: self.leadingEnemy.frame.size)
        
        var trailingEnemyX = self.trailingEnemy.frame.origin.x
        trailingEnemyX -= 10
        self.trailingEnemy.frame = .init(origin: .init(x: trailingEnemyX,
                                                       y: self.trailingEnemy.frame.origin.y),
                                         size: self.trailingEnemy.frame.size)
        self.calculatePositionReached()
    }
    
    @objc private func didImageViewMoved(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: rabbit)
        let changedX = rabbit.center.x + transition.x
        let changedY = rabbit.center.y + transition.y
        
        self.rabbit.center = .init(x: changedX, y: changedY)
        sender.setTranslation(.zero, in: self.rabbit)
    }
    
    private func calculatePositionReached() {
        let enemies = [self.topEnemy, self.leadingEnemy, self.trailingEnemy, self.bottomEnemy]

        for enemy in enemies {
            if self.rabbit.frame.minX <= enemy.frame.minX &&
                self.rabbit.frame.maxX >= enemy.frame.maxX &&
                self.rabbit.frame.minY <= enemy.frame.minY &&
                self.rabbit.frame.maxY >= enemy.frame.maxY
            {
                
                setScore()
            } else {
                self.score += 10
            }
        }
    }
    
    private func setScore() {
        scores.append(self.score)
        highScore = scores.max()!
        scoreLabel.text = "점수:\(self.score)"
        highScoreLabel.text = self.score > highScore ? "최고 기록: \(self.score)" : "최고 기록: \(highScore)"
        self.stopTimer()
    }
}
