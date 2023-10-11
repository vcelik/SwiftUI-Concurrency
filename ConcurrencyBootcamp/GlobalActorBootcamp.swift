//
//  GlobalActorBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 02/10/2023.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor{  // also can be final class
    
    static var shared=MyNewDatamanager()   //the instance of datamanager should be here only

}

actor MyNewDatamanager{
    
    func getDataFromDatabase()->[String]{
        
        return ["One","Two","Three","Four","Five","Six"]
    }
    
}

@MainActor  //everythg in the class will be isolated to this class
class GlobalActorBootcampViewModel:ObservableObject{
    
    @MainActor @Published var dataArray:[String]=[]
    let manager=MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor    //to convert nonisolated func to isolated func
   //@MainActor  //main thread
    func getData() {  //nonisolated -> not isolated to Main Actor
        Task{
            let data=await manager.getDataFromDatabase()
            await MainActor.run {
                self.dataArray=data
            }
        }

    }
    
}

struct GlobalActorBootcamp: View {
    
    @StateObject private var viewModel=GlobalActorBootcampViewModel()
    
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
            await viewModel.getData()  // will work on main thread
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
