components {
  id: "infra"
  component: "/main/entities/infra/infra.script"
  properties {
    id: "infra_type"
    value: "house"
    type: PROPERTY_TYPE_HASH
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"building-house\"\n"
  "material: \"/materials/infra.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/entities/infra/house/house.atlas\"\n"
  "}\n"
  ""
  position {
    z: -0.1
  }
}
