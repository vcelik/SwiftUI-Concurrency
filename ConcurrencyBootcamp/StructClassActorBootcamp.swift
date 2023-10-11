//
//  StructClassActorBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 01/10/2023.
//

import SwiftUI

class StructClassActorBootcampViewModel:ObservableObject{
    
    @Published var title:String=""
    
    init(){
        print("ViewModel init")
    }
}

struct StructClassActorBootcamp: View {
    
    @StateObject private var viewModel=StructClassActorBootcampViewModel()
    let isActive:Bool
    
    init(isActive:Bool){
        self.isActive=isActive
        print("View init")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? .red : .blue)
            .onAppear{
                //runTest()
            }
    }
}

struct StructClassActorBootcampHomeView:View {
    
    @State private var isActive:Bool=false
    
    var body: some View {
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

//#Preview {
//    StructClassActorBootcamp(isActive: false)
//}


extension StructClassActorBootcamp{
    private func runTest(){
//        print("Test started")
//        structTest1()
//        printDivider()
//        classTest1()
        structTest2()
        printDivider()
        classTest2()
        printDivider()
        actorTest1()
    }
    
    private func printDivider(){
        print("""


-----------------------------



""")
    }
    
    private func structTest1(){
        print("structTest1")
        let objectA=MyStruct(title: "Starting title!")
        print("ObjectA",objectA.title)
        
        print("Pass the VALUES of objectA to objectB")
        
        var objectB=objectA
        print("ObjectB",objectB.title)
        
        
        objectB.title="Second title!"
        print("ObjectB title changed.")

        print("ObjectA",objectA.title)
        print("ObjectB",objectB.title)
    }
    
    private func classTest1(){
        print("classTest1")
        let objectA=MyClass(title: "Starting title!")
        print("ObjectA",objectA.title)
        
        print("Pass the REFERENCE of objectA to objectB")

        let objectB=objectA
        print("ObjectB",objectB.title)
        
        objectB.title="Second title!"
        print("ObjectB title changed.")

        print("ObjectA",objectA.title)
        print("ObjectB",objectB.title)
    }
    
    private func actorTest1(){
        Task{
            print("classTest1")
            let objectA=MyActor(title: "Starting title!")
            await print("ObjectA",objectA.title)
            
            print("Pass the REFERENCE of objectA to objectB")

            let objectB=objectA
            await print("ObjectB",objectB.title)
            
            //objectB.title="Second title!"
            await objectB.updateTitle(newTitle: "Second title!")
            print("ObjectB title changed.")

            await print("ObjectA",objectA.title)
            await print("ObjectB",objectB.title)
        }
    }
}

struct MyStruct{
    var title:String
}

//Immutable struct
struct CustomStruct{
    let title:String
    
    func updateTitle(newTitle:String)->CustomStruct{
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct{
    private(set) var title:String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle:String){
        title=newTitle
    }
}

extension StructClassActorBootcamp{
    private func structTest2(){
        print("structTest2")
        
        var struct1=MyStruct(title: "Title1")
        print("Struct1:",struct1.title)
        struct1.title="Title2"
        print("Struct1:",struct1.title)
        
        var struct2=CustomStruct(title: "Title1")
        print("Struct2:",struct2.title)
        struct2=CustomStruct(title: "Title2")
        print("Struct2:",struct2.title)
        
        var struct3=CustomStruct(title: "Title1")
        print("Struct3:",struct3.title)
        struct3=struct3.updateTitle(newTitle: "Title2")
        print("Struct3:",struct3.title)
        
        var struct4=MutatingStruct(title: "Title1")
        print("Struct4:",struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("Struct4:",struct4.title)
    }
}

class MyClass{
    var title:String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle:String){
        title=newTitle
    }
}

actor MyActor{
    var title:String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle:String){
        title=newTitle
    }
}

extension StructClassActorBootcamp{
    
    private func classTest2(){
        print("classTest2")
        
        let class1=MyClass(title: "Title1")
        print("Class1:",class1.title)
        class1.title="Title2"
        print("Class1:",class1.title)
        
        let class2=MyClass(title: "Title1")
        print("Class2:",class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("Class2:",class2.title)
    }
}
