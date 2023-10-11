//
//  PhotoPickerBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 03/10/2023.
//

import SwiftUI
import PhotosUI

@MainActor
final class PhotoPickerBootcampViewModel:ObservableObject{
    
    @Published private(set) var selectedImage:UIImage?=nil
    @Published var imageSelection:PhotosPickerItem?=nil{
        didSet{
            setImage(from: imageSelection)
        }
    }
    
    @Published private(set) var selectedImages:[UIImage]=[]
    @Published var imageSelections:[PhotosPickerItem]=[]{
        didSet{
            setImages(from: imageSelections)
        }
    }
    
    private func setImage(from selection:PhotosPickerItem?){
        guard let selection else {return}
        
        Task{
            if let data=try? await selection.loadTransferable(type: Data.self){
                if let uiImage=UIImage(data: data){
                    selectedImage=uiImage
                    return
                }
            }
        }
    }
    
    private func setImages(from selections:[PhotosPickerItem]){
        
        Task{
            var images:[UIImage]=[]
           for selection in selections{
                if let data=try? await selection.loadTransferable(type: Data.self){
                    if let uiImage=UIImage(data: data){
                        images.append(uiImage)
                    }
                }
            }
            self.selectedImages=images
        }
    }
    
}

struct PhotoPickerBootcamp: View {
    
    @StateObject private var viewModel=PhotoPickerBootcampViewModel()
    
    var body: some View {
        VStack(spacing:40){
            Text("Hello")
            if let image=viewModel.selectedImage{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width:200,height: 200)
                    .cornerRadius(10)
            }
            
            PhotosPicker(selection: $viewModel.imageSelection,matching: .any(of: [.images,.bursts])) {
                Text("Open the photo picker!")
                    .foregroundColor(.red)
            }
            
            if !viewModel.imageSelections.isEmpty{
                ScrollView(.horizontal,showsIndicators:false){
                    HStack{
                        ForEach(viewModel.selectedImages,id:\.self){image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width:50,height: 50)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            PhotosPicker(selection: $viewModel.imageSelections,matching: .images) {
                Text("Open the photos picker!")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    PhotoPickerBootcamp()
}
