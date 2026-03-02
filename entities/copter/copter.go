components {
  id: "copter"
  component: "/entities/copter/copter.script"
}
components {
  id: "player"
  component: "/entities/copter/player.script"
}
components {
  id: "hook"
  component: "/entities/copter/hook.script"
}
components {
  id: "cargo"
  component: "/entities/copter/cargo.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"copter\"\n"
  "material: \"/materials/copter.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/static.atlas\"\n"
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
  "mass: 10.0\n"
  "friction: 1.0\n"
  "restitution: 0.0\n"
  "group: \"copter\"\n"
  "mask: \"box\"\n"
  "mask: \"floor\"\n"
  "mask: \"building\"\n"
  "mask: \"helipad\"\n"
  "mask: \"trigger_area\"\n"
  "mask: \"hook\"\n"
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
  "bullet: true\n"
  ""
}
embedded_components {
  id: "hook_collectionfactory"
  type: "collectionfactory"
  data: "prototype: \"/entities/copter/hook/hook.collection\"\n"
  ""
}
