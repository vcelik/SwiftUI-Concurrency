//
//  RefreshableBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 03/10/2023.
//

import SwiftUI

final class RefreshableDataService{
    
    func getData() async throws->[String]{
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        return ["Apple","Orange","Banana"].shuffled()
    }
    
}

@MainActor
final class RefreshableBootcampViewModel:ObservableObject{
    
    @Published private(set) var items:[String]=[]
    let manager=RefreshableDataService()
    
//    func loadData(){
//        Task{
//            do{
//                items=try await manager.getData()
//            }catch{
//                print(error)
//            }
//        }
//    }
    
    func loadData() async {
        do{
            items=try await manager.getData()
        }catch{
            print(error)
        }
    }
}

struct RefreshableBootcamp: View {
    
    @StateObject private var viewModel=RefreshableBootcampViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    ForEach(viewModel.items,id:\.self){item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
                await viewModel.loadData()     //spinner disappears immediately cos function works       immediately cos func is synchronous
            }
            .navigationTitle("Refreshable")
            .task {
                await viewModel.loadData()
            }
//            .onAppear{
//                Task{
//                    await viewModel.loadData()
//                }
//            }
        }
    }
}

#Preview {
    RefreshableBootcamp()
}
