//
//  SwiftUIView.swift
//  MVVM
//
//  Created by dhanasekaran on 29/09/21.
//

import SwiftUI
import Combine
import SafariServices

struct ApiListView: View {
    
    @ObservedObject var viewModel = PublicAPIViewModel()
    @State var presentingModal = false
    
    var body: some View {
        
        NavigationView {
            switch viewModel.publishedResult
            {
            case .success(let listItems):
                List(listItems) { listItem in
                    NavigationLink {
                        
                    } label: {
                        APIListCellView(apiModel: listItem).onTapGesture {
                            self.presentingModal = true
                        }.sheet(isPresented: $presentingModal) {
                            
                        } content: {
                            SafariView(presentedAsModal: $presentingModal, url: URL(string: listItem.Link)!)
                        }

                    }
                }.navigationTitle("MVVM With SwiftUI")
            case .failure(let error):
                VStack {
                    Text(error.localizedDescription)
                }.navigationTitle("MVVM With SwiftUI")
            case nil:
                VStack {
                    Text("Loading...")
                    ProgressView()
                }.onAppear {
                    viewModel.getAPIList()
                }.navigationTitle("MVVM With SwiftUI")
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ApiListView()
    }
}

struct APIListCellView: View {
    
    let apiModel: PublicAPIModel
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(apiModel.API).font(Font.title)
            Text(apiModel.Description).font(Font.subheadline)
        })
    }
}

struct APIListView_Previews: PreviewProvider {
    
    static var previews: some View {
        APIListCellView(apiModel: .init(API: "Testing API", Description: "Testing Descriptiom", Auth: "Auth", HTTPS: true, Cors: "Test", Link: "https://google.com", Category: "category"))
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    @Binding var presentedAsModal: Bool
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: self.url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = SFSafariViewController
    
    let url: URL
    
}
