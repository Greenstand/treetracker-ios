//
//  PicturesCollectionViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 8/10/20.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class PicturesCollectionViewController: UIViewController {

    @IBOutlet var picturesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PicturesCollectionViewController: UICollectionViewDelegate{
    
}

extension PicturesCollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

extension PicturesCollectionViewController: UICollectionViewDelegateFlowLayout{
    
}




