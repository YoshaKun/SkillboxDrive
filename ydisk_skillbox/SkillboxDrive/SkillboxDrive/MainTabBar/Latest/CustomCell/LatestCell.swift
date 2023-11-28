//
//  CustomCell.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 14.11.2023.
//

import Foundation
import UIKit

final class LatestCell: UITableViewCell {
    
    private let presenter: LatestCellPresenterProtocol = LatestCellPresenter()
    private var nameFile = UILabel()
    private var sizeFile = UILabel()
    private var dateFile = UILabel()
    private var timeFile = UILabel()
    private var imageViewFile = UIImageView()
    private var activityIndicator = UIActivityIndicatorView()

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
        
        nameFile.font = .systemFont(ofSize: 15, weight: .regular)
        nameFile.textColor = .black
        
        sizeFile.font = .systemFont(ofSize: 13, weight: .regular)
        sizeFile.textColor = Constants.Colors.gray
        
        dateFile.font = .systemFont(ofSize: 13, weight: .regular)
        dateFile.textColor = Constants.Colors.gray
        
        timeFile.font = .systemFont(ofSize: 13, weight: .regular)
        timeFile.textColor = Constants.Colors.gray
        
        imageViewFile.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
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
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdStackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thirdStackView)
        firstStackView.addArrangedSubview(sizeFile)
        firstStackView.addArrangedSubview(dateFile)
        firstStackView.addArrangedSubview(timeFile)
        secondStackView.addArrangedSubview(nameFile)
        secondStackView.addArrangedSubview(firstStackView)
        thirdStackView.addArrangedSubview(imageViewFile)
        thirdStackView.addArrangedSubview(secondStackView)
        
        NSLayoutConstraint.activate([
            
            imageViewFile.widthAnchor.constraint(equalToConstant: 30),
            imageViewFile.heightAnchor.constraint(equalToConstant: 30),
            
            activityIndicator.centerXAnchor.constraint(equalTo: imageViewFile.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageViewFile.centerYAnchor),
            
            thirdStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            thirdStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            thirdStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            thirdStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }
    
    // MARK: - ParseDate
    private func parseDate(_ str: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormat.date(from: str) ?? Date()

        return date
    }
    
    private func getOnlyDateRu(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ru_RU")
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        return dateFormat.string(from: date)
    }
    
    private func getOnlyTime(date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ru_RU")
        dateFormat.dateStyle = .none
        dateFormat.timeStyle = .short
        return dateFormat.string(from: date)
    }
    
    // MARK: - ConfigureCell
    
    func configureCell(_ viewModel: LatestItems) {
        
        let converter = Units.init(bytes: Int64(viewModel.size ?? 0))
        let str = converter.getReadableUnit()
        guard let initialDate = viewModel.created else { return }
        let date = parseDate(initialDate ?? "2023-11-13T18:56:09+00:00")
        
        let onlyDate = getOnlyDateRu(date: date)
        let time = getOnlyTime(date: date)
        
        nameFile.text = viewModel.name
        sizeFile.text = str
        dateFile.text = onlyDate
        timeFile.text = time
        
        guard let url = viewModel.preview else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            imageViewFile.image = Constants.Image.folder
            return
        }
        
        presenter.getImageForLatestCell(urlStr: url) { data in
            DispatchQueue.main.async() { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.imageViewFile.image = UIImage(data: data)
            }
        }
    }
}
