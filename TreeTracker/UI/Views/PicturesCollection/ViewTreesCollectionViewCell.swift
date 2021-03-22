//
//  ViewTreesCollectionViewCell.swift
//  TreeTracker
//
//  Created by Remi Varghese on 11/2/20.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class ViewTreesCollectionViewCell: UICollectionViewCell {
    
    static let customCellIdentifier = "ViewTreesCollectionViewCell"
    @IBOutlet weak var treesImage: UIImageView!
    private var downloadTask: URLSessionTask?
    private var documentManager = DocumentManager(fileManager: .default)
    
    func loadImageTree(tree: Tree) {
        if tree.uploaded {
            loadRemoteImage(tree: tree)}
        else {
            loadLocalImage(tree: tree)
        }
    }
    
    private func loadLocalImage(tree: Tree) {
        if let localPhotoPath = tree.localPhotoPath {
            let result = documentManager.retrieveData(withFileName: localPhotoPath)
            switch result {
            case .success(let data):
                self.loadImage(withData: data)
            case .failure:
                break
            }
        }
    }
    
    private func loadRemoteImage(tree: Tree) {
        guard let photoURL = tree.photoURL, let url = URL(string: photoURL) else {
            return
        }
        self.downloadTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                self?.loadImage(withData: data)
            }
        }
            self.downloadTask?.resume()
    }
    
    private func loadImage(withData data: Data) {
        if let image = UIImage(data: data) {
            self.treesImage.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.treesImage.image = nil
        self.downloadTask?.cancel()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
