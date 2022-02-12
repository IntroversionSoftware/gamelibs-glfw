project('glfw3', 'c', version: '3.4.0')

compiler = meson.get_compiler('c')

incdirs = [ 'include' ]
build_incdirs = [ '.' ]

objc_flags = []
c_flags = []

link_deps = [
    dependency('threads'),
]

if target_machine.system() == 'linux'
    c_flags += ['-D_LARGEFILE64_SOURCE']
endif

sources = [
  'src/context.c',
  'src/egl_context.c',
  'src/init.c',
  'src/input.c',
  'src/internal.h',
  'src/mappings.h',
  'src/monitor.c',
  'src/null_init.c',
  'src/null_joystick.c',
  'src/null_joystick.h',
  'src/null_monitor.c',
  'src/null_platform.h',
  'src/null_window.c',
  'src/osmesa_context.c',
  'src/platform.c',
  'src/platform.h',
  'src/vulkan.c',
  'src/window.c',
]

if target_machine.system() == 'windows'
    sources += [
      'src/wgl_context.c',
      'src/win32_init.c',
      'src/win32_joystick.c',
      'src/win32_joystick.h',
      'src/win32_module.c',
      'src/win32_monitor.c',
      'src/win32_platform.h',
      'src/win32_thread.c',
      'src/win32_thread.h',
      'src/win32_time.c',
      'src/win32_time.h',
      'src/win32_window.c',
    ]
else
    sources += [
      'src/posix_module.c',
      'src/posix_thread.c',
      'src/posix_thread.h',
      'src/posix_time.c',
      'src/posix_time.h',
    ]
endif

if target_machine.system() == 'linux'
    link_deps += [
        dependency('x11'),
        dependency('xrandr'),
    ]
    c_flags += ['-D_GLFW_X11']
    sources += [
      'src/glx_context.c',
      'src/linux_joystick.c',
      'src/linux_joystick.h',
      #'src/wl_init.c',
      #'src/wl_monitor.c',
      #'src/wl_platform.h',
      #'src/wl_window.c',
      'src/x11_init.c',
      'src/x11_monitor.c',
      'src/x11_platform.h',
      'src/x11_window.c',
      'src/xkb_unicode.c',
      'src/xkb_unicode.h',
    ]
endif


if target_machine.system() == 'darwin'
    link_deps += [
    ]
    sources += [
      'src/cocoa_init.m',
      'src/cocoa_joystick.h',
      'src/cocoa_joystick.m',
      'src/cocoa_monitor.m',
      'src/cocoa_platform.h',
      'src/cocoa_time.c',
      'src/cocoa_time.h',
      'src/cocoa_window.m',
      'src/nsgl_context.m',
    ]
endif

incdirs = include_directories(incdirs)
build_incdirs = include_directories(build_incdirs)

glfw = static_library(
    'glfw3',
    sources,
    include_directories: [incdirs, build_incdirs],
    c_args: c_flags,
    dependencies: link_deps,
    objc_args: objc_flags,
)

glfw_dep = declare_dependency(
    include_directories: incdirs,
    dependencies: link_deps,
    link_with: [glfw],
    version: meson.project_version()
)

meson.override_dependency('glfw3', glfw_dep)

# vim: set ts=4 sts=4 sw=4 et:
