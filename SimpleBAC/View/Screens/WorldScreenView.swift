//
//  WorldScreenView.swift
//  LastDrop
//
//  Created by Mark Wong on 20/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class WorldScreenView: BaseCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupView() {
        super.setupView()
        self.backgroundColor = ThemeConstants.CellViewBackground
    }
    
}
