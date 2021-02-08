//
//  MainView.swift
//  travel
//
//  Created by Дмитрий on 17.01.2021.
//

import SwiftUI
import CoreData
import Combine

struct MainView: View {
    
    var user: UserModel
    var moc: NSManagedObjectContext
    @ObservedObject var bloglist = BlogList()
    
    @State var selectionTab: TabItem = .home
    var movingTop = PassthroughSubject<Bool, Never>()
    
    
    init(user: UserModel, moc: NSManagedObjectContext) {
        self.user = user
        self.moc = moc
        UITabBar.appearance().barTintColor = .darkGray
    }
    
    var body: some View {
        
        TabView(selection: $selectionTab) {
            ForEach(TabItem.allCases, id: \.self) { item in
                
                switch item {
                case .home:
                    HomeView(parent: self, blogPage: bloglist, moc: moc, user: user)
                        .tabItem {
                            Image(systemName: HomeView.icon)
                            Text(item.rawValue)
                        }.tag(TabItem.home)
                case .map:
                    MapView(user: user)
                        .tabItem {
                            Image(systemName: MapView.icon)
                            Text(item.rawValue)
                        }.tag(item)
                case .new:
                    CreateNewView(user: user, blogList: bloglist)
                        .tabItem {
                            Image(systemName: CreateNewView.icon).renderingMode(.original)
                            Text(item.rawValue)
                        }.tag(item)
                case .auth:
                    AuthorizationView(user: user, moc: moc)
                        .tabItem {
                            Image(systemName: AuthorizationView.icon)
                            Text(item.rawValue)
                        }.tag(item)
                case .contact:
                    ContactsView()
                        .tabItem {
                            Image(systemName: ContactsView.icon)
                            Text(item.rawValue)
                        }.tag(item)
                }
            }
        }.accentColor(.yellow)
        .onTapGesture(count: 2) {
            if selectionTab == .home {
                movingTop.send (true)
            }
        }
    }
    
}



