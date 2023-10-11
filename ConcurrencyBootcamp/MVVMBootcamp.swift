//
//  MVVMBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 03/10/2023.
//

import SwiftUI

final class MyManagerClass{
    
    func getData() async throws -> String {
        "Some Data!"
    }
    
}

actor MyManagerActor{
    
    func getData() async throws -> String {
        "Some Data!"
    }
    
}

@MainActor
class MVVMBootcampViewModel:ObservableObject{
    
    let managerClass=MyManagerClass()
    let managerActor=MyManagerActor()
    
    @MainActor @Published private(set) var myData:String="Starting text"
    private var tasks:[Task<(),Never>]=[]
    
    func cancelTasks(){
        tasks.forEach({$0.cancel()})
        tasks=[]
    }
    
    //@MainActor
    func onCallToButtonActionPressed() {
        let task=Task{@MainActor in
            do{
                //myData=try await managerClass.getData()
                myData=try await managerActor.getData()  //works in different actor
//                await MainActor.run {                    // dont need to do this.It comes to main actor behind the scenes.
//                    self.myData=data
//                }
            }catch{
                print(error)
            }
        }
        
        tasks.append(task)
    }
    
}

struct MVVMBootcamp: View {
    
    @StateObject private var viewModel=MVVMBootcampViewModel()
    
    var body: some View {
        VStack{
            Button(viewModel.myData) {
                viewModel.onCallToButtonActionPressed()
            }
        }
        .onDisappear{
            viewModel.cancelTasks()
        }
    }
}

#Preview {
    MVVMBootcamp()
}
