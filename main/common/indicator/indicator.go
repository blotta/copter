components {
  id: "indicator"
  component: "/main/common/indicator/indicator.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"none\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/indicators.tilesource\"\n"
  "}\n"
  ""
  position {
    z: 5.0
  }
}
