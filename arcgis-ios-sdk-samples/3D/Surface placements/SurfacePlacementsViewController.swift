//
// Copyright 2016 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import ArcGIS

class SurfacePlacementsViewController: UIViewController {

    @IBOutlet var sceneView:AGSSceneView!
    
    private var drapedGraphicsOverlay = AGSGraphicsOverlay()
    private var relativeGraphicsOverlay = AGSGraphicsOverlay()
    private var absoluteGraphicsOverlay = AGSGraphicsOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the source code button item to the right of navigation bar
        (self.navigationItem.rightBarButtonItem as! SourceCodeBarButtonItem).filenames = ["SurfacePlacementsViewController"]
        
        let scene = AGSScene(basemap: AGSBasemap.topographicBasemap())
        
        self.sceneView.scene = scene
        
        let camera = AGSCamera(latitude: 53.04, longitude: -4.04, altitude: 1300, heading: 0, pitch: 90, roll: 0)
        self.sceneView.setViewpointCamera(camera)
        
        // add base surface for elevation data
        let surface = AGSSurface()
        let elevationSource = AGSArcGISTiledElevationSource(URL: NSURL(string: "http://elevation3d.arcgis.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer")!)
        surface.elevationSources.append(elevationSource)
        scene.baseSurface = surface
        
        //set surface placements for the graphicsOverlays
        self.drapedGraphicsOverlay.sceneProperties?.surfacePlacement = .Draped
        self.relativeGraphicsOverlay.sceneProperties?.surfacePlacement = .Relative
        self.absoluteGraphicsOverlay.sceneProperties?.surfacePlacement = .Absolute
        
        //add graphic overlays to the scene view
        self.sceneView.graphicsOverlays.addObjectsFromArray([self.drapedGraphicsOverlay, self.relativeGraphicsOverlay, self.absoluteGraphicsOverlay])
        
        //add graphics
        self.addGraphics()
    }
    
    
    private func addGraphics() {
        
        //create point for graphic location
        let point = AGSPoint(x: -4.04, y: 53.06, z: 1000, spatialReference: AGSSpatialReference.WGS84())
        
        self.drapedGraphicsOverlay.graphics.addObjectsFromArray([AGSGraphic(geometry: point, symbol: self.pointSymbol()), AGSGraphic(geometry: point, symbol: self.textSymbol("Draped"))])
        self.relativeGraphicsOverlay.graphics.addObjectsFromArray([AGSGraphic(geometry: point, symbol: self.pointSymbol()), AGSGraphic(geometry: point, symbol: self.textSymbol("Relative"))])
        self.absoluteGraphicsOverlay.graphics.addObjectsFromArray([AGSGraphic(geometry: point, symbol: self.pointSymbol()), AGSGraphic(geometry: point, symbol: self.textSymbol("Absolute"))])
    }
    
    private func pointSymbol() -> AGSSimpleMarkerSceneSymbol {
        return AGSSimpleMarkerSceneSymbol(style: .Sphere, color: UIColor.redColor(), height: 50, width: 50, depth: 50, anchorPosition: .Center)
    }
    
    private func textSymbol(text: String) -> AGSTextSymbol {
        return AGSTextSymbol(text: text, color: UIColor.blueColor(), size: 20, horizontalAlignment: .Left, verticalAlignment: .Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}