//
//  StrongSelfBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 03/10/2023.
//

import SwiftUI

final class StrongSelfDataService{
    
    func getData() async->String{
        "Updated data!"
    }
}

final class StrongSelfBootcampViewModel:ObservableObject{
    
    @Published var data:String="Some title!"
    let dataService=StrongSelfDataService()
    private var someTask:Task<(),Never>?=nil
    private var myTasks:[Task<(),Never>]=[]
    
    func cancelTasks(){
        someTask?.cancel()
        myTasks.forEach {$0.cancel()}
    }
    
    //This implies strong reference
    func updataData(){
        Task{
           data=await dataService.getData()
        }
    }
    
    //This is strong reference...
    func updataData2(data:String){
        Task{
            self.data=await self.dataService.getData()
        }
    }
    
    //This is strong reference...
    func updataData3(){
        Task{ [self] in
            self.data=await self.dataService.getData()
        }
    }
    
    //This is weak reference...
    func updataData4(){
        Task{ [weak self] in
            if let data=await self?.dataService.getData(){
                self?.data=data
            }
        }
    }
    
    //we dont need to manage weak/strong
    //because we can manage the task
    func updataData5(){   //if we just use "Task" it waits till the func finishes
        someTask=Task{
            self.data=await self.dataService.getData()
        }
    }
    
    //we van manage the task!
    func updataData6(){
        let task1=Task{
            self.data=await self.dataService.getData()
        }
        
        myTasks.append(task1)
        
        let task2=Task{
            self.data=await self.dataService.getData()
        }
        
        myTasks.append(task2)
    }
    
    //we purposely do not cancel tasks to keep strong references
    func updataData7(){
        Task{
            self.data=await self.dataService.getData()
        }
        
        Task.detached{
            self.data=await self.dataService.getData()
        }
    }
    
    func updataData8() async {
        self.data=await self.dataService.getData()
    }
    
}

struct StrongSelfBootcamp: View {
    
    @StateObject private var viewModel=StrongSelfBootcampViewModel()
    
    var body: some View {
        Text(viewModel.data)
            .onAppear{
                viewModel.updataData()
            }
            .onDisappear{
                viewModel.cancelTasks()
            }
            .task {
                await viewModel.updataData8()
            }
    }
}

#Preview {
    StrongSelfBootcamp()
}
