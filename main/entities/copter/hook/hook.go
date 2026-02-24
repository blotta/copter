components {
  id: "hook"
  component: "/main/entities/copter/hook/hook.script"
}
embedded_components {
  id: "hook_left"
  type: "sprite"
  data: "default_animation: \"hook\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/entities/copter/hook/hook.atlas\"\n"
  "}\n"
  ""
  rotation {
    z: -0.38268343
    w: 0.9238795
  }
}
embedded_components {
  id: "hook_right"
  type: "sprite"
  data: "default_animation: \"hook\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 32.0\n"
  "  y: 32.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/main/entities/copter/hook/hook.atlas\"\n"
  "}\n"
  ""
  position {
    z: 0.2
  }
  rotation {
    z: 0.38268343
    w: 0.9238795
  }
  scale {
    x: -1.0
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 0.01\n"
  "friction: 0.1\n"
  "restitution: 0.0\n"
  "group: \"default\"\n"
  "mask: \"default\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "    id: \"box\"\n"
  "  }\n"
  "  data: 5.0\n"
  "  data: 5.0\n"
  "  data: 10.0\n"
  "}\n"
  "linear_damping: 50.0\n"
  "angular_damping: 10.0\n"
  ""
}
embedded_components {
  id: "rope_factory"
  type: "factory"
  data: "prototype: \"/main/common/rope/rope.go\"\n"
  ""
}
