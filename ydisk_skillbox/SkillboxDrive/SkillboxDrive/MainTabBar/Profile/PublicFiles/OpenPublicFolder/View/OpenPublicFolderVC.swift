//
//  PublicFilesViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 13.11.2023.
//

import Foundation
import UIKit

final class OpenPublicFolderVC: UIViewController {

    private let publicCell = "publicCell"
    private let presenter: OpenPublicFolderPresenterInput
    private let refreshControl = UIRefreshControl()
    private var noFilesImageView = UIImageView()
    private var descriptionLabel = UILabel()
    private var backButton = UIBarButtonItem()
    private var updateButton = UIButton()
    private var noFilesView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    private var activityIndicatorView = UIView()
    private var tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    private var errorView = UIView()
    private var errorLabel = UILabel()
    private var titleOfFolder: String?
    private var type: String?
    private var varPublicUrl: String?
    private var pathFolder: String?
    private var emptyFolderErrorView = UIView()
    private let labelError = UILabel()
    private let fileNotFound = UILabel()

    // MARK: - Initialization
    init(title: String?,
         type: String?,
         publicUrl: String?,
         pathFolder: String?,
         presenter: OpenPublicFolderPresenterInput
        ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.titleOfFolder = title
        self.type = type
        self.varPublicUrl = publicUrl
        self.pathFolder = pathFolder
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        noFilesView.removeFromSuperview()
    }

    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureActivityIndicatorView()
        updateView()
    }

    private func configureNavigationBar() {
        backButton = UIBarButtonItem(
            image: Constants.Image.backArrow,
            style: .plain,
            target: self,
            action: #selector(didTappedOnBackButton)
        )
        backButton.tintColor = Constants.Colors.gray
        navigationItem.leftBarButtonItem = backButton
        view.backgroundColor = .systemBackground
        self.title = titleOfFolder
    }

    @objc private func didTappedOnBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func configureEmptyFolderError() {

        labelError.text = Constants.Text.emptyFolder
        labelError.textColor = .black
        labelError.numberOfLines = 0
        labelError.textAlignment = .center

        view.addSubview(emptyFolderErrorView)
        emptyFolderErrorView.backgroundColor = .systemBackground
        emptyFolderErrorView.addSubview(labelError)

        labelError.translatesAutoresizingMaskIntoConstraints = false
        emptyFolderErrorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyFolderErrorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyFolderErrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyFolderErrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyFolderErrorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            labelError.centerXAnchor.constraint(equalTo: emptyFolderErrorView.centerXAnchor),
            labelError.centerYAnchor.constraint(equalTo: emptyFolderErrorView.centerYAnchor),
            labelError.heightAnchor.constraint(equalToConstant: 100),
            labelError.leadingAnchor.constraint(equalTo: emptyFolderErrorView.leadingAnchor, constant: 70),
            labelError.trailingAnchor.constraint(equalTo: emptyFolderErrorView.trailingAnchor, constant: -70)
        ])
    }

    private func configureActivityIndicatorView() {

        view.addSubview(activityIndicatorView)
        activityIndicatorView.backgroundColor = .systemBackground
        activityIndicatorView.addSubview(activityIndicator)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            activityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureNoFilesView() {
        noFilesImageView.image = Constants.Image.noFiles
        noFilesImageView.contentMode = .scaleAspectFit

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.contentMode = .scaleAspectFit
        descriptionLabel.text = Constants.FirstVC.noFilesDescr

        updateButton.backgroundColor = Constants.Colors.pink
        updateButton.setTitle(Constants.FirstVC.update, for: .normal)
        updateButton.setTitleColor(.black, for: .normal)
        updateButton.layer.cornerRadius = 7
        updateButton.addTarget(self, action: #selector(didTappedOnUpdateButton), for: .touchUpInside)

        configureNoFilesConstraints()
    }

    private func configureFileError() {
        fileNotFound.text = Constants.Text.fileError
        fileNotFound.textColor = .black
        fileNotFound.numberOfLines = 0
        fileNotFound.textAlignment = .center

        view.addSubview(emptyFolderErrorView)
        emptyFolderErrorView.backgroundColor = .systemBackground
        emptyFolderErrorView.addSubview(fileNotFound)

        fileNotFound.translatesAutoresizingMaskIntoConstraints = false
        emptyFolderErrorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emptyFolderErrorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyFolderErrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyFolderErrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyFolderErrorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            fileNotFound.centerXAnchor.constraint(equalTo: emptyFolderErrorView.centerXAnchor),
            fileNotFound.centerYAnchor.constraint(equalTo: emptyFolderErrorView.centerYAnchor),
            fileNotFound.heightAnchor.constraint(equalToConstant: 100),
            fileNotFound.leadingAnchor.constraint(equalTo: emptyFolderErrorView.leadingAnchor, constant: 70),
            fileNotFound.trailingAnchor.constraint(equalTo: emptyFolderErrorView.trailingAnchor, constant: -70)
        ])
    }

    @objc private func didTappedOnUpdateButton() {
        self.noFilesView.removeFromSuperview()
        configureActivityIndicatorView()
        updateView()
    }

    private func configureNoFilesConstraints() {
        let offsetForImage = view.frame.size.width / 2
        let offsetForDescription = view.frame.size.width / 4

        view.addSubview(noFilesView)

        noFilesView.addSubview(noFilesImageView)
        noFilesView.addSubview(descriptionLabel)
        noFilesView.addSubview(updateButton)

        noFilesView.translatesAutoresizingMaskIntoConstraints = false
        noFilesImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        updateButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            noFilesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noFilesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noFilesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noFilesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            noFilesImageView.centerXAnchor.constraint(equalTo: noFilesView.centerXAnchor),
            noFilesImageView.topAnchor.constraint(equalTo: noFilesView.topAnchor, constant: offsetForImage / 1.5),
            noFilesImageView.widthAnchor.constraint(equalToConstant: offsetForImage),
            noFilesImageView.heightAnchor.constraint(equalToConstant: offsetForImage),

            descriptionLabel.leadingAnchor.constraint(equalTo: noFilesView.leadingAnchor, constant: offsetForDescription / 2),
            descriptionLabel.topAnchor.constraint(equalTo: noFilesImageView.bottomAnchor, constant: offsetForDescription / 3),
            descriptionLabel.trailingAnchor.constraint(equalTo: noFilesView.trailingAnchor, constant: -offsetForDescription / 2),

            updateButton.bottomAnchor.constraint(equalTo: noFilesView.bottomAnchor, constant: -40),
            updateButton.leadingAnchor.constraint(equalTo: noFilesView.leadingAnchor, constant: 27),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
            updateButton.trailingAnchor.constraint(equalTo: noFilesView.trailingAnchor, constant: -27)
        ])
    }

    // MARK: - UpdateView - default
    private func updateView() {
        configureTableView()
        updateDataOfTableView()
    }

    private func configureTableView() {
        refreshControl.addTarget(self, action: #selector(didSwipeToRefresh), for: .valueChanged)
        tableView.refreshControl = self.refreshControl
        tableView.register(PublicCell.self, forCellReuseIdentifier: publicCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        configureConstraints()
    }

    @objc private func didSwipeToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.updateDataOfTableView()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }

    private func updateDataOfTableView() {
        presenter.updateDataTableView(publicUrl: varPublicUrl)
    }

    // MARK: - Error View

    private func configureErrorView() {
        errorLabel.text = Constants.Text.errorInternet
        errorLabel.font = .systemFont(ofSize: 15, weight: .regular)
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorView.backgroundColor = Constants.Colors.red

        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorView.addSubview(errorLabel)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            errorView.heightAnchor.constraint(equalToConstant: 50),

            errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 80),
            errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -80),
            errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor)
        ])
    }

    private func configureConstraints() {
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    private func createActionSheet(titleCell: String, path: String?) -> UIAlertController {
        let cellPath = path ?? ""
        let folder = pathFolder ?? ""
        let allPath = folder + cellPath
        let alert = UIAlertController(title: titleCell, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Constants.FirstVC.cancel, style: .cancel, handler: nil))
        alert.addAction(
            UIAlertAction(
                title: Constants.FirstVC.removePost,
                style: .destructive,
                handler: {  [weak self] _ in
                    self?.configureActivityIndicatorView()
                    self?.tableView.isHidden = true
                    self?.presenter.removePublishedData(path: allPath)
                }
            )
        )
        return alert
    }

    // MARK: - determinationOfFileType

    func determinationOfFileType(path: String) -> String {
        guard let index = path.firstIndex(of: ".") else {
            let str = "dir"
            return str}
        var fileType = path[index ..< path.endIndex]
        fileType.removeFirst()
        let newString = String(fileType)
        return newString
    }

    // MARK: - Footer view

    private func createLoadingFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }
}

