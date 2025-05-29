import SwiftUI

struct ContentView: View {
    @State private var image: UIImage?
    @State private var text: String = ""
    @State private var confidence: Double = 0.0
    @State private var showCamera = false

    var body: some View {
        NavigationView {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                        .padding()
                }

                if !text.isEmpty {
                    Text("Extracted Text:")
                        .font(.headline)
                    ScrollView {
                        Text(text)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding()
                }

                Text(String(format: "AI Confidence: %.1f%%", confidence * 100))
                    .foregroundColor(confidence > 0.5 ? .red : .green)
                    .font(.title2)
                    .padding()

                Button("Capture Image") {
                    showCamera = true
                }
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .sheet(isPresented: $showCamera) {
                CameraView(capturedImage: $image, recognizedText: $text, aiConfidence: $confidence)
            }
            .navigationTitle("AI Detector")
        }
    }
}
