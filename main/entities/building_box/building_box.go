components {
  id: "building_box"
  component: "/main/entities/building_box/building_box.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"building-box\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/static.atlas\"\n"
  "}\n"
  ""
  position {
    y: 32.0
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 1.0\n"
  "friction: 1.0\n"
  "restitution: 0.0\n"
  "group: \"box\"\n"
  "mask: \"cursor\"\n"
  "mask: \"floor\"\n"
  "mask: \"copter\"\n"
  "mask: \"box\"\n"
  "mask: \"hook_trigger\"\n"
  "mask: \"hook\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "      y: 32.0\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"shape\"\n"
  "  }\n"
  "  data: 32.0\n"
  "  data: 32.0\n"
  "  data: 10.0\n"
  "}\n"
  ""
}
embedded_components {
  id: "building_sprite"
  type: "sprite"
  data: "default_animation: \"infra-lumbermill\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/static.atlas\"\n"
  "}\n"
  ""
  position {
    y: 16.0
    z: 1.0
  }
  scale {
    x: 0.2
    y: 0.3
  }
}
