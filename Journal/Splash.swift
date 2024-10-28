//
//  Splash.swift
//  Journal
//
//  Created by Nujud Abdullah on 17/04/1446 AH.
//

import SwiftUI

struct Splash: View {
    @State private var isActive = false

    
    var body: some View {
 
            ZStack{
                
                LinearGradient(gradient: .init(colors: [.color1, .black]), startPoint: .center, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Image("Journal")
                        .resizable()
                        .frame(width: 77.7, height: 101)
                        .padding(24)
                    
                    
                    Text("Journali")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(hex: "FFFFFF"))
                        .font(.system(size: 42))
                        .frame(width: 174, height: 50)
                        .padding(11)
                    
                    Text("Your thoughts, your story")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundStyle(Color(hex: "FFFFFF"))
                        .font(.system(size: 18))
                    
                    
                }
            }
        }
    }


#Preview {
    Splash()
}
