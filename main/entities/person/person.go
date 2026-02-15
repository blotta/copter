components {
  id: "person"
  component: "/main/entities/person/person.script"
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_KINEMATIC\n"
  "mass: 0.0\n"
  "friction: 1.0\n"
  "restitution: 0.0\n"
  "group: \"person\"\n"
  "mask: \"floor\"\n"
  "mask: \"helipad\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "      y: 11.0\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"shape\"\n"
  "  }\n"
  "  data: 6.0\n"
  "  data: 11.0\n"
  "  data: 10.0\n"
  "}\n"
  "linear_damping: 5.0\n"
  "locked_rotation: true\n"
  ""
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"normal1_idle\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/entities/person/images/person.tilesource\"\n"
  "}\n"
  ""
  position {
    y: 12.0
    z: 0.1
  }
}
