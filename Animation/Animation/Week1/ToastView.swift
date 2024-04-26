//
//  ToastView.swift
//  Animation
//
//  Created by 오연서 on 4/26/24.
//

import UIKit
import SnapKit
import Then

class ToastView: UIView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.setLayout()
        self.titleLabel.text = title
    }
    
    private func setLayout() {
        self.backgroundColor = .lightGray
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.text = ""
        $0.textColor = .white
        $0.textAlignment = .center
    }
}



