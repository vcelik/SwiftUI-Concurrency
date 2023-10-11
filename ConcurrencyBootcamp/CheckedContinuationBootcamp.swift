//
//  CheckedContinuationBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 26/09/2023.
//

import SwiftUI

class CheckedContinuationBootcampNetworkManager{
    
    func getData(url:URL) async throws->Data{
        
        do{
            let (data,_)=try await URLSession.shared.data(from: url)
            return data
        }catch{
            throw error
        }
    }
    
    func getData2(url:URL) async throws->Data{
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data=data{
                    continuation.resume(returning: data)  //exactly once not twice not zero
                }else if let error=error{
                    continuation.resume(throwing: error)
                }else{
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDatabase(completionHandler:@escaping (_ image:UIImage)->Void){
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0){
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase() async ->UIImage{
       return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationBootcampViewModel:ObservableObject{
    
    @Published var image:UIImage?=nil
    let networkManager=CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url=URL(string: "https://picsum.photos/300") else {return}
        do{
            let data=try await networkManager.getData2(url: url)
            if let image=UIImage(data: data){
                await MainActor.run {
                    self.image=image
                }
            }
        }catch{
            print(error)
        }
    }
    
//    func getHeartImage(){
//        networkManager.getHeartImageFromDatabase { [weak self] image in
//            self?.image=image
//        }
//    }
    
    func getHeartImage() async {
        self.image = await networkManager.getHeartImageFromDatabase()
    }
    
}

struct CheckedContinuationBootcamp: View {
    
    @StateObject var vm=CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack{
            if let image=vm.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:200,height:200)
            }
        }
        .task {
            //await vm.getImage()
            await vm.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
