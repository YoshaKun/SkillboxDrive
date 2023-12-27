//
//  ViewingScreenViewController.swift
//  SkillboxDrive
//
//  Created by Yosha Kun on 20.11.2023.
//

import Foundation
import UIKit
import PDFKit
import WebKit

final class ViewingScreenViewController: UIViewController {

    // MARK: - Private constants
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            preferences.allowsContentJavaScript = true
        } else {
            let configuration = WKWebViewConfiguration()
            let webView = WKWebView(frame: .zero, configuration: configuration)
            return webView
        }
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    private let presenter: ViewingScreenPresenterInput
    private let pdfView = PDFView()

    // MARK: - Private variables
    private var fileView = UIView()
    private var backButton = UIButton()
    private var editButton = UIButton()
    private var sendLinkButton = UIButton()
    private var trashButton = UIButton()
    private var activityIndicator = UIActivityIndicatorView()
    private var activityIndicatorView = UIView()
    private var titleFile = UILabel()
    private var dateOfCreated = UILabel()
    private var titleStackView = UIStackView()
    private var imageView = UIImageView()
    private var createdDate: String?
    private var type: String?
    private var fileUrlStr: String?
    private var path: String?

    // MARK: - Initialization
    init(
        title: String?,
        created: String?,
        type: String?,
        file: String?,
        path: String?,
        presenter: ViewingScreenPresenterInput
        ) {
        self.titleFile.text = title
        self.createdDate = created
        self.type = type
        self.fileUrlStr = file
        self.path = path
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        handleTypeOfFiles(type: type)
        configureViews()
        configureConstraints()
    }

    // MARK: - Handle Type of Files
    private func handleTypeOfFiles(type: String?) {

        switch type {

        case "jpg":
            configureActivityIndicatorView()
            configureFileViewForImage()
        case "jpeg":
            configureActivityIndicatorView()
            configureFileViewForImage()
        case "png":
            configureActivityIndicatorView()
            configureFileViewForImage()
        case "pdf":
            configureActivityIndicatorView()
            configureFileViewPdf()
        case "JPG":
            configureActivityIndicatorView()
            configureFileViewForImage()
        case "JPEG":
            configureActivityIndicatorView()
            configureFileViewForImage()
        case "PNG":
            configureActivityIndicatorView()
            configureFileViewForImage()
        case "PDF":
            configureActivityIndicatorView()
            configureFileViewPdf()
        default:
            configureFileViewMSOffice()
        }
    }

    // MARK: - ActivityIndicatorView
    private func configureActivityIndicatorView() {

        view.addSubview(activityIndicatorView)
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

    // MARK: - Configure FileViewForImage
    private func configureFileViewForImage() {

        confugureGestureRecognizers()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        fileView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: fileView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: fileView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: fileView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: fileView.bottomAnchor)
        ])

        guard let fileStr = fileUrlStr else {
            print("error FileStr")
            return
        }
        presenter.getImage(urlStr: fileStr)
    }

    // MARK: - Configure FileViewPdf
    private func configureFileViewPdf() {

        activityIndicator.stopAnimating()
        activityIndicatorView.removeFromSuperview()

        pdfView.translatesAutoresizingMaskIntoConstraints = false
        fileView.addSubview(pdfView)

        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: fileView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: fileView.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: fileView.topAnchor, constant: 50),
            pdfView.bottomAnchor.constraint(equalTo: fileView.bottomAnchor, constant: -50)
        ])

        guard let str = fileUrlStr else { return }
        guard let url = URL(string: str) else {
            print("error")
            return
        }
        if let document = PDFDocument(url: url) {
            pdfView.autoScales = true
            pdfView.displayMode = .singlePageContinuous
            pdfView.displayDirection = .vertical
            pdfView.document = document
        }
    }

    // MARK: - Configure FileViewMSOffice
    private func configureFileViewMSOffice() {

        webView.translatesAutoresizingMaskIntoConstraints = false
        fileView.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: fileView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: fileView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: fileView.topAnchor, constant: 50),
            webView.bottomAnchor.constraint(equalTo: fileView.bottomAnchor, constant: -50)
        ])

        guard let str = fileUrlStr else { return }
        guard let url = URL(string: str) else {
            print("error")
            return
        }

        webView.load(URLRequest(url: url))
    }

    // MARK: - Configure GestureRecognizer
    private func confugureGestureRecognizers() {

        let panRecognazer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGest))
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGest))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGest))

        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        fileView.addGestureRecognizer(panRecognazer)
        fileView.addGestureRecognizer(doubleTapRecognizer)
        fileView.addGestureRecognizer(tapRecognizer)
        fileView.isUserInteractionEnabled = true
    }
    @objc private func handlePanGest(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: fileView)
        if let view = recognizer.view {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    @objc private func handleDoubleTapGest(recognizer: UITapGestureRecognizer) {
        let xCharacter = CGFloat(2)
        let yCharacter = CGFloat(2)
        fileView.transform = CGAffineTransform(scaleX: xCharacter, y: yCharacter)
    }
    @objc private func handleTapGest(recognizer: UITapGestureRecognizer) {
        guard let targetView = recognizer.view else { return }
        targetView.transform = CGAffineTransform.identity
        targetView.center = self.view.center
    }
    // MARK: - Configure Views
    private func configureViews() {
        backButton.setImage(Constants.Image.backArrow, for: .normal)
        backButton.addTarget(self, action: #selector(didTapOnBackButton), for: .touchUpInside)

        editButton.setImage(Constants.Image.editLogo, for: .normal)
        editButton.addTarget(self, action: #selector(didTapOnEditButton), for: .touchUpInside)

        sendLinkButton.setImage(Constants.Image.linkLogo, for: .normal)
        sendLinkButton.addTarget(self, action: #selector(didTapOnSendLinkButton), for: .touchUpInside)

        trashButton.setImage(Constants.Image.trash, for: .normal)
        trashButton.addTarget(self, action: #selector(didTapOnTrashButton), for: .touchUpInside)

        titleFile.font = .systemFont(ofSize: 17, weight: .regular)
        titleFile.textColor = .white

        dateOfCreated.font = .systemFont(ofSize: 13, weight: .regular)
        dateOfCreated.textColor = Constants.Colors.gray
        dateOfCreated.text = parseDate(createdDate ?? "00.00.00 00:00")

        titleStackView.axis = .vertical
        titleStackView.alignment = .center
        titleStackView.spacing = 8
    }

    // MARK: - Action Back button
    @objc private func didTapOnBackButton() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Action Edit button
    @objc private func didTapOnEditButton() {
        let newVC = RenameFileBuilder.build(
            nameFile: titleFile.text,
            path: path
        )
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true)
    }

    // MARK: - Action Link button
    @objc private func didTapOnSendLinkButton() {
        let alert = self.createShareActionSheet()
        self.present(alert, animated: true, completion: nil)
    }

    private func createShareActionSheet() -> UIAlertController {
        let alert = UIAlertController(
            title: Constants.SecondVC.shareMessage,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(
                title: Constants.FirstVC.cancel,
                style: .cancel,
                handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: Constants.SecondVC.shareFile,
                style: .default,
                handler: {  [weak self] _ in
                    self?.didTapOnLink()
                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: Constants.SecondVC.shareLink,
                style: .default,
                handler: {  [weak self] _ in
                    self?.didTapOnLink()
                }
            )
        )
        return alert
    }

    private func didTapOnLink() {
        guard let path = path else {
            print("error path")
            return
        }
        presenter.getLinkFile(path: path)
    }

    // MARK: - Action Trash button
    @objc private func didTapOnTrashButton() {
        let alert = self.createDeleteActionSheet()
        self.present(alert, animated: true, completion: nil)
    }

    private func createDeleteActionSheet() -> UIAlertController {
        let alert = UIAlertController(
            title: Constants.SecondVC.deleteMessage,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(
            UIAlertAction(
                title: Constants.FirstVC.cancel,
                style: .cancel,
                handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: Constants.SecondVC.delete,
                style: .destructive,
                handler: {  [weak self] _ in
                    self?.didTappedOnYesAlert()
                }
            )
        )
        return alert
    }

    private func didTappedOnYesAlert() {
        presenter.delete(path: path)
    }

    // MARK: - Configure constraints
    private func configureConstraints() {
        let offsetWidth = view.frame.size.width / 2

        fileView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleFile.translatesAutoresizingMaskIntoConstraints = false
        dateOfCreated.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        sendLinkButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(fileView)
        view.addSubview(backButton)
        view.addSubview(titleStackView)
        view.addSubview(editButton)
        view.addSubview(sendLinkButton)
        view.addSubview(trashButton)
        titleStackView.addArrangedSubview(titleFile)
        titleStackView.addArrangedSubview(dateOfCreated)

        NSLayoutConstraint.activate([
            fileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            fileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            fileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            backButton.widthAnchor.constraint(equalToConstant: 30),

            titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleStackView.widthAnchor.constraint(equalToConstant: offsetWidth),
            titleStackView.heightAnchor.constraint(equalToConstant: 40),

            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editButton.heightAnchor.constraint(equalToConstant: 30),
            editButton.widthAnchor.constraint(equalToConstant: 30),

            sendLinkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
            sendLinkButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sendLinkButton.heightAnchor.constraint(equalToConstant: 30),
            sendLinkButton.widthAnchor.constraint(equalToConstant: 30),

            trashButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            trashButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            trashButton.heightAnchor.constraint(equalToConstant: 30),
            trashButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    // MARK: - ParseDate
    private func parseDate(_ str: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormat.date(from: str) ?? Date()
        dateFormat.locale = Locale(identifier: "ru_RU")
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .short
        return dateFormat.string(from: date)
    }
}

extension ViewingScreenViewController: ViewingScreenPresenterOutput {

    func didSuccessGettingImage(data: Data) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicatorView.removeFromSuperview()
            self?.imageView.image = UIImage(data: data)
        }
    }

    func didSuccessGettingLink() {
        guard let url = fileUrlStr else { return }
        let shareSheetVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        DispatchQueue.main.async {
            self.present(shareSheetVC, animated: true, completion: nil)
        }
    }

    func didSuccessDeleting() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
