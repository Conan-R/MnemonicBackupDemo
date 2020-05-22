//
//  RLWaterFlowLayout.swift
//  RLMnemonicBackupDemo
//
//  Created by iOS on 2020/5/22.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit

protocol RLWaterFlowLayoutDelegate: class {
    func mnemonicLayout(layout: RLWaterFlowLayout, indexPath: IndexPath) -> CGFloat
}

class RLWaterFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: RLWaterFlowLayoutDelegate?
    var rowHeight: CGFloat = 0.0
    
    private var contentHeight: CGFloat = 0
    
    private var framesArray = [CGRect]()
    
    func reloadLayout() {
        framesArray.removeAll()
        caculateFrames()
    }
    
    override init() {
        super.init()
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollDirection = .vertical
    }
    
    override func prepare() {
        super.prepare()
        
        framesArray.removeAll()
        caculateFrames()
    }
    
    private func caculateFrames() {
        guard framesArray.count == 0, let collectionView = collectionView else  { return }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        for i in 0..<itemsCount {
            var x: CGFloat = sectionInset.left + collectionView.contentInset.left
            var y: CGFloat = sectionInset.top + collectionView.contentInset.top
            
            let preRow = i - 1
            if preRow >= 0 {
                let preCellFrame = framesArray[preRow]
                x = preCellFrame.origin.x + preCellFrame.size.width + minimumInteritemSpacing
                y = preCellFrame.origin.y
            }
            
            let currentIndexPath = IndexPath(row: i, section: 0)
            guard var currentWidth = delegate?.mnemonicLayout(layout: self, indexPath: currentIndexPath) else {
                return
            }
            
            let maxCellWidth = collectionView.frame.width - sectionInset.left - sectionInset.right - collectionView.contentInset.left - collectionView.contentInset.right
            currentWidth = min(currentWidth, maxCellWidth)
            
            if (x + currentWidth > collectionView.frame.width - sectionInset.right - collectionView.contentInset.right) {
                // 超出范围换行
                x = sectionInset.left
                y += rowHeight + minimumLineSpacing
            }
            
            // 创建属性
            let currentCellFrame = CGRect(x: x, y: y, width: currentWidth, height: rowHeight)
            framesArray += [currentCellFrame]
            
            // 高度
            if i == itemsCount - 1 {
                contentHeight = y + rowHeight + sectionInset.bottom + collectionView.contentInset.bottom
            }
        }
    }
    
    // MARK: - 当尺寸有所变化时，重新刷新
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let attributes = super.layoutAttributesForElements(in: rect)!
        var attributesCopy = [UICollectionViewLayoutAttributes]()
        
        for itemAttributes in attributes {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            attributesCopy.append(itemAttributesCopy)
        }
        
        return attributesCopy.map { attr in
            let currentFrame = framesArray[attr.indexPath.item]
            attr.frame = currentFrame
            return attr
        }
    }
    
    override var collectionViewContentSize: CGSize {
        guard let colletionView = collectionView else {
            return CGSize(width: 0, height: 0)
        }
        
        return CGSize(width: colletionView.bounds.width-colletionView.contentInset.left-colletionView.contentInset.right, height: rowHeight)
    }
    
}
