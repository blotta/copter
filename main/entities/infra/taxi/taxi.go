components {
  id: "infra"
  component: "/main/entities/infra/infra.script"
  properties {
    id: "infra_type"
    value: "taxi"
    type: PROPERTY_TYPE_HASH
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"building-taxi\"\n"
  "material: \"/materials/infra.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/entities/infra/taxi/taxi_building.atlas\"\n"
  "}\n"
  ""
}
