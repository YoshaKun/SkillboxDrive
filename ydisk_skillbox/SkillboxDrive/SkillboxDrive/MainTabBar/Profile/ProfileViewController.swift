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
    
    private var pieChart = PieChartView()
    private var menuButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
        view.backgroundColor = .white
        configureTabBar()
        configureNavigationBar()
        configureConstraints()
        configurePieChart()
    }
        
    private func configureTabBar() {
        
        self.tabBarController?.tabBar.tintColor = Constants.Colors.blueSpecial
        
        guard let items = tabBarController?.tabBar.items else {
            return
        }
        
        let images = [Constants.Image.tabBar1, Constants.Image.tabBar2, Constants.Image.tabBar3]
        
        for x in 0..<items.count {
            items[x].image = images[x]
        }
    }
    
    private func configureNavigationBar() {
    
        menuButton = UIBarButtonItem(image: Constants.Image.menu, style: .plain, target: self, action: #selector(didTappedOnMenuButton))
        
        menuButton.tintColor = Constants.Colors.gray
        
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.title = Constants.Text.FirstVC.title
    }
    
    @objc private func didTappedOnMenuButton() {
        
        let alert = self.createActionSheet() ?? UIAlertController()
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
        
        self.dismiss(animated: true, completion: nil)
        print("Вызван метод didTappedOn Yes Alert")
    }
    
    private func configurePieChart() {
        
        var entries = [ChartDataEntry]()
        
        for x in 1..<3 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
    
    private func configureConstraints() {
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pieChart)
        
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            pieChart.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            pieChart.heightAnchor.constraint(equalTo: view.widthAnchor, constant: -80),
            pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    
}




