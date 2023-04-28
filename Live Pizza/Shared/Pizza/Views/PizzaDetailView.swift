//
//  PizzaDetailView.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/26/23.
//

import SwiftUI

struct PizzaDetailView: View {
    @Environment(\.dismiss) var dismiss
    let pizza: Pizza
    
    var body: some View {
        VStack {
            headerView
            Spacer()
            Text(pizza.details)
        }
    }
    
    var headerView: some View {
        HStack {
            Label(title: {
                Text(pizza.name)
                    .font(.system(size: 20, weight: .bold))
            }, icon: {
                Image(pizza.image)
                    .resizable()
                    .frame(width: 100, height: 40)
                    .aspectRatio(1, contentMode: .fit)
            })
            Spacer()
            Button(action: { dismiss() }) {
              ExitButtonView()
            }.frame(width: 24, height: 24)
        }
        .padding()
    }
}

struct PizzaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PizzaDetailView(pizza: .giordanos)
    }
}

struct ExitButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(white: colorScheme == .dark ? 0.19 : 0.93))
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .font(Font.body.weight(.bold))
                .scaleEffect(0.416)
                .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
        }
    }
}
