//
//  TreeService.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 29/06/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import Foundation

protocol TreeServiceDelegate: class {
    func treeService(_ treeService: TreeService, didUpdateTrees trees: [Tree])
    func treeService(_ treeService: TreeService, didError error: Error)
}

class TreeService {

    weak var delegate: TreeServiceDelegate?

    func startMonitoringTrees(forUser: Username) {
        //Set up nsfetched results controller
        delegate?.treeService(self, didUpdateTrees: [])
    }
}
