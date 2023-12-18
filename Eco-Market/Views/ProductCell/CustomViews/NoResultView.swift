//
//  NoResultView.swift
//  Eco-Market
//
//  Created by anjella on 18/12/23.
//

import UIKit

public final class NoResultView: UIView {

    lazy var noResultIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "no_results_image")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var noResultLabel: UILabel = {
        var label = UILabel()
        label.text = "Ничего не нашли"
        label.font = UIFont(name: "Avenir Next Bold", size: 17.6)
        label.textColor = UIColor(red: 0.673, green: 0.671, blue: 0.679, alpha: 1)
        return label
    }()


    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
}

extension NoResultView {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
    }

    private func setUpSubviews() {
        addSubview(noResultIcon)
        addSubview(noResultLabel)
    }

    private func setUpConstraints() {

        noResultIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(15.5)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(163)
            $0.height.equalTo(200)
        }

        noResultLabel.snp.makeConstraints {
            $0.top.equalTo(noResultIcon.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(15.5)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(159)
            $0.height.equalTo(26)
        }
    }
}
