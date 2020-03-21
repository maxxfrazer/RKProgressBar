//
//  RKProgressBar.swift
//  RKProgressBar
//
//  Created by Max Cobb on 3/20/20.
//  Copyright © 2020 Max Cobb. All rights reserved.
//

import Foundation
import RealityKit
import Combine

/// A capsule shaped geometry for showing progress in RealityKit 􀘸
public class RKProgressBar: Entity {
  private let innerModel = ModelEntity()
  private let outerModel = ModelEntity()
  internal var innerMargin: Float = 0.25

  /// Get the current progress of the RKProgressBar
  public var progress: Float {
    innerModel.transform.scale.x
  }

  /// Create a capsule shaped progress bar entity 􀘸
  /// - Parameters:
  ///   - innerColor: Color of the internal capsule.
  ///   - outerColor: Color of the external capsule.
  ///   - innerMargin: distance between the internal capsule and the edge of the external.
  ///   - startAt: Position to start the capsule at (0...1)
  required public init(
    innerColor: SimpleMaterial.Color = .green,
    outerColor: SimpleMaterial.Color = .black,
    innerMargin: Float = 0.25,
    startAt: Float = 1
  ) {
    self.innerMargin = innerMargin
    super.init()
    let innerBar = MeshResource.generateBox(width: 10, height: 1, depth: 1, cornerRadius: 0.5, splitFaces: false)
    let outerBar = MeshResource.generateBox(
      width: 10 + self.innerMargin * 2,
      height: 1 + self.innerMargin * 2,
      depth: 1 + self.innerMargin * 2,
      cornerRadius: 0.5 + self.innerMargin, splitFaces: false
    )
    self.innerModel.model = ModelComponent(
      mesh: innerBar,
      materials: [SimpleMaterial(color: innerColor, isMetallic: false)]
    )
    outerModel.model = ModelComponent(
      mesh: outerBar,
      materials: [SimpleMaterial(color: outerColor, isMetallic: false)]
    )
    outerModel.scale = .init(repeating: -1)
    self.addChild(outerModel)
    self.addChild(innerModel)
    self.setProgress(to: startAt)
  }

  /// Set the progress value for the RKProgressBar, no animation.
  /// - Parameter progress: Desired value, between 0 and 1 only.
  public func setProgress(to progress: Float) {
    assert((0.0...1.0).contains(progress), "Health value must be between 0 and 1")
    self.innerModel.isEnabled = progress > 0
    self.innerModel.scale.x = progress
    self.innerModel.position.x = (5 - self.innerMargin) * (progress - 1)
  }

  /// Animate the progress value for this RKProgressBar
  /// - Parameters:
  ///   - progress: Desired value, between 0 and 1 only.
  ///   - duration: Time taken to animate to desired value, default 1.
  public func moveProgress(to progress: Float, duration: TimeInterval = 1, timingFunction: AnimationTimingFunction = .linear) {
    self.innerModel.isEnabled = true
    assert((0.0...1.0).contains(progress), "Health value must be between 0 and 1")
    if duration == .zero {
      self.setProgress(to: progress)
      return
    }
    self.innerModel.stopAllAnimations()
    var endTransform = innerModel.transform
    endTransform.scale.x = progress
    endTransform.translation.x = (5 - self.innerMargin) * (progress - 1)

    self.innerModel.move(
      to: endTransform, relativeTo: self,
      duration: duration, timingFunction: timingFunction
    )

    // If the model is set to a scale of 0 it looks messed up,
    // so I'm just going to hide it for now
    if progress == 0 {
      var endAnimCallback: Cancellable?
      endAnimCallback = self.scene?.subscribe(
        to: AnimationEvents.PlaybackCompleted.self,
        on: self.innerModel,
        { _ in
          endAnimCallback?.cancel()
          self.innerModel.isEnabled = false
      })
    }
  }

  required init() {
    super.init()
  }
}
