//
//  CleersplitScreen.swift
//  CleerSplit
//
//  Created by Ruth Okolo on 2025-12-30.
//

import SwiftUI

struct CleersplitScreen: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 253/255, green: 41/255, blue: 169/255), //magenta
                    Color(red: 68/255, green: 192/255, blue: 153/255)  //teal green
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Title
            HStack(spacing: 0) {
                Text("CLEER")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)

                Text("SP")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color(red: 68/255, green: 192/255, blue: 153/255))

                Text("LIT")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color(red: 253/255, green: 41/255, blue: 169/255))
            }
            
        
        }
    }}
#Preview {
    CleersplitScreen()
}
