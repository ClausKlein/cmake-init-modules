# jrsonnet --preserve-order CMakeUserPresets.jsonnet > CMakeUserPresets.json

local archs = [
  'Linux',
  'Darwin',
  'win64',
];

local types = [
  'dev',
  # 'sanitize',
  # 'coverage',
];

local link_modes = [
  # 'static',
  'dynamic',
];

local configs = [
  'Debug',
  # 'Release',
];

local cp_generator(arch, type, link_mode) =
  {
    name: arch + '-' + type + '-' + link_mode,
    inherits: [type, link_mode],
  };

local bp_generator(arch, type, link_mode, config) =
  {
    name: arch + '-' + type + '-' + link_mode + '-' + std.asciiLower(config),
    # configurePreset: arch + '-' + type + '-' + link_mode,
    configurePreset: type + '-' + arch,
    configuration: config,
  };

local tp_generator(arch, type, link_mode, config) =
  {
    name: arch + '-' + type + '-' + link_mode + '-' + std.asciiLower(config),
    # configurePreset: arch + '-' + type + '-' + link_mode,
    configurePreset: type + '-' + arch,
    output: { outputOnFailure: true },
    execution: { noTestsAction: 'ignore', stopOnFailure: true },
  };

local wp_generator(arch, type, link_mode, config) =
  {
    name: arch + '-' + type + '-' + link_mode + '-' + std.asciiLower(config),
    steps: [
      {
        type: 'configure',
        # name: arch + '-' + type + '-' + link_mode,
        name: type + '-' + arch,
      },
      {
        type: 'build',
        name: arch + '-' + type + '-' + link_mode + '-' + std.asciiLower(config),
      },
      {
        type: 'test',
        name: arch + '-' + type + '-' + link_mode + '-' + std.asciiLower(config),
      },
      {
        type: 'package',
        name: arch + '-' + type + '-' + link_mode + '-' + std.asciiLower(config),
      },
    ],
  };

local pp_generator(arch, type, link_mode, config) =
  {
    name: arch + '-' + type + '-' + link_mode + '-' + std.asciiLower(config),
    # configurePreset: arch + '-' + type + '-' + link_mode,
    configurePreset: type + '-' + arch,
    generators: [
      'TGZ',
    ],
    "configurations": [
      config
    ],
  };

{
  version: 9,
  cmakeMinimumRequired: {
    major: 3,
    minor: 30,
    patch: 0,
  },
  configurePresets: [
    {
      name: 'default',
      hidden: true,
      displayName: 'Default Config',
      description: 'Default build using Ninja Multi-Config generator',
      generator: 'Ninja Multi-Config',
      binaryDir: '${sourceDir}/build/${presetName}',
      cacheVariables: {
        CMAKE_EXPORT_COMPILE_COMMANDS: true,
        CPM_USE_LOCAL_PACKAGES: true,
        BUILD_TESTING: true,
      },
    },
    {
      name: 'asan',
      inherits: 'default',
      hidden: true,
      cacheVariables: {
        CMAKE_CXX_FLAGS_SANITIZE: '-U_FORTIFY_SOURCE -O2 -g -fsanitize=address,undefined -fno-omit-frame-pointer -fno-common',
      },
    },
    {
      name: 'static',
      hidden: true,
      cacheVariables: {
        'BUILD_SHARED_LIBS': false,
      },
    },
    {
      name: 'dynamic',
      hidden: true,
      cacheVariables: {
        'BUILD_SHARED_LIBS': true,
      },
    },
    {
      "name": "dev-common",
      "hidden": true,
      "inherits": [
        "dev-mode"
      ],
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/${presetName}",
      "cacheVariables": {
        "CMAKE_EXPORT_COMPILE_COMMANDS": true,
        "BUILD_MCSS_DOCS": false,
        "BUILD_SHARED_LIBS": true
      },
      "environment": {
        "CPM_USE_LOCAL_PACKAGES": "OFF"
      }
    },
    {
      "name": "dev-Linux",
      "inherits": [
        "dev-common",
        "ci-linux"
      ],
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug"
      }
    },
    {
      "name": "dev-Darwin",
      "inherits": [
        "dev-common",
        "ci-darwin"
      ],
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug"
      }
    },
    {
      "name": "dev-win64",
      "inherits": [
        "dev-common",
        "cppcheck",
        "ci-win64"
      ],
      "environment": {
        "UseMultiToolTask": "ON",
        "EnforceProcessCountAcrossBuilds": "ON"
      }
    },
  ], # TODO: + [cp_generator(arch, type, link_mode) for arch in archs for type in types for link_mode in link_modes],

  buildPresets: [] + [bp_generator(arch, type, link_mode, config) for arch in archs for type in types for link_mode in link_modes for config in configs],
  testPresets: [] + [tp_generator(arch, type, link_mode, config) for arch in archs for type in types for link_mode in link_modes for config in configs],
  packagePresets: [] + [pp_generator(arch, type, link_mode, config) for arch in archs for type in types for link_mode in link_modes for config in configs],
  workflowPresets: [] + [wp_generator(arch, type, link_mode, config) for arch in archs for type in types for link_mode in link_modes for config in configs],
}

