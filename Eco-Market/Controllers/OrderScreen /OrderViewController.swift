//
//  OrderViewController.swift
//  Eco-Market
//
//  Created by anjella on 28/12/23.
//

import UIKit

class OrderViewController: UIViewController {

    private lazy var phoneNumberTF: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Номер телефона"
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.textContentType = .init(rawValue: "")
        return textField
    }()
    
    private lazy var phoneNumberLine: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor =  UIColor(red: 0.824,
                                              green: 0.82,
                                              blue: 0.835,
                                              alpha: 1).cgColor
        return view
    }()
    
    private lazy var addressTF: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Адрес"
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.textContentType = .init(rawValue: "")
        return textField
    }()
    
    private lazy var addressLine: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor =  UIColor(red: 0.824,
                                              green: 0.82,
                                              blue: 0.835,
                                              alpha: 1).cgColor
        return view
    }()
    
    private lazy var landmarkTF: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Ориентир"
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.textContentType = .init(rawValue: "")
        return textField
    }()
    
    private lazy var landmarkLine: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor =  UIColor(red: 0.824,
                                              green: 0.82,
                                              blue: 0.835,
                                              alpha: 1).cgColor
        return view
    }()
    
    private lazy var commentsTF: UITextField = {
        var textField = UITextField()
        textField.placeholder = "Комментарии"
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.font = UIFont(name: "Avenir Next", size: 16)
        textField.textContentType = .init(rawValue: "")
        return textField
    }()
    
    private lazy var commentsLine: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor =  UIColor(red: 0.824,
                                              green: 0.82,
                                              blue: 0.835,
                                              alpha: 1).cgColor
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

        navigationItem.title = "Оформление заказа"
    }
}

extension OrderViewController {
    private func setUpUI() {
        setUpSubviews()
        setUpConstraints()
    }
    
    private func setUpSubviews() {
        view.addSubview(phoneNumberTF)
        phoneNumberTF.addSubview(phoneNumberLine)
        
        view.addSubview(addressTF)
        addressTF.addSubview(addressLine)
        
        view.addSubview(landmarkTF)
        landmarkTF.addSubview(landmarkLine)
        
        view.addSubview(commentsTF)
        commentsTF.addSubview(commentsLine)
    }
    
    private func setUpConstraints() {
        phoneNumberTF.snp.makeConstraints {
            $0.top.equalToSuperview().offset(101)
            $0.height.equalTo(39)
            $0.width.equalTo(343)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        phoneNumberLine.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTF.snp.bottom).offset(3)
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        addressTF.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTF.snp.bottom).offset(20)
            $0.height.equalTo(39)
            $0.width.equalTo(343)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        addressLine.snp.makeConstraints {
            $0.top.equalTo(addressTF.snp.bottom).offset(3)
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        landmarkTF.snp.makeConstraints {
            $0.top.equalTo(addressTF.snp.bottom).offset(20)
            $0.height.equalTo(39)
            $0.width.equalTo(343)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        landmarkLine.snp.makeConstraints {
            $0.top.equalTo(landmarkTF.snp.bottom).offset(3)
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        commentsTF.snp.makeConstraints {
            $0.top.equalTo(landmarkTF.snp.bottom).offset(20)
            $0.height.equalTo(39)
            $0.width.equalTo(343)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        commentsLine.snp.makeConstraints {
            $0.top.equalTo(commentsTF.snp.bottom).offset(3)
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
}
