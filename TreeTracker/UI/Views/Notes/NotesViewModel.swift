//
//  NotesViewModel.swift
//  TreeTracker
//
//  Created by Robert Huber on 9/1/22.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import UIKit
import Treetracker_Core

protocol NotesViewModelCoordinatorDelegate: AnyObject {
    func notesViewModel(_ notesViewModel: NotesViewModel, didAddNote note: String)
}

class NotesViewModel {
    weak var coordinatorDelegate: NotesViewModelCoordinatorDelegate?
    //weak var viewDelegate: NotesViewModelViewDelegate?

    let title: String = L10n.Notes.title
    func didAddNote(note: String) {
        coordinatorDelegate?.notesViewModel(self, didAddNote: note)
    }
}