extension OpenPublicFolderVC: OpenPublicFolderPresenterOutput {

    func didSuccessUpdateDataTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.errorView.removeFromSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.noFilesView.removeFromSuperview()
        }
    }

    func didFailureUpdateDataTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.isHidden = true
            self.activityIndicator.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.configureNoFilesView()
        }
    }

    func noFilesUpdateDataTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.isHidden = true
            self.activityIndicator.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            AlertHelper.showAlert(withMessage: Constants.Text.emptyFolder)
            self.configureEmptyFolderError()
        }
    }

    func noInternetUpdateDataTableView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.noFilesView.removeFromSuperview()
            AlertHelper.showAlert(withMessage: Constants.Text.errorInternet)
            self.configureErrorView()
        }
    }

    func didSuccessRemovePublishedData() {
        DispatchQueue.main.async { [weak self] in
            self?.updateDataOfTableView()
        }
    }

    func didFailureRemovePublishedData() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }

    func didSuccessAdditionalGettingData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.tableFooterView = nil
            self?.tableView.reloadData()
            self?.presenter.changePaginatingStateOnFalse()
        }
    }

    func didFailureAdditionalGettingData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableView.tableFooterView = nil
            self?.tableView.reloadData()
            self?.presenter.changePaginatingStateOnFalse()
        }
    }
}

