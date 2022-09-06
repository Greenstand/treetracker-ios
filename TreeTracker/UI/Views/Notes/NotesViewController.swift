//
//  NotesViewController.swift
//  TreeTracker
//
//  Created by Robert Huber on 9/1/22.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, KeyboardDismissing {

    @IBOutlet private weak var notesTextField: UITextView! {
        didSet {
            notesTextField.layer.cornerRadius = 5
            notesTextField.layer.borderColor = Asset.Colors.primaryGreen.color.cgColor
            notesTextField.layer.borderWidth = 2
        }
    }
    @IBOutlet private weak var saveButton: PrimaryButton!
    var viewModel: NotesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextField.delegate = self
        viewModel?.recallSavedNote()
        addEndEditingBackgroundTapGesture()
        if notesTextField.text.isEmpty {
            notesTextField.textColor = UIColor.lightGray
            notesTextField.text = L10n.Notes.placeholder
        }
    }

    @IBAction func saveNote(_ sender: Any) {
        if notesTextField.textColor != UIColor.lightGray {
            viewModel?.didAddNote(note: notesTextField.text)
        }
    }
}

extension NotesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = L10n.Notes.placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}

extension NotesViewController: NotesViewModelViewDelegate {
    func notesViewModel(_ notesViewModel: NotesViewModel, didHaveSavedNote note: String?) {
        if let note = note {
            notesTextField.text = note
        }
    }
}
