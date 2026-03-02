components {
  id: "indicator"
  component: "/entities/common/indicator/indicator.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"indicator-none\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/static.atlas\"\n"
  "}\n"
  ""
  position {
    z: 5.0
  }
}
