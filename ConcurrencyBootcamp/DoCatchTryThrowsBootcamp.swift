//
//  DoCatchTryThrowsBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 28/05/2023.
//

import SwiftUI


class DoCatchTryThrowsBootcampDataManager{
    
    let isActive:Bool=true
    
    func getTitle()->(title:String?,error:Error?){
        if isActive{
            return ("NEW TEXT!",nil)
        }else{
            return (nil,URLError(.badURL))
        }
    }
    
    func gettitle2()->Result<String,Error>{
        if isActive{
            return .success("NEW TEXT!")
        }else{
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws->String {
        if isActive{
            return "NEW TEXT!"
        }else{
            throw URLError(.backgroundSessionRequiresSharedContainer)
        }
    }
    
    func getTitle4() throws->String {
        if isActive{
            return "FINAL TEXT!"
        }else{
            throw URLError(.backgroundSessionRequiresSharedContainer)
        }
    }
}

class DoCatchTryThrowsBootcampViewModel:ObservableObject{
    
    @Published var text:String="Starting text."
    let manager=DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle(){
        /*
         let returnedValue=manager.getTitle()
        if let newTitle=returnedValue.title{
            self.text=newTitle
        }else if let error=returnedValue.error{
            self.text=error.localizedDescription
        }
         */
        /*
        let result=manager.gettitle2()
        switch result {
        case .success(let newTitle):
            self.text=newTitle
        case .failure(let error):
            self.text=error.localizedDescription
         */
        //let newTitle=try? manager.getTitle3()
        //if let newTitle=newTitle{
            //self.text=newTitle
        //}
        
        //let newTitle=try! manager.getTitle3() dangerous
        do{
            let newTitle=try? manager.getTitle3()
            if let newTitle=newTitle{
                self.text=newTitle
            }

            
            let finalTitle=try manager.getTitle4()
            self.text=finalTitle
        }catch(let error){
            self.text=error.localizedDescription
        }
    }
    
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel=DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width:300,height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
