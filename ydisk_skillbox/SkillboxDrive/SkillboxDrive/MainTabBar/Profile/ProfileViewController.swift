//
//  ViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 05.10.2023.
//

import DGCharts
import UIKit

final class ProfileViewController: UIViewController, ChartViewDelegate {
    
    private let presenter: ProfilePresenterProtocol = ProfilePresenter()
    private var pieChart = PieChartView()
    private var menuButton = UIBarButtonItem()
    private var publicFilesButton = UIButton()
    private var totalSpaseLabel = UILabel()
    private var usedSpaceLabel = UILabel()
    private var totalSpaceCircle = UIImageView()
    private var usedSpaceCircle = UIImageView()
    private var firstStackView = UIStackView()
    private var secondStackView = UIStackView()
    private let sizeOfTheCircles: CGFloat = 30
    
    private var totalSpaceGb: Int = 0
    private var usedSpaceGb: Int = 0
    private var totalDataEntry = PieChartDataEntry(value: 0)
    private var usedDataEntry = PieChartDataEntry(value: 0)
    private var allMemorySpaceDataEntry = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureStackView()
        configureTabBar()
        configureNavigationBar()
        configureConstraints()
        updateData()
    }
        
    private func configureViews() {
        
        view.backgroundColor = .systemBackground
        
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
        
        totalSpaseLabel.font = .systemFont(ofSize: 16, weight: .regular)
        totalSpaseLabel.textAlignment = .left
        totalSpaseLabel.textColor = .black
        
        usedSpaceLabel.font = .systemFont(ofSize: 16, weight: .regular)
        usedSpaceLabel.textAlignment = .left
        usedSpaceLabel.textColor = .black
        
        totalSpaceCircle.layer.cornerRadius = CGFloat(sizeOfTheCircles/2)
        totalSpaceCircle.backgroundColor = Constants.Colors.pink
        
        usedSpaceCircle.layer.cornerRadius = CGFloat(sizeOfTheCircles/2)
        usedSpaceCircle.backgroundColor = Constants.Colors.gray
    }
    
    @objc private func didTappedOnPublicFiles() {
        
        let vc = PublicFilesViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updatePieChart() {
        
        pieChart.delegate = self
        let totalGigabytes = presenter.getConvertedBytesTotal(value: totalSpaceGb)
        let usedGigabytes = presenter.getConvertedBytesUsed(value: usedSpaceGb)
        let remainsGigabytes = totalGigabytes - usedGigabytes
        let firstString = presenter.getConvertedBytesUsedToString(value: usedSpaceGb)
        let secondString = presenter.getConvertedBytesRemainsToString(total: totalSpaceGb, used: usedSpaceGb)
        totalDataEntry.value = totalGigabytes
        usedDataEntry.value = usedGigabytes
        allMemorySpaceDataEntry = [usedDataEntry, totalDataEntry]
        let set = PieChartDataSet(entries: allMemorySpaceDataEntry)
        let colors = [Constants.Colors.pink, Constants.Colors.gray]
        set.colors = colors as! [NSUIColor]
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.data?.setDrawValues(false)
        pieChart.transparentCircleColor = .white
        pieChart.centerText = presenter.getConvertedBytesTotalToString(value: totalSpaceGb)
        totalSpaseLabel.text = firstString + Constants.Text.FirstVC.gbFilled
        usedSpaceLabel.text = secondString + Constants.Text.FirstVC.gbRemains
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
    
    private func configureConstraints() {
        // MARK: - Configure Constraints
        firstStackView.addArrangedSubview(totalSpaceCircle)
        firstStackView.addArrangedSubview(totalSpaseLabel)
        secondStackView.addArrangedSubview(usedSpaceCircle)
        secondStackView.addArrangedSubview(usedSpaceLabel)
        
        view.addSubview(pieChart)
        view.addSubview(firstStackView)
        view.addSubview(secondStackView)
        view.addSubview(publicFilesButton)
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        totalSpaceCircle.translatesAutoresizingMaskIntoConstraints = false
        usedSpaceCircle.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        publicFilesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            pieChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pieChart.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            pieChart.heightAnchor.constraint(equalToConstant: 300),
            pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            totalSpaceCircle.heightAnchor.constraint(equalToConstant: sizeOfTheCircles),
            totalSpaceCircle.widthAnchor.constraint(equalToConstant: sizeOfTheCircles),
            
            usedSpaceCircle.heightAnchor.constraint(equalToConstant: sizeOfTheCircles),
            usedSpaceCircle.widthAnchor.constraint(equalToConstant: sizeOfTheCircles),
            
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

    private func updateData() {
        // MARK: - Получение данных с сервера для PieChart
        
        presenter.updatePieData { totalSpace, usedSpace in
            DispatchQueue.main.async {
                self.totalSpaceGb = totalSpace ?? 00
                self.usedSpaceGb = usedSpace ?? 00
                self.updatePieChart()
            }
        }
    }
}

extension ProfileViewController: AuthViewControllerDelegate {
    
    func handleTokenChanged(token: String) {
        presenter.updateToken(newToken: token)
    }
}




