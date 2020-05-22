//
//  RLBackupMnemonicView.swift
//  RLMnemonicBackupDemo
//
//  Created by iOS on 2020/5/22.
//  Copyright © 2020 beiduofen. All rights reserved.
//


import UIKit
import SnapKit

enum BackupMnemonicViewType {
    case normal
    case show
    case handle
}


class RLBackupMnemonicView: UICollectionView {
    
    var type: BackupMnemonicViewType = .normal
    
    var items = [String]() {
        didSet {
            collectionViewLayout.invalidateLayout()
            reloadData()
        }
    }
    
    func changeState(text: String) {
        guard let index = items.firstIndex(of: text) else {
            return
        }
        
        guard let cell = cellForItem(at: IndexPath(item: index, section: 0)) as? RLBackupMnemonicCollectionCell else {
            return
        }
        
        cell.btnIsSelected = false
    }
    
    var removeHandler: ((String, Int, RLBackupMnemonicView)->())?

    private var rowHeight: CGFloat = 28
    
    private var showBorder: Bool = false
    
    convenience init(frame: CGRect,
                     collectionViewLayout layout: UICollectionViewLayout,
                     showBorder: Bool,
                     rowHeight: CGFloat,
                     minimumInteritemSpacing: CGFloat,
                     minimumLineSpacing: CGFloat) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.showBorder = showBorder
        let waterlayout = RLWaterFlowLayout()
        waterlayout.delegate = self
        waterlayout.rowHeight = rowHeight
        waterlayout.minimumInteritemSpacing = minimumInteritemSpacing //同一行不同cell间距
        waterlayout.minimumLineSpacing = minimumLineSpacing //行间距
        collectionViewLayout = waterlayout
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        rl_registerCellClass(RLBackupMnemonicCollectionCell.self)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RLBackupMnemonicView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.rl_dequeueReusableCell(RLBackupMnemonicCollectionCell.self, indexPath: indexPath) as RLBackupMnemonicCollectionCell
        cell.text = items[indexPath.item]
        cell.num = indexPath.item + 1
        cell.type = type
        cell.showBorder = true
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RLBackupMnemonicCollectionCell else {
            return
        }
        if let text = cell.text, text.count > 0 {
             removeHandler?(text, indexPath.item, self)
        }
    }
}

extension RLBackupMnemonicView: RLWaterFlowLayoutDelegate {
    func mnemonicLayout(layout: RLWaterFlowLayout, indexPath: IndexPath) -> CGFloat {
//        if indexPath.row < items.count {
//            let text = items[indexPath.row]
//            let width: CGFloat = "".getNormalStrW(str: text, strFont: 18, h: CGFloat.greatestFiniteMagnitude)
//            return width + 12
//        }
//
//        return 0.00001
        return ((UIScreen.main.bounds.width - 15 * 2) - 3 * 7)/4
    }
}

class RLBackupMnemonicCollectionCell: UICollectionViewCell {
    
    var btnIsSelected: Bool = false {
        didSet {
            titleBtn.isSelected = !titleBtn.isSelected
        }
    }
    
    var text: String? {
        didSet {
           titleBtn.setTitle(text, for: .normal)
        }
    }
    
    var num: Int = 1 {
        didSet {
            titleLabel.text = "\(num)"
        }
    }
    
    var type: BackupMnemonicViewType = .normal {
        didSet {
            if type == .handle {
                triangleImg.isHidden = true
                titleLabel.isHidden = true
            }
        }
    }
    
    var showBorder: Bool = false {
        didSet {
            if showBorder {
                titleBtn.layer.borderWidth = 0.5
                titleBtn.layer.borderColor = UIColor.gray.cgColor
                titleBtn.layer.cornerRadius = 5
                titleBtn.layer.masksToBounds = true
                titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(titleBtn)
        titleBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(triangleImg)
        triangleImg.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.size.equalTo(CGSize(width: 22, height: 23))
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(1.5)
            make.leading.equalToSuperview().offset(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @private lazy
    private lazy var titleBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel!.font = UIFont.systemFont(ofSize:12)
        btn.setTitle("", for: .selected)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.isEnabled = false
        btn.backgroundColor = UIColor.white
        return btn
    }()
    
    private lazy var triangleImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .center
        img.image = UIImage(named: "icon_manager_sign")
        return img
    }()
    
    private lazy var titleLabel = UILabel(
        title: "",
        color: UIColor.white,
        fontSize: UIFont.systemFont(ofSize: 10),
        alignment: .center
    )
}

