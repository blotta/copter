components {
  id: "event_manager"
  component: "/main/systems/event/event_manager.script"
}
components {
  id: "job_manager"
  component: "/main/systems/job/job_manager.script"
}
components {
  id: "rand_init"
  component: "/main/systems/rand_init.script"
}
components {
  id: "trigger_area_factory"
  component: "/main/common/trigger_area/trigger_area_factory.factory"
}
components {
  id: "person_factory"
  component: "/main/entities/person/person_factory.factory"
}
components {
  id: "indicator_factory"
  component: "/main/common/indicator/indicator_factory.factory"
}
components {
  id: "building_box_factory"
  component: "/main/entities/building_box/building_box_factory.factory"
}
components {
  id: "infra_builder"
  component: "/main/systems/buildings/infra_builder.script"
}
embedded_components {
  id: "box_factory"
  type: "factory"
  data: "prototype: \"/main/entities/box/box.go\"\n"
  ""
}
