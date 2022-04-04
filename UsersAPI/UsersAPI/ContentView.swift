//
//  ContentView.swift
//  UsersAPI
//
//  Created by sherry on 2022/4/4.
//

import SwiftUI


struct UsersAPI:Codable{
    
            var login:String
            var id: Int
            var avatar_url:URL
    
}



struct ContentView: View {
    
    @State var usersAPI: [UsersAPI]?
    
    var body: some View {
        if let usersAPI = usersAPI {
            List(usersAPI,id: \.id){ item in
                HStack{
                    AsyncImage(url: item.avatar_url){ phase in
                        if let image = phase.image {
                            image
                                .resizable()
                        } else if phase.error != nil{
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                        } else{
                            Color.gray
                        }
                    }
                        .frame(width: 100, height: 100)
                    Text(item.login)
                }
            }
        }
        
        Text("Loding...")
            .onAppear(perform: self.loadData)
        
    }
    
    func loadData() {
        
        let urlString = "https://api.github.com/users"
        
        guard let url = URL(string: urlString) else {
            print("Invalid url.")
            
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response,error) in if let error = error {
            print(error.localizedDescription)
            
            return
        }
            
            guard let data = data, let _ = response else {
                print("NO data")
                
                return
            }
            
            do{
                let usersAPI = try JSONDecoder().decode([UsersAPI].self, from: data)
                
                DispatchQueue.main.async {
                    self.usersAPI = usersAPI
                }
            } catch let decodeError{
                print(decodeError.localizedDescription)
            }
            
        }
        
        
        task.resume()
        
    }
    
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
