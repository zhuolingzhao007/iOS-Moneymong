import ProjectDescription

let project = Project(
  name: "LocalStorage",
  options: .options(
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
  ),
  targets: [
    Target(
      name: "LocalStorage",
      platform: .iOS,
      product: .framework,
      bundleId: "com.framework.moneymong.LocalStorage",
      deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
      sources: ["Sources/**"],
      dependencies: [
        
      ]
    )
  ]
)
