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
        VStack(spacing: 10) {
            headerView
            
            Image("\(pizza.image)-hero")
                .resizable()
                .frame(maxHeight: 200)
                //.aspectRatio(contentMode: .fill)
                .cornerRadius(20)
            
            Link(destination: url, label: {
                HStack {
                    Label(title: {
                        Text(pizza.url)
                            .font(.system(size: 20, weight: .bold))
                    }, icon: {
                        Image(systemName: "globe")
                    })
                    
                    Spacer()
                }
            })
            
            Text(pizza.details)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(16)
        .background(.thinMaterial)
    }
    
    var url: URL {
        return URL(string: pizza.url) ?? URL(string: "https://deepdishswift.com")!
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
    }
}

struct PizzaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PizzaDetailView(pizza: PizzaType.giordanos.pizza())
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
