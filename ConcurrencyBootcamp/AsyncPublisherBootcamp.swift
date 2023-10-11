//
//  AsyncPublisherBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 02/10/2023.
//

import SwiftUI
import Combine

class AsyncPublisherDataManager{
    
    @Published var myData:[String]=[]
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
    }
}

class AsyncPublisherBootcampViewModel:ObservableObject{
    
    @MainActor @Published var dataArray:[String]=[]
    let manager=AsyncPublisherDataManager()
    var cancellables=Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    private func addSubscribers(){
        
        Task{
            await MainActor.run {
                self.dataArray=["ONE"]
            }
            
            
            for await value in manager.$myData.values{
                await MainActor.run {
                    self.dataArray=value
                }
                //break
            }
            
//            await MainActor.run {          //this never works cos it never knows when the publisher                                stops
//                self.dataArray=["TWO"]
//            }
        }
//        manager.$myData
//            .receive(on: DispatchQueue.main, options: nil)
//            .sink { dataArray in
//                self.dataArray=dataArray
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }

}

struct AsyncPublisherBootcamp: View {
    
    @StateObject private var viewModel=AsyncPublisherBootcampViewModel()
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(viewModel.dataArray,id:\.self){
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
