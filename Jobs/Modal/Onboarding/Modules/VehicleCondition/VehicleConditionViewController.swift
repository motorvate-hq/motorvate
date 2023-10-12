//
//  DocumentConditionView.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-08-11.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class VehicleConditionViewController: UIViewController {
    private let vihecleRegions: [VehicleConditionItemView.Region] = [.front, .back, .left, .right, .top]

    private let titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = AppFont.archivo(.bold, ofSize: 19)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Document Vehicle Condition", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let vehicleConditionRegionStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 4
        stackView.isHidden = true
        return stackView
    }()

    fileprivate let notesRow: FormRowView = {
        let row = FormRowView(labelText: "Notes:", placeHolderText: "Add any additional notes here.")
        row.isHidden = true
        return row
    }()

    fileprivate var selectedRegion: VehicleConditionItemView.Region = .none
    fileprivate let viewModel: OnboardViewModel
    init(with viewModel: OnboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

fileprivate extension VehicleConditionViewController {
    func setup() {
        view.backgroundColor = AppColor.darkYellowGreen
        view.layer.cornerRadius = 6

        vihecleRegions.forEach { (region) in
            let uploadView = VehicleConditionItemView(with: region)
            uploadView.delegate = self
            vehicleConditionRegionStack.addArrangedSubview(uploadView)
        }

        let vStackView = UIStackView(arrangedSubviews: [titleButton, vehicleConditionRegionStack, notesRow])
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.axis = .vertical
        vStackView.distribution = .fillProportionally
        vStackView.spacing = 8

        view.addSubview(vStackView)

        vStackView.fillSuperView(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))

        titleButton.addTarget(self, action: #selector(onTitlePressed), for: .touchUpInside)
    }

    @objc private func onTitlePressed() {
        if vehicleConditionRegionStack.isHidden {
            view.backgroundColor = .systemBackground
            titleButton.setTitleColor(.black, for: .normal)
        } else {
            view.backgroundColor = AppColor.darkYellowGreen
            titleButton.setTitleColor(.white, for: .normal)
        }

        notesRow.isHidden = !notesRow.isHidden
        vehicleConditionRegionStack.isHidden = !vehicleConditionRegionStack.isHidden
    }

    func showAlertOptionsForImage() {
        let alert = UIAlertController(title: nil, message: "Select an option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.present(self.getImagePickerController(for: .camera), animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Open Photos", style: .default) { (_) in
           self.present(self.getImagePickerController(for: .photoLibrary), animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        [cameraAction, photoLibraryAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }

    func getImagePickerController(for type: UIImagePickerController.SourceType) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = type
        pickerController.delegate = self
        return pickerController
    }
}

// MARK: - VehicleConditionViewItemDelegate
extension VehicleConditionViewController: VehicleConditionViewItemDelegate {
    func vehicleConditionViewdidSelect(_ region: VehicleConditionItemView.Region) {
        selectedRegion = region
        showAlertOptionsForImage()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension VehicleConditionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let itemImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }

        print(itemImage)
        let data = itemImage.pngData()
        let medata = OnboardViewModel.FileMetadata(jobID: "16fa349d-8ad4-4801-bea5-55d23e59ce97", fileName: "testing", data: data, type: .png)
        viewModel.getUploadURL(for: medata) { [weak self] (result) in
            if result {
                self?.updateConditionRegionView(with: itemImage)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func updateConditionRegionView(with itemImage: UIImage) {
        let value = vehicleConditionRegionStack.arrangedSubviews.first(where: { (conditionView) -> Bool in
            let conditionRegion = conditionView as? VehicleConditionItemView
            return conditionRegion?.region == selectedRegion
        }) as? VehicleConditionItemView

        value?.image = itemImage
    }
}
