//
//  CustomOnboardingCell.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 10.10.2023.
//

import UIKit

class CustomOnboardingCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let descriptionOnboard = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(descriptionOnboard)
        
        let offsetForImage = contentView.frame.width / 4
        let offsetForDescription = contentView.frame.width / 6
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionOnboard.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        descriptionOnboard.numberOfLines = 0
        descriptionOnboard.textAlignment = .center
        descriptionOnboard.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offsetForImage),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offsetForImage),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offsetForImage),
            
            descriptionOnboard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offsetForDescription),
            descriptionOnboard.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: offsetForImage / 3),
            descriptionOnboard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offsetForDescription),
            descriptionOnboard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }
}
