//
//  AddTreeViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 12/07/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit
import AVFoundation

class AddTreeViewController: UIViewController, AlertPresenting {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet private var viewfinderGuidenceImageView: UIImageView! {
        didSet {
            viewfinderGuidenceImageView.contentMode = .scaleAspectFit
            viewfinderGuidenceImageView.image = Asset.Assets.phoneViewfinder.image
            viewfinderGuidenceImageView.isHidden = true
            viewfinderGuidenceImageView.layer.zPosition = 3
        }
    }
    @IBOutlet private var treeViewFinderFocus: UIImageView! {
        didSet {
            treeViewFinderFocus.contentMode = .scaleToFill
            treeViewFinderFocus.image = Asset.Assets.focus.image
            treeViewFinderFocus.isHidden = false
            treeViewFinderFocus.layer.zPosition = 4
            treeViewFinderFocus.layer.cornerRadius = 10
            treeViewFinderFocus.frame = CGRect(x: 0, y: 0,
                                                width: previewView.bounds.size.width,
                                                height: previewView.bounds.size.height)
        }
    }
    @IBOutlet private var treeGuidenceImageView: UIImageView! {
        didSet {
            treeGuidenceImageView.contentMode = .scaleAspectFit
            treeGuidenceImageView.image = Asset.Assets.planting.image
            treeGuidenceImageView.isHidden = true
            treeGuidenceImageView.layer.zPosition = 2
        }
    }
    @IBOutlet private var treeImageView: UIImageView! {
        didSet {
            treeImageView.layer.cornerRadius = 5.0
            treeImageView.layer.masksToBounds = true
            treeImageView.clipsToBounds = true

            treeImageView.contentMode = .scaleAspectFill
            treeImageView.image = nil
            treeImageView.isHidden = true
            treeImageView.layer.zPosition = 5
            treeImageView.frame = CGRect(x: 10, y: 0,
                                         width: previewView.bounds.size.width - 20,
                                         height: previewView.bounds.size.height - 20)
        }
    }
    @IBOutlet private var gpsAccuracyLabel: GPSAccuracyLabel! {
        didSet {
            gpsAccuracyLabel.accuracy = .unknown
        }
    }
    @IBOutlet private var choosePhotoButton: PrimaryButton! {
        didSet {
            choosePhotoButton.setTitle(L10n.AddTree.PhotoLibraryButton.title, for: .normal)
            choosePhotoButton.isHidden = true
            #if DEBUG
            choosePhotoButton.isHidden = false
            #endif
        }
    }
    @IBOutlet private var retryPhotoButton: PrimaryButton! {
        didSet {
            retryPhotoButton.setTitle(L10n.AddTree.PhotoButton.Title.retry, for: .normal)
                retryPhotoButton.isEnabled = true
                retryPhotoButton.isHidden = true
        }
    }
    @IBOutlet private var takePhotoButton: PrimaryButton! {
        didSet {
            takePhotoButton.setTitle(L10n.AddTree.PhotoButton.Title.takePhoto, for: .normal)
                takePhotoButton.isEnabled = false
                takePhotoButton.isHidden = true
        }
    }
    @IBOutlet private var saveTreeButton: PrimaryButton! {
        didSet {
            saveTreeButton.setTitle(L10n.AddTree.SaveButton.title, for: .normal)
            saveTreeButton.isEnabled = false
        }
    }
    @IBOutlet weak var searchGPSSignalImageView: UIImageView! {
        didSet {
            searchGPSSignalImageView.animationImages = [
                Asset.Assets.GpsSearchAnimation.gpsLoad0,
                Asset.Assets.GpsSearchAnimation.gpsLoad1,
                Asset.Assets.GpsSearchAnimation.gpsLoad2
            ].map({$0.image})
                searchGPSSignalImageView.animationDuration = 0.9
                searchGPSSignalImageView.animationRepeatCount = 0
                searchGPSSignalImageView.image = Asset.Assets.GpsSearchAnimation.gpsLoad0.image
                searchGPSSignalImageView.startAnimating()
        }
    }
    var viewModel: AddTreeViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    let session = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var cameraView: UIView!
    let photoOutput = AVCapturePhotoOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.startMonitoringLocation()
        self.createCameraView()
        self.initializeCapture()
    }
    @IBAction func retryPhotoButtonPressed() {
        cameraView.isHidden = false
        treeImageView.isHidden = true
        retryPhotoButton.isHidden = true
        choosePhotoButton.isHidden = false
    }

}

