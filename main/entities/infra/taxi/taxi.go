components {
  id: "infra"
  component: "/main/entities/infra/infra.script"
  properties {
    id: "type"
    value: "taxi"
    type: PROPERTY_TYPE_HASH
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"building-taxi\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/entities/infra/taxi/taxi_building.atlas\"\n"
  "}\n"
  ""
}
