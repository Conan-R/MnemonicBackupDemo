//
//  RLMnemonicBackupController.swift
//  RLMnemonicBackupDemo
//
//  Created by iOS on 2020/5/22.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class RLMnemonicBackupController: UIViewController {
    
    private var mnemonicItems = ["execute", "brief", "fix", "twenty", "inhale", "possible",  "flame", "zone", "bonus", "chair", "midnight", "museum"]
    
    private var selectedMnenicItems = Array(repeating: "", count: 12)
    private var randomMnenicItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "备份钱包"
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let zip = [
            titleLabel,
            contentLabel,
            showContainerView,
            showCollectionView,
            handlerCollectionView,
            commitBtn
        ]
        
        zip.forEach { scrollView.addSubview($0) }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(46)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        contentLabel.numberOfLines = 0
        
        showCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(UIScreen.main.bounds.width-30)
            make.height.equalTo(135)
        }
        
        handlerCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(showCollectionView.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(135)
        }
        
        commitBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(45)
            make.top.equalTo(handlerCollectionView.snp.bottom).offset(45)
            make.bottom.equalToSuperview().offset(-129)
        }
        
        showCollectionView.type = .show
        handlerCollectionView.type = .handle
        showCollectionView.backgroundColor = UIColor.white
        handlerCollectionView.backgroundColor = UIColor.white
        randomMnenicItems = mnemonicItems.shuffled()
        handlerCollectionView.items = randomMnenicItems
        handlerCollectionView.removeHandler = { [weak self] (text, index, view) in
            guard let self = self else { return }
            self.randomMnenicItems.remove(at: index)
            if let index = self.selectedMnenicItems.firstIndex(of: ""){
                self.selectedMnenicItems.remove(at: index)
                self.selectedMnenicItems.insert(text, at: index)
            }
            view.items = self.randomMnenicItems
            self.showCollectionView.items = self.selectedMnenicItems
        }
        
        showCollectionView.items = selectedMnenicItems
        showCollectionView.removeHandler = { [weak self] (text, index, view) in
            guard let self = self else { return }
            self.selectedMnenicItems.remove(at: index)
            self.selectedMnenicItems.insert("", at: index)
            self.randomMnenicItems += [text]
            view.items = self.selectedMnenicItems
            self.handlerCollectionView.items = self.randomMnenicItems
        }
        
        
        commitBtn.addTarget(self, action: #selector(commitBtnTapped), for: .touchUpInside)
    }
    
    @objc private func commitBtnTapped() {
        guard self.selectedMnenicItems.elementsEqual(self.mnemonicItems) else {
            SVProgressHUD.showInfo(withStatus: "验证失败")
            return
        }
        SVProgressHUD.showSuccess(withStatus: "备份成功")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleLabel = UILabel(
        title: "确认你的钱包助记词",
        color: UIColor.black,
        fontSize: UIFont.boldSystemFont(ofSize: 16)
    )
    
    private lazy var contentLabel = UILabel(
        title: "请按顺序点击助记词，以确认您是否正确备份。",
        color: UIColor.red,
        fontSize: UIFont.boldSystemFont(ofSize: 14),
        alignment: .center
    )
    
    private lazy var commitBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .blue
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.layer.cornerRadius = 22.5
        btn.layer.masksToBounds = true
        return btn
    }()
    
    private lazy var showContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var showCollectionView: RLBackupMnemonicView = RLBackupMnemonicView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout(),
        showBorder: true,
        rowHeight: 35,
        minimumInteritemSpacing: 7,
        minimumLineSpacing: 10
    )
    
    private lazy var handlerCollectionView: RLBackupMnemonicView = RLBackupMnemonicView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout(),
        showBorder: true,
        rowHeight: 35,
        minimumInteritemSpacing: 7,
        minimumLineSpacing: 10
    )
}
