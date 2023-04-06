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
            notesTextField.delegate = self
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

        viewModel?.recallSavedNote()
        addEndEditingBackgroundTapGesture()
        addKeyboardToolbar()
    }

    @IBAction func saveNote(_ sender: Any) {
        guard notesTextField.text != L10n.Notes.placeholder else {
            return
        }
        viewModel?.didAddNote(note: notesTextField.text)
    }
}

// MARK: - Keyboard
private extension NotesViewController {

    func addKeyboardToolbar() {

        let toolbar: UIToolbar = UIToolbar(
            frame: CGRect(
                origin: .zero,
                size: CGSize(width: self.view.frame.size.width, height: 30.0)
            )
        )

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let doneButton: UIBarButtonItem = UIBarButtonItem(
            title: L10n.Keyboard.Toolbar.DoneButton.title,
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )

        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()

        self.notesTextField.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension NotesViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == L10n.Notes.placeholder {
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

// MARK: - NotesViewModelViewDelegate
extension NotesViewController: NotesViewModelViewDelegate {

    func notesViewModel(_ notesViewModel: NotesViewModel, didHaveSavedNote note: String?) {
        notesTextField.text = note ?? L10n.Notes.placeholder
        notesTextField.textColor = (note == nil) ? .lightGray : .black
    }
}
