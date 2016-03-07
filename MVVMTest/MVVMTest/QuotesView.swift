//
//  QuotesView.swift
//  MVVMTest
//
//  Created by Arvind Subramanian on 3/6/16.
//  Copyright © 2016 WeddingWire. All rights reserved.
//

import UIKit
import SnapKit

class QuotesView: UIView {
    lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 0
        self.addSubview(label)
        return label
    }()
    
    lazy var creatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        self.addSubview(label)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .greenColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        quoteLabel.snp_updateConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
        }
        
        creatorLabel.snp_updateConstraints { (make) -> Void in
            make.leading.equalTo(self)
            make.trailing.equalTo(self.snp_trailingMargin)
            make.bottom.equalTo(self)
        }
        
        super.updateConstraints()
    }
    
    func setupWithDisplayObject(obj: QuotesViewViewModel) {
        quoteLabel.text = obj.quoteText
        creatorLabel.text = obj.quoteAuthor
    }
}