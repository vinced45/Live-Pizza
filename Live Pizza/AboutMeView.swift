//
//  AboutMeView.swift
//  Live Pizza
//
//  Created by Vince Davis on 4/29/23.
//

import SwiftUI

struct AboutMeView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            headerView
            List {
                Section("App", content: {
                    Text("This is for for my talk on Live Activities at Deep Dish Chicago. Vote on your favorite Deep Dish Pizza (Yes I know they're more than these 4 😁) and have live results show on Live Activities & Dynamic Island. I'll talk about some tips that will have you making Live Activites in no time!")
                })
                
                Section("About me", content: {
                    HStack {
                        Text("My name is **Vince Davis**. I'll be speaking at Deep Dish Swift '23")
                            .lineLimit(nil)
                        Spacer()
                        Image("vince_davis")
                            .resizable()
                            .frame(width: 75, height: 75)
                            
                    }
                    twitterView
                })
            }.background(Color.clear)
            
            Spacer()
        }
    }
    
    var url: URL {
        return URL(string: "https://twitter.com/VinceDavis")!
    }
    
    var headerView: some View {
        HStack {
            Label(title: {
                Text("Live Pizza")
                    .font(.system(size: 20, weight: .bold))
            }, icon: {
                Image("logo")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
            })
            Spacer()
            Button(action: { dismiss() }) {
              ExitButtonView()
            }.frame(width: 24, height: 24)
        }
        .padding(16)
    }
    
    var twitterView: some View {
        Link(destination: url, label: {
            HStack {
                Label(title: {
                    Text("Find me on Twitter!")
                        .font(.system(size: 20, weight: .bold))
                }, icon: {
                    Image("twitter")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .aspectRatio(1, contentMode: .fit)
                })
                
                Spacer()
            }
        })
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView()
    }
}
