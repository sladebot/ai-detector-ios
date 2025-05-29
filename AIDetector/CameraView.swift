//
//  CameraView.swift
//  AIDetector
//
//  Created by Souranil  Sen on 5/28/25.
//

import SwiftUI
import UIKit
import Vision

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var recognizedText: String
    @Binding var aiConfidence: Double

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(capturedImage: $capturedImage, recognizedText: $recognizedText, aiConfidence: $aiConfidence)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var capturedImage: UIImage?
        @Binding var recognizedText: String
        @Binding var aiConfidence: Double

        init(capturedImage: Binding<UIImage?>, recognizedText: Binding<String>, aiConfidence: Binding<Double>) {
            _capturedImage = capturedImage
            _recognizedText = recognizedText
            _aiConfidence = aiConfidence
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.capturedImage = image
                performOCR(on: image)
            }
            picker.dismiss(animated: true)
        }

        private func performOCR(on image: UIImage) {
            guard let cgImage = image.cgImage else { return }

            let request = VNRecognizeTextRequest { request, _ in
                guard let results = request.results as? [VNRecognizedTextObservation] else { return }
                let text = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                DispatchQueue.main.async {
                    self.recognizedText = text
                    self.aiConfidence = self.dummyAIDetector(text: text)
                }
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }

        private func dummyAIDetector(text: String) -> Double {
            // TEMP: Fake detection logic (replace later with real model)
            return text.lowercased().contains("ai") ? 0.85 : 0.15
        }
    }
}
