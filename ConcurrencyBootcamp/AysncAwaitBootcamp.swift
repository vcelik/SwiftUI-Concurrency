//
//  AysncAwaitBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 28/05/2023.
//

import SwiftUI

class AysncAwaitBootcampViewModel:ObservableObject{
    
    @Published var dataArray:[String]=[]
    
    func addTitle1(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.dataArray.append("Title1: \(Thread.current)")
        }
    }
    
    func addTitle2(){
        DispatchQueue.global().asyncAfter(deadline: .now()+2) {
            let title="Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                let title3="Title3: \(Thread.current)"
            }
        }
    }
    
    func addAuthor1() async {
        let author1="Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2="Author1: \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(author2)
            let author3="Author3: \(Thread.current)"
            self.dataArray.append(author3)
        })
        
        //await addSomething()
        
        
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1="Something1: \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(something1)
            let something2="Something2: \(Thread.current)"
            self.dataArray.append(something2)
        })
    }
    
}

struct AysncAwaitBootcamp: View {
    
    @StateObject private var viewmodel=AysncAwaitBootcampViewModel()
    var body: some View {
        List{
            ForEach(viewmodel.dataArray,id:\.self){data in
                Text(data)
            }
        }
        .onAppear{
            Task{
                await viewmodel.addAuthor1()
                await viewmodel.addSomething()
                
                let finalText="FINAL TEXT: \(Thread.current)"
                viewmodel.dataArray.append(finalText)
            }
            //viewmodel.addTitle1()
            //viewmodel.addTitle2()
        }
    }
}

struct AysncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AysncAwaitBootcamp()
    }
}
