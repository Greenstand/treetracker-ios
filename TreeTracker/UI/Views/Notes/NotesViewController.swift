//
//  NotesViewController.swift
//  TreeTracker
//
//  Created by Robert Huber on 9/1/22.
//  Copyright © 2022 Greenstand. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController, AlertPresenting {

    @IBOutlet private weak var notesTextField: UITextView! {
        didSet {
            notesTextField.layer.cornerRadius = 5
            notesTextField.layer.borderColor = #colorLiteral(red: 0.5254901961, green: 0.7607843137, blue: 0.1960784314, alpha: 1)
        }
    }
    @IBOutlet private weak var saveButton: PrimaryButton! {
        didSet {
            saveButton.isEnabled = true
            saveButton.isHidden = false
        }
    }
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
        if notesTextField.text.isEmpty{
            notesTextField.textColor = UIColor.lightGray
            notesTextField.text = L10n.Notes.placeholder
        }
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
                let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissMyKeyboard))
                toolbar.setItems([flexSpace, doneBtn], animated: false)
                toolbar.sizeToFit()
                self.notesTextField.inputAccessoryView = toolbar

    }

    @IBAction func saveNote(_ sender: Any) {
        if notesTextField.textColor == UIColor.lightGray {
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
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}

extension NotesViewController: NotesViewModelViewDelegate {
    func notesViewModel(_ notesViewModel: NotesViewModel, didHaveSavedNote note: String) {
        print(note)
        notesTextField.text = note
    }
}
