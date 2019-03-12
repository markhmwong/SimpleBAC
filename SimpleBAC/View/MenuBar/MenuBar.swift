//
//  TopMenuBar.swift
//  LastDrop
//
//  Created by Mark Wong on 19/8/18.
//  Copyright © 2018 Mark Wong. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellId = "MenuCell"
    let menuBarNames = ["DETAILS", "DRINKS"]
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    var menuBarItems: NSLayoutConstraint?
    let horizontalHighlightBar = UIView()
    
    //add the collectionview
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCollectionView()
//        self.setupHorizontalHighlightBar()
        
        menuBarItems = collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        menuBarItems?.isActive = true
    }
    
    override func layoutSubviews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isUserInteractionEnabled = true
        self.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    //not in use
    func setupHorizontalHighlightBar() {
        horizontalHighlightBar.backgroundColor = UIColor.white
        horizontalHighlightBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalHighlightBar)
        
        collectionView.backgroundColor = UIColor.clear
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBarNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.placeHolderLabel.text = menuBarNames[indexPath.item]
        
        if (indexPath.item == 0) {
            cell.placeHolderLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        }
        else if (indexPath.item == 2) {
            cell.placeHolderLabel.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
        }
        else {
            cell.placeHolderLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 3, height: self.frame.height)
    }
    
    //removes spacing between the items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
