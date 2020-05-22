//
//  UILabel+Extension.swift
//  RLMnemonicBackupDemo
//
//  Created by iOS on 2020/5/22.
//  Copyright © 2020 beiduofen. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(title: String,
                     color: UIColor,
                     fontSize: UIFont,
                     alignment: NSTextAlignment = .left,
                     lines: Int = 1){
        self.init()
        text = title
        textColor = color
        font = fontSize
        textAlignment = alignment
        numberOfLines = lines
    }
}