// MARK: - Button Actions
private extension AddTreeViewController {

#if DEBUG
    @IBAction func choosePhotoButtonPressed() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
#endif

    @IBAction func takePhotoButtonPressed() {
        cameraView.isHidden = true
        choosePhotoButton.isHidden = true
        retryPhotoButton.isHidden = false
        didTakePhoto()
    }

    @IBAction func saveTreeButtonPressed() {
        viewModel?.saveTree()
        cameraView.isHidden = false
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddTreeViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let editedImage: UIImage? = info[.editedImage] as? UIImage

        guard let originalImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        picker.dismiss(animated: true) {
            self.viewModel?.updateTreeImage(treeImage: editedImage ?? originalImage)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension AddTreeViewController: UINavigationControllerDelegate { }

// MARK: - HomeViewModelViewDelegate
extension AddTreeViewController: AddTreeViewModelViewDelegate {

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateTakePhotoEnabled enabled: Bool) {
        takePhotoButton.isEnabled = enabled
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateAddTreeEnabled enabled: Bool) {
        saveTreeButton.isEnabled = enabled
    }
    
    func addTreeViewModel(_ selfieViewModel: AddTreeViewModel, didUpdateTakePhotoActionTitle title: String) {
        takePhotoButton.setTitle(title, for: .normal)
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateGPSAccuracy accuracy: AddTreeViewModel.GPSAccuracy) {
        gpsAccuracyLabel.accuracy = accuracy.gpsLabelAccuracy
        switch accuracy {
        case .good:
            searchGPSSignalImageView.stopAnimating()
            searchGPSSignalImageView.isHidden = true
            takePhotoButton.isEnabled = true
            takePhotoButton.isHidden = false
        case .bad, .unknown:
            searchGPSSignalImageView.startAnimating()
            searchGPSSignalImageView.isHidden = false
            takePhotoButton.isEnabled = false
            takePhotoButton.isHidden = true
        }
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didUpdateTreeImage image: UIImage?) {
        treeGuidenceImageView.isHidden = image != nil
        viewfinderGuidenceImageView.isHidden = image != nil
        treeImageView.isHidden = image == nil
        treeImageView.image = image
    }

    func addTreeViewModel(_ addTreeViewModel: AddTreeViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }
}

// MARK: - AddTreeViewModel.GPSAccuracy Extension
private extension AddTreeViewModel.GPSAccuracy {

    var gpsLabelAccuracy: GPSAccuracyLabel.Accuracy {
        switch self {
        case .bad:
            return .bad
        case .good:
            return .good
        case .unknown:
            return .unknown
        }
    }
}
 // MARK: - AddTreeModel AVCapture Extension
extension AddTreeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func createCameraView() {
        cameraView = UIView(frame: CGRect(x: 0, y: 0,
                            width: previewView.bounds.size.width,
                            height: previewView.bounds.size.height))
        cameraView.contentMode = .scaleAspectFit
        cameraView.layer.cornerRadius = 30
        cameraView.layer.zPosition = 0
        previewView.addSubview(cameraView)
    }
    func initializeCapture() {
        session.sessionPreset = .photo
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        captureDevice = device
        beginCapture()
    }
    func beginCapture() {
        var deviceInput: AVCaptureDeviceInput!

        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("error: cant get deviceInput")
                return
            }
            if self.session.canAddInput(deviceInput) {
                self.session.addInput(deviceInput)
            }
            guard session.canAddOutput(photoOutput) else {return}
            session.addOutput(photoOutput)
            session.commitConfiguration()
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames=true
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            videoDataOutput.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue)

            if session.canAddOutput( self.videoDataOutput ) {
                session.addOutput( self.videoDataOutput )
            }

            videoDataOutput.connection(with: .video)?.isEnabled = true

            previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

            let rootLayer: CALayer = self.cameraView.layer
            rootLayer.masksToBounds=true
            previewLayer.frame = rootLayer.bounds
            rootLayer.addSublayer(self.previewLayer)
            session.startRunning()
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }

}
// MARK: - AddTreeModel AVCapturePhotoDelegate Extension
extension AddTreeViewController: AVCapturePhotoCaptureDelegate {
    func didTakePhoto() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        if let editedImage = UIImage(data: imageData) {
            self.viewModel?.updateTreeImage(treeImage: editedImage)
        }
    }
}
