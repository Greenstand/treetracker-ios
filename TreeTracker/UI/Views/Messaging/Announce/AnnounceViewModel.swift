//
//  AnnounceViewModel.swift
//  TreeTracker
//
//  Created by Frédéric Helfer on 31/05/23.
//  Copyright © 2023 Greenstand. All rights reserved.
//

import Foundation

protocol AnnounceViewModelViewDelegate: AnyObject {
    func announceViewModel(_ announceViewModel: AnnounceViewModel, updateView chat: ChatListViewModel.Chat)
}

class AnnounceViewModel {

    weak var viewDelegate: AnnounceViewModelViewDelegate?

    private var chat: ChatListViewModel.Chat

    init(chat: ChatListViewModel.Chat) {
        self.chat = chat
    }

    var title: String {
        return L10n.Announce.title
    }

    func updateView() {
        viewDelegate?.announceViewModel(self, updateView: chat)
    }

}
