//
//  ActorsBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 02/10/2023.
//

import SwiftUI

//1.what is the problem that actor is solving
//2.how was this problem solved prior to actors?
//3.Actors can solve the problem!

class MyDataManager{
    static let instance=MyDataManager()
    private init(){
        
    }
    
    var data:[String]=[]
    private let lock=DispatchQueue(label: "com.MyApp.MyDataManager")  //lock=queue
    
    func getRandomData(completionHandler:@escaping (_ title:String?)->Void){
        lock.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager{
    
    static let instance=MyActorDataManager()
    private init(){
        
    }
    
    var data:[String]=[]
    //private let lock=DispatchQueue(label: "com.MyApp.MyDataManager")  //lock=queue
    
    nonisolated let myRandomText="safdsfdsfd"
    
    func getRandomData()->String?{
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
    
    nonisolated func getSavedData()->String{
        //let newString=getRandomData()      cannot be called isolated func
        //we arenot worried about thread safety
        return "NEW DATA"
    }
}

struct HomeView:View {
    
    let manager=MyActorDataManager.instance
    @State private var text:String=""
    let timer=Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onAppear{
            let newString=manager.getSavedData()

//            Task{
//                let newString=await manager.getSavedData()
//            }
//            Task{
//                await manager.data
//            }
        }
        .onReceive(timer){_ in
            Task{
                if let data=await manager.getRandomData(){
                    await MainActor.run {
                        self.text=data
                    }
                }
            }
//            DispatchQueue.global(qos: .background).async {
//                manager.getRandomData { title in
//                    if let data=title{
//                        DispatchQueue.main.async{
//                            self.text=data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct BrowseView:View {
    
    let manager=MyActorDataManager.instance
    @State private var text:String=""
    let timer=Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            Color.yellow.opacity(0.8).ignoresSafeArea()
            Text(text)
                .font(.headline)
        }
        .onReceive(timer){_ in
            Task{
                if let data=await manager.getRandomData(){
                    await MainActor.run {
                        self.text=data
                    }
                }
            }
//            DispatchQueue.global(qos: .default).async {
//                manager.getRandomData { title in
//                    if let data=title{
//                        DispatchQueue.main.async{
//                            self.text=data
//                        }
//                    }
//                }
//            }
        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage:"house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage:"magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
