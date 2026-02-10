components {
  id: "copter"
  component: "/main/entities/copter/copter.script"
}
components {
  id: "player"
  component: "/main/entities/copter/player.script"
}
components {
  id: "hook"
  component: "/main/entities/copter/hook.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"copter\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/entities/copter/copter.atlas\"\n"
  "}\n"
  ""
  position {
    y: 2.0
  }
}
embedded_components {
  id: "co"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 7.0\n"
  "friction: 1.0\n"
  "restitution: 0.0\n"
  "group: \"copter\"\n"
  "mask: \"box\"\n"
  "mask: \"floor\"\n"
  "mask: \"building\"\n"
  "mask: \"helipad\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "      y: 20.0\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"box\"\n"
  "  }\n"
  "  data: 20.0\n"
  "  data: 20.0\n"
  "  data: 10.0\n"
  "}\n"
  "linear_damping: 0.5\n"
  "angular_damping: 0.9\n"
  ""
}
