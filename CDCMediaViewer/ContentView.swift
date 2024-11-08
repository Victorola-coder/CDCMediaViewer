import SwiftUI

struct ContentView: View {
    @State private var urlString: String = "https://tools.cdc.gov/api/v2/resources/media" // Must use @State to ensure mutability
    @State private var result: String = "Enter a valid URL and press Fetch."
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            // Editable TextField for URL
            TextField("Enter URL", text: $urlString) // $urlString allows two-way binding
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                fetchData()
            }) {
                Text("Fetch Data")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if isLoading {
                ProgressView()
                    .padding()
            }

            ScrollView {
                Text(result)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }

    private func fetchData() {
        isLoading = true
        result = "Loading..." // Show loading text initially
        
        do {
            try NetworkManager.get(
                url: urlString,
                success: { json in
                    result = "Success:\n \(json.description)"
                    isLoading = false
                },
                failure: { errorMessage in
                    result = "Failure: \(errorMessage)"
                    isLoading = false
                }
            )
        } catch {
            result = "Invalid URL"
            isLoading = false
        }
    }
}
