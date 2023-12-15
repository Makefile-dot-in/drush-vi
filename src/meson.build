drush_sources = [
  'main.vala',
  'game.vala',
  'world.vala',
  'keymap.vala'
]

drush_deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gee-0.8'),
  dependency('sdl2'),
]

executable('drush', drush_sources,
  vala_args: '--target-glib=2.58',  dependencies: drush_deps,
  install: true,
)

