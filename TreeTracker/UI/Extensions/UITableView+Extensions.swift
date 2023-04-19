//
//  UITableView+Extensions.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 19/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import UIKit

extension UITableView {

    func addTopBounceAreaView(color: UIColor = .white) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height

        let view = UIView(frame: frame)
        view.backgroundColor = color

        self.addSubview(view)
    }
}
