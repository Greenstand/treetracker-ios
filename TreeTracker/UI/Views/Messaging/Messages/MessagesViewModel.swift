//
//  MessagesViewModel.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 03/04/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import Foundation
import Treetracker_Core

protocol MessagesViewModelViewDelegate: AnyObject {

}

class MessagesViewModel {

    weak var viewDelegate: MessagesViewModelViewDelegate?

    let planter: Planter
    var messages: [String] = []

    init(planter: Planter) {
        self.planter = planter
    }
}
