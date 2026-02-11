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
  "  texture: \"/main/common/indicator/indicators.tilesource\"\n"
  "}\n"
  ""
}
