import SwiftUI

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by numbers or words"
        searchBar.searchTextField.backgroundColor = .white //essential for shadows to not be made inside on the text
        
        //SearchBar Border Properties
        searchBar.searchTextField.layer.borderWidth = 0.1
        searchBar.searchTextField.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.9).cgColor
        searchBar.searchTextField.layer.cornerRadius = 13
        searchBar.searchTextField.layer.masksToBounds = false //Must be false for shadow to work
        
        //SearchBar Shadow properties
        searchBar.searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchBar.searchTextField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        searchBar.searchTextField.layer.shadowOpacity = 0.5
        searchBar.searchTextField.layer.shadowRadius = 1.0
        
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
}

extension UISearchBar {
    func enable() {
        isUserInteractionEnabled = true
        alpha = 1.0
    }

    func disable() {
        isUserInteractionEnabled = false
        alpha = 0.5
    }
}
