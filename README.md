# esydune

Self configurable dune invocations for esy projects.

1. Add `esydune` dependency to your project:
    ```
    "dependencies": {
      "esydune": "*"
    },
    "resolutions": {
      "esydune": "github:esy-ocaml/esydune#b008b59"
    }
    ```

2. Specify it as `"build"`, `"buildDev"` and `"install"` commands:
    ```
    "esy": {
      "build": "esydune build",
      "buildDev": "esydune build",
      "install": "esydune install"
    }
    ```
