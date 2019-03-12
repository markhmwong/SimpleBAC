//
//  BaseCALabel
//  LastDrop
//
//  Created by Mark Wong on 13/9/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class BaseCALabel: CATextLayer {
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.setupText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupText() {

    }
    
}