// MARK: - UITableViewDataSource

extension OpenPublicFolderVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getModelData().items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: publicCell) as? PublicCell
        guard let viewModel = presenter.getModelData().items, viewModel.count > indexPath.row else {
            return UITableViewCell()
        }
        let item = viewModel[indexPath.row]
        cell?.configureCell(item)
        cell?.delegate = self
        cell?.backgroundColor = .white
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension OpenPublicFolderVC: UITableViewDelegate {
    // swiftlint:disable:next function_body_length
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        configureActivityIndicatorView()
        guard let viewModel = presenter.getModelData().items else {
            print("error getModelData")
            return
        }
        guard let strUrl = viewModel[indexPath.row].publicUrl else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
                self.configureFileError()
            }
            return
        }
        guard let title = viewModel[indexPath.row].name else { return }
        guard let created = viewModel[indexPath.row].created else { return }
        let fileUrl = viewModel[indexPath.row].file ?? "ljshdlgfhj"
        guard let pathItem = viewModel[indexPath.row].path else { return }
        let path = (pathFolder ?? "") + pathItem
        let fileType = determinationOfFileType(path: pathItem)
        let folder = "dir"
        if fileType == folder {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                let someVC = OpenPublicFolderBuilder.build(
                    title: title,
                    type: fileType,
                    publicUrl: strUrl,
                    pathFolder: path
                )
                self.navigationController?.pushViewController(someVC, animated: true)
                self.activityIndicator.stopAnimating()
                self.activityIndicatorView.removeFromSuperview()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                let someVc = ViewingScreenBuilder.build(
                    title: title,
                    created: created,
                    type: fileType,
                    file: fileUrl,
                    path: path
                )
                someVc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(someVc, animated: true, completion: {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicatorView.removeFromSuperview()
                })
            }
        }
    }
}

// MARK: - PublicCellDelegate

extension OpenPublicFolderVC: PublicCellDelegate {
    func didTapButton(with title: String, and path: String?) {
        let alert = self.createActionSheet(titleCell: title, path: path)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate

extension OpenPublicFolderVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset <= 0, currentOffset >= 50 {
            guard !self.presenter.isPaginating() else {
                print("We are already fetching more data")
                return
            }
            self.tableView.tableFooterView = createLoadingFooterView()
            self.presenter.additionalGettingDataOfPublishedFolder(publicUrl: varPublicUrl)
        }
    }
}
