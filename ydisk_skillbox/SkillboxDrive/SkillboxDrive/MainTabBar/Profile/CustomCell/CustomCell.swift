//
//  CustomCell.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 14.11.2023.
//

import Foundation
import UIKit

final class CustomCell: UITableViewCell {
    
    private var nameFile = UILabel()
    private var sizeFile = UILabel()
    private var dateFile = UILabel()
    private var timeFile = UILabel()
    private var imageViewFile = UIImageView()
    private var menuButton = UIButton()

    private var firstStackView = UIStackView()
    private var secondStackView = UIStackView()
    private var thirdStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(firstStackView)
        configureViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        
        nameFile.font = .systemFont(ofSize: 16, weight: .semibold)
        nameFile.textColor = .black
        
        sizeFile.font = .systemFont(ofSize: 12, weight: .regular)
        sizeFile.textColor = .lightGray
        
        dateFile.font = .systemFont(ofSize: 12, weight: .regular)
        dateFile.textColor = .lightGray
        
        timeFile.font = .systemFont(ofSize: 12, weight: .regular)
        timeFile.textColor = .lightGray
        
        imageViewFile.image = Constants.Image.folder
        
        menuButton.setImage(Constants.Image.menu, for: .normal)
        
        firstStackView.axis = .horizontal
        firstStackView.alignment = .center
        firstStackView.spacing = 8
        
        secondStackView.axis = .vertical
        secondStackView.alignment = .leading
        secondStackView.spacing = 6
        
        thirdStackView.axis = .horizontal
        thirdStackView.alignment = .center
        thirdStackView.spacing = 16
    }
    
    private func setupConstraints() {
        nameFile.translatesAutoresizingMaskIntoConstraints = false
        sizeFile.translatesAutoresizingMaskIntoConstraints = false
        dateFile.translatesAutoresizingMaskIntoConstraints = false
        timeFile.translatesAutoresizingMaskIntoConstraints = false
        imageViewFile.translatesAutoresizingMaskIntoConstraints = false
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thirdStackView)
        firstStackView.addArrangedSubview(sizeFile)
        firstStackView.addArrangedSubview(dateFile)
        firstStackView.addArrangedSubview(timeFile)
        secondStackView.addArrangedSubview(nameFile)
        secondStackView.addArrangedSubview(firstStackView)
        thirdStackView.addArrangedSubview(imageViewFile)
        thirdStackView.addArrangedSubview(secondStackView)
        thirdStackView.addArrangedSubview(menuButton)
        
        NSLayoutConstraint.activate([
            
            imageViewFile.widthAnchor.constraint(equalToConstant: 30),
            imageViewFile.heightAnchor.constraint(equalToConstant: 30),
            
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30),
            
            thirdStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            thirdStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            thirdStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            thirdStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }
    
    func configureCell(_ viewModel: PublishedItems) {
//        filmIDforCell = viewModel.filmID ?? 000
        print("Сработал метод configure из модуля CustomCell")
//        let url = URL(string: viewModel.posterUrl ?? "https://kinopoiskapiunofficial.tech/images/posters/kp/2213.jpg")
//        downloadImage(from: url!)
        let str = String(Int(viewModel.size ?? 0))
        nameFile.text = viewModel.name
        sizeFile.text = str
        dateFile.text = viewModel.created
        timeFile.text = viewModel.created
    }
}
