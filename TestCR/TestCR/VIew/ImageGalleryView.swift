//
//  MainView.swift
//  TestCR
//
//  Created by Ильнур Салахов on 21.11.2024.
//

import UIKit
class ImageGalleryView: UIView {
    // UI Components
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Параллельно", "Последовательно"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Начать вычисления", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отмена", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка для добавления изображения из галереи
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить изображение", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        addSubview(segmentedControl)
        addSubview(collectionView)
        addSubview(startButton)
        addSubview(cancelButton)
        addSubview(progressView)
        addSubview(resultLabel)
        addSubview(addImageButton)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            startButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            cancelButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            progressView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            resultLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            addImageButton.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            addImageButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

