//
//  StoryBannerViewModel.swift
//  Hiker
//
//  Created by 张驰 on 2019/9/10.
//  Copyright © 2019 张驰. All rights reserved.
//

import Foundation

class StoryBannerViewModel{
    var model:NotesModel?
    
    init(with model:NotesModel) {
        self.model = model
        
    }
    
    typealias call = () -> Void
    var backCallBack: call?
    var userCallBack: call?
}
