//
//  HostingController.swift
//  tic-tac-toe WatchKit Extension
//
//  Created by Алексей Агеев on 07.06.2020.
//  Copyright © 2020 Alexey Ageev. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView()
    }
}

struct HostingController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
