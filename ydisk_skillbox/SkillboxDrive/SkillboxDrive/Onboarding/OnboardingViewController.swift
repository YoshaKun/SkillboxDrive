//
//  OnboardingViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 05.10.2023.
//

import Foundation
import UIKit

protocol OnboardingViewControllerProtocol: AnyObject {}

class OnboardingViewController: UIViewController {
    
    private let presenter: OnboardingPresenterProtocol = OnboardingPresenter()
    private let identifierForCell = "identifierForCell"
    private var collectionView: UICollectionView!
    private var pageControl = UIPageControl()
    private var nextButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupViews()
        setupConstraints()
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomOnboardingCell.self, forCellWithReuseIdentifier: identifierForCell)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
    }
    
    private func setupViews() {
        
        pageControl.numberOfPages = 3
        pageControl.backgroundColor = .white
        pageControl.pageIndicatorTintColor = Constants.Colors.graySpecial
        pageControl.currentPageIndicatorTintColor = Constants.Colors.blueSpecial
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        
        nextButton.backgroundColor = .blue
        nextButton.setTitle(Constants.Text.nextButton, for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 7
        nextButton.addTarget(self, action: #selector(didTappedOnNextButton), for: .touchUpInside)
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        
        let current = sender.currentPage
        print(current)
        collectionView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    @objc private func didTappedOnNextButton() {
        
        switch pageControl.currentPage {
        case 0:
            collectionView.setContentOffset(CGPoint(x: CGFloat(1) * view.frame.size.width, y: 0), animated: true)
        case 1:
            collectionView.setContentOffset(CGPoint(x: CGFloat(2) * view.frame.size.width, y: 0), animated: true)
        case 2:
            Core.shared.setIsNotNewUser()
            // MARK: - написать сюда метод, вызывающий окно Входа в приложение
            self.dismiss(animated: true, completion: nil)
        default:
            print("default action")
        }
    }
    
    private func setupConstraints() {
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 8),
            
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -30),
            pageControl.widthAnchor.constraint(equalToConstant: 245),
            pageControl.heightAnchor.constraint(equalToConstant: 15),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
        ])
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout()
        let screenSize = view.frame.width
        layout.itemSize = .init(width: screenSize, height: screenSize)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        
        return layout
    }
}

extension OnboardingViewController: OnboardingViewControllerProtocol {
    
    func presentNewController(vc: UIViewController, anime: Bool) {
        navigationController?.present(vc, animated: anime, completion: nil)
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        presenter.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierForCell, for: indexPath) as? CustomOnboardingCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = presenter.getModelArray(index: indexPath.item).image
        cell.descriptionOnboard.text = presenter.getModelArray(index: indexPath.item).description
        return cell
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        pageControl.currentPage = Int(floorf(Float(collectionView.contentOffset.x) / Float(collectionView.frame.size.width)))
    }
}
