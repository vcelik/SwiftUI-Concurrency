//
//  SendableBootcamp.swift
//  ConcurrencyBootcamp
//
//  Created by Volkan Celik on 02/10/2023.
//

import SwiftUI

actor CurrentUserManager{
    
    func updateDatabase(userInfo:MyClassUserInfo){
        
    }
}

struct MyUserInfo:Sendable{   //Thread safe value types       //sligh benefit from performance view adding                                                                the sendable
    let name:String
}

//final class MyClassUserInfo:Sendable{
//    let name:String     //as variable has let constant the compiler knows that it cannot change so class is                    sendable but once we change it to "var",the compiler will give error
//    
//    init(name: String) {
//        self.name = name
//    }
//}

final class MyClassUserInfo:@unchecked Sendable{  //we are gonna check it ourselves.That doesnt mean it is                                                    sendable
    private var name:String     //as variable has let constant the compiler knows that it cannot change so                               class is sendable but once we change it to "var",the compiler will give                                error
    
    let queue=DispatchQueue(label: "com.MyApp.MyClassUserInfo")
    init(name: String) {
        self.name = name
    }
    
    func updateName(name:String){
        queue.async {              //we made it thread safe
            self.name=name
        }
    }
}

class SendableBootcampViewModel:ObservableObject{
    
    let manager=CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        let info=MyClassUserInfo(name: "info")
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    
    @StateObject private var vm=SendableBootcampViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
                
            }
    }
}

#Preview {
    SendableBootcamp()
}
