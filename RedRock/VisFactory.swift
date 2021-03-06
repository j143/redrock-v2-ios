//
//  VisFactory.swift
//  RedRock
//
//  Created by Jonathan Alter on 10/13/15.
//  Copyright © 2016 IBM. All rights reserved.
//

/**
* (C) Copyright IBM Corp. 2016, 2016
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*
*/

import UIKit

class VisFactory {

    class func visualizationControllerForType(type: VisTypes) -> VisMasterViewController? {
        switch type {
        case .TreeMap, .CirclePacking, .ForceGraph, .CommunityGraph, .StackedBar,
             .StackedBarDrilldownCirclePacking, .SidewaysBar, .PieChart, .WordCloud:
            return VisWebViewController(type: type)
        case .WordCount, .SentimentBar:
            return VisNativeViewController(type: type)
        default:
            log.error("Tried to create unknown VisTyle: \(type)")
            return nil
        }
    }
}
