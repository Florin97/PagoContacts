//
//  HeaderView.swift
//  ContactsRetriever
//
//  Created by Florin Velesca on 09.02.2024.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Contacte")
                .font(.system(size: 28))
                .padding(.leading, 8)
                .bold()
            Spacer()
            Button(action: {}) {
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
            
        }
    }
}

#Preview {
    HeaderView()
}
