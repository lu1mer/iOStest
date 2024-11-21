//
//  ViewController.swift
//  TestCR
//
//  Created by Ильнур Салахов on 21.11.2024.
//

import UIKit

final class ImageGalleryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let galleryView = ImageGalleryView()
    private let model = ImageProcessingModel()

    private var task: Task<Void, Never>?

    private var imagePickerController: UIImagePickerController!

    override func loadView() {
        view = galleryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupActions()
        model.loadImages()
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
    }

    private func setupCollectionView() {
        galleryView.collectionView.dataSource = self
        galleryView.collectionView.delegate = self
        galleryView.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    private func setupActions() {
        galleryView.startButton.addTarget(self, action: #selector(startCalculations), for: .touchUpInside)
        galleryView.cancelButton.addTarget(self, action: #selector(cancelCalculations), for: .touchUpInside)
        galleryView.addImageButton.addTarget(self, action: #selector(addImageFromGallery), for: .touchUpInside)
    }

    @objc private func startCalculations() {
        guard task == nil else { return }
        galleryView.progressView.progress = 0
        galleryView.resultLabel.text = "Вычисления начаты..."

        if galleryView.segmentedControl.selectedSegmentIndex == 0 {
                    processImagesInParallel()
                } else {
                    processImagesSequentially()
                }
        
        task = Task {

                    for i in 1...20 {
                        let result = await model.factorial(of: i)

                        // Обновляем результат и прогресс в главном потоке
                        await MainActor.run {
                            self.galleryView.resultLabel.text = "Факториал \(i): \(result)"
                            self.galleryView.progressView.progress = Float(i) / 20.0
                        }

                        // Проверка на отмену задачи
                        if Task.isCancelled { break }
                    }
                }
    }
    
    //Параллельное выполнение
    private func processImagesInParallel() {

            let queue = DispatchQueue.global(qos: .userInitiated)
            
            for (index, image) in model.images.enumerated() {
                queue.async {
                    let processedImage = self.model.applyFilter(to: image)

                    DispatchQueue.main.async {
                        self.model.images[index] = processedImage!
                        self.galleryView.collectionView.reloadData()
                        self.galleryView.progressView.progress = Float(index + 1) / Float(self.model.images.count)
                    }
                }
            }
        }
    
        private func processImagesSequentially() {

            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1 

            for (index, image) in model.images.enumerated() {
                queue.addOperation {
                    let processedImage = self.model.applyFilter(to: image)

                    OperationQueue.main.addOperation {
                        self.model.images[index] = processedImage!
                        self.galleryView.collectionView.reloadData()
                        self.galleryView.progressView.progress = Float(index + 1) / Float(self.model.images.count)
                    }
                }
            }
        }

    @objc private func cancelCalculations() {
        task?.cancel()
        task = nil
        galleryView.resultLabel.text = "Вычисления отменены"
    }

    @objc private func addImageFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        } else {
            print("Photo library not available")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {

            model.images.append(selectedImage)
            galleryView.collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        if model.images.isEmpty {
            // Если изображения не загружены, добавьте placeholder
            let label = UILabel(frame: cell.contentView.bounds)
            label.text = "No images available"
            label.textAlignment = .center
            label.textColor = .gray
            cell.contentView.addSubview(label)
        } else {
            let imageView = UIImageView(image: model.images[indexPath.row])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.frame = cell.contentView.bounds
            cell.contentView.addSubview(imageView)
        }

        return cell
    }
}

