//
//  NotesViewModel.swift
//  TreeTracker
//
//  Created by Robert Huber on 9/1/22.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import UIKit

protocol NotesViewModelCoordinatorDelegate: AnyObject {
    func notesViewModel(_ notesViewModel: NotesViewModel, didAddNote note: String)
}

protocol NotesViewModelViewDelegate: AnyObject {
    func notesViewModel(_ notesViewModel: NotesViewModel, didHaveSavedNote note: String?)
}

class NotesViewModel {

    weak var coordinatorDelegate: NotesViewModelCoordinatorDelegate?
    weak var viewDelegate: NotesViewModelViewDelegate?

    private var note: String?
    let title: String = L10n.Notes.title

    init(note: String?) {
        self.note = note
    }

    func didAddNote(note: String) {
        coordinatorDelegate?.notesViewModel(self, didAddNote: note)
    }

    func recallSavedNote() {
        viewDelegate?.notesViewModel(self, didHaveSavedNote: note)
    }
}
