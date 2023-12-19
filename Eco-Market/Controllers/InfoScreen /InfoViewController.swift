//
//  InfoViewController.swift
//  Eco-Market
//
//  Created by anjella on 16/12/23.
//

import UIKit

class InfoViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
//        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "info_image")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Эко Маркет"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(red: 0.673,
                                  green: 0.671,
                                  blue: 0.679,
                                  alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = """
        Фрукты, овощи, зелень, сухофрукты а так же сделанные из натуральных ЭКО продуктов (варенье, салаты, соления, компоты и т.д.) можете заказать удобно, качественно и по доступной цене.
        Готовы сотрудничать взаимовыгодно с магазинами.
        Наши цены как на рынке.
        Мы заинтересованы в экономии ваших денег и времени.
        Стоимость доставки 150 сом и ещё добавлен для окраину города.
        При отказе подтвержденного заказа более
        2-х раз Клиент заносится в чёрный список!!
        """
        return label
    }()
    
    private lazy var callButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Позвонить", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.973,
                                         green: 0.973,
                                         blue: 0.973,
                                         alpha: 1)
        // Добавляем изображение к кнопке
        let image = UIImage(named: "call_icon")
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var whatsAppButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("WhatsApp", for: .normal)
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.973,
                                         green: 0.973,
                                         blue: 0.973,
                                         alpha: 1)
        let image = UIImage(named: "whatsApp_icon")
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var instagramButton: UIButton = {
        let button = UIButton()
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        button.setTitle("Instagram", for: .normal)
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.973,
                                         green: 0.973,
                                         blue: 0.973,
                                         alpha: 1)
        let image = UIImage(named: "instagram_icon")
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Инфо"
    }
    
    override func loadView() {
        super.loadView()
        setUpUI()
    }
}

extension InfoViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(infoImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(callButton)
        contentView.addSubview(whatsAppButton)
        contentView.addSubview(instagramButton)
    }
    
    private func setUpConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(-96)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.width.equalTo(scrollView.snp.width)
        }

        infoImage.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.height.equalTo(270)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(infoImage.snp.bottom).offset(16)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.width.equalTo(343)
            $0.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.width.equalTo(343)
            $0.height.equalTo(266)
        }
        
        callButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(33)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.width.equalTo(343)
            $0.height.equalTo(54)
        }
        
        whatsAppButton.snp.makeConstraints {
            $0.top.equalTo(callButton.snp.bottom).offset(12)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.width.equalTo(343)
            $0.height.equalTo(54)
        }
        
        instagramButton.snp.makeConstraints {
            $0.top.equalTo(whatsAppButton.snp.bottom).offset(12)
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.width.equalTo(343)
            $0.height.equalTo(54)
            $0.bottom.equalTo(-16)
        }
    }
}
