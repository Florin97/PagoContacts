//
//  ContactView.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import SwiftUI

struct ContactView: View {
    @StateObject var viewModel: ContactViewModel
    
    var body: some View {
        HStack {
            iconView
                .padding(.leading, 8)
            Text(viewModel.contactName)
                .font(.subheadline)
                .frame( height: 50)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .frame(height: 50)
                .padding(.trailing, 8)
        }
        .task {
            await viewModel.loadIcon()
        }
    }
    
    @ViewBuilder
    private var iconView: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .initials(let initials):
            Text(initials)
                .font(.title)
                .padding()
                .minimumScaleFactor(0.3)
                .frame(width: 50, height: 50)
                .overlay(Circle().strokeBorder(Color.blue, lineWidth: 1))
        case .image(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        }
    }
}

#Preview {
    ContactView(viewModel: ContactViewModel(contact: Contact(id: 2, name: "First Name", email: "email@email.com", gender: .male, status: .active)))
}
