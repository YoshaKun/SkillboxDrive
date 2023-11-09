//
//  ViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 05.10.2023.
//

import DGCharts
import UIKit

protocol ProfileViewControllerProtocol {
    
}

class ProfileViewController: UIViewController, ChartViewDelegate {
    
    private let presenter: ProfilePresenterProtocol = ProfilePresenter()
    private var pieChart = PieChartView()
    private var menuButton = UIBarButtonItem()
    private var publicFilesButton = UIButton()
    private var filledLabel = UILabel()
    private var remainsLabel = UILabel()
    private var filledCircle = UIImageView()
    private var remainsCircle = UIImageView()
    private var firstStackView = UIStackView()
    private var secondStackView = UIStackView()
    
    private let size: CGFloat = 30
    private let filledGb = 10
    private let remainsGb = 20
    private var sizeOfDiskStorage = "30 гб"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        configureViews()
        configureStackView()
        configureTabBar()
        configureNavigationBar()
        configureConstraints()
        configurePieChart()
    }
        
    private func configureViews() {
        
        
        let firstString = "\(filledGb) "
        let secondString = "\(remainsGb) "
        
        view.backgroundColor = .white
        
        publicFilesButton.backgroundColor = .white
        publicFilesButton.setTitle(Constants.Text.FirstVC.publicFiles, for: .normal)
        publicFilesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        publicFilesButton.setTitleColor(.black, for: .normal)
        publicFilesButton.contentHorizontalAlignment = .left
        publicFilesButton.semanticContentAttribute = .forceRightToLeft
        publicFilesButton.layer.cornerRadius = 7
        publicFilesButton.setImage(Constants.Image.arrow, for: .normal)
        publicFilesButton.layer.shadowColor = UIColor.gray.cgColor
        publicFilesButton.layer.shadowOpacity = 0.3
        publicFilesButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        publicFilesButton.layer.shadowRadius = 10
        publicFilesButton.addTarget(self, action: #selector(didTappedOnPublicFiles), for: .touchUpInside)
        
        filledLabel.text = firstString + Constants.Text.FirstVC.gbFilled
        filledLabel.font = .systemFont(ofSize: 16, weight: .regular)
        filledLabel.textAlignment = .left
        filledLabel.textColor = .black
        
        remainsLabel.text = secondString + Constants.Text.FirstVC.gbRemains
        remainsLabel.font = .systemFont(ofSize: 16, weight: .regular)
        remainsLabel.textAlignment = .left
        remainsLabel.textColor = .black
        
        filledCircle.layer.cornerRadius = CGFloat(size/2)
        filledCircle.backgroundColor = Constants.Colors.pink
        
        remainsCircle.layer.cornerRadius = CGFloat(size/2)
        remainsCircle.backgroundColor = Constants.Colors.gray
    }
    
    @objc private func didTappedOnPublicFiles() {
        
        presenter.didTapOnPublicButton()
    }
    
    private func configureStackView() {
        
        firstStackView.axis = .horizontal
        firstStackView.alignment = .center
        firstStackView.spacing = 16
        
        secondStackView.axis = .horizontal
        secondStackView.alignment = .center
        secondStackView.spacing = 16
    }
    
    private func configureTabBar() {
        
        self.tabBarController?.tabBar.tintColor = Constants.Colors.blueSpecial
        guard let items = tabBarController?.tabBar.items else { return }
        let images = [Constants.Image.tabBar1, Constants.Image.tabBar2, Constants.Image.tabBar3]
        for x in 0..<items.count {
            items[x].image = images[x]
        }
    }
    
    private func configureNavigationBar() {
    
        menuButton = UIBarButtonItem(
            image: Constants.Image.menu,
            style: .plain,
            target: self,
            action: #selector(didTappedOnMenuButton)
        )
        menuButton.tintColor = Constants.Colors.gray
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.title = Constants.Text.FirstVC.title
    }
    
    @objc private func didTappedOnMenuButton() {
        
        let alert = self.createActionSheet()
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createActionSheet() -> UIAlertController {
        
        let alert = UIAlertController(title: Constants.Text.FirstVC.title, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Constants.Text.FirstVC.cancel, style: .cancel, handler: nil))
        alert.addAction(
            UIAlertAction(
                title: Constants.Text.FirstVC.logOut,
                style: .destructive,
                handler: {  [weak self] _ in
                    let alert = self?.createAlert() ?? UIAlertController()
                    self?.present(
                        alert,
                        animated: true,
                        completion: nil
                    )
                }
            )
        )
        return alert
    }
    
    private func createAlert() -> UIAlertController {
        
        let alert = UIAlertController(
            title: Constants.Text.FirstVC.alertTitle,
            message: Constants.Text.FirstVC.alertMessage,
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: Constants.Text.FirstVC.alertYes,
                style: .cancel,
                handler: {  [weak self] _ in
                    self?.didTappedOnYesAlert()
                }
            )
        )
        alert.addAction(UIAlertAction(title: Constants.Text.FirstVC.alertNo, style: .destructive, handler: nil))
        return alert
    }
    
    private func didTappedOnYesAlert() {
        
        presenter.didTapOnYesAlert()
        dismiss(animated: true, completion: nil)
    }
    
    private func configurePieChart() {
        
        let filled: Double = Double(filledGb)
        let remains: Double = Double(remainsGb)
        let memoryRemains = PieChartDataEntry(value: remains, data: 1)
        let memoryFilled = PieChartDataEntry(value: filled, data: 1)
        
        let entries: [PieChartDataEntry] = [memoryFilled, memoryRemains]
        
        let set = PieChartDataSet(entries: entries)
        let colors = [Constants.Colors.pink, Constants.Colors.gray]
        set.colors = colors as! [NSUIColor]
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.data?.setDrawValues(false)
        pieChart.transparentCircleColor = .white
        pieChart.centerText = sizeOfDiskStorage
        pieChart.centerTextRadiusPercent = 100
    }
    
    private func configureConstraints() {
        // MARK: - Configure Constraints
        firstStackView.addArrangedSubview(filledCircle)
        firstStackView.addArrangedSubview(filledLabel)
        secondStackView.addArrangedSubview(remainsCircle)
        secondStackView.addArrangedSubview(remainsLabel)

        view.addSubview(pieChart)
        view.addSubview(firstStackView)
        view.addSubview(secondStackView)
        view.addSubview(publicFilesButton)
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        filledCircle.translatesAutoresizingMaskIntoConstraints = false
        remainsCircle.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        publicFilesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pieChart.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            pieChart.heightAnchor.constraint(equalToConstant: 300),
            pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            filledCircle.heightAnchor.constraint(equalToConstant: size),
            filledCircle.widthAnchor.constraint(equalToConstant: size),
            
            remainsCircle.heightAnchor.constraint(equalToConstant: size),
            remainsCircle.widthAnchor.constraint(equalToConstant: size),
            
            firstStackView.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 0),
            firstStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            firstStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            firstStackView.heightAnchor.constraint(equalToConstant: 40),
            
            secondStackView.topAnchor.constraint(equalTo: firstStackView.bottomAnchor, constant: 0),
            secondStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            secondStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            secondStackView.heightAnchor.constraint(equalToConstant: 40),
            
            publicFilesButton.topAnchor.constraint(equalTo: secondStackView.bottomAnchor, constant: 16),
            publicFilesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            publicFilesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            publicFilesButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}




