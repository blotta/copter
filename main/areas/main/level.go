components {
  id: "world"
  component: "/main/areas/main/world.tilemap"
}
components {
  id: "level"
  component: "/main/areas/main/level.script"
}
components {
  id: "box"
  component: "/main/entities/box/box.factory"
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "collision_shape: \"/main/areas/main/world.tilemap\"\n"
  "type: COLLISION_OBJECT_TYPE_STATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.0\n"
  "group: \"floor\"\n"
  "mask: \"copter\"\n"
  "mask: \"box\"\n"
  "mask: \"person\"\n"
  "locked_rotation: true\n"
  ""
}
