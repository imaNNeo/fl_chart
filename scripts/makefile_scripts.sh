#!/bin/bash

# Opens a link with the default browser of OS (It works cross-platform)
#
## You can call it like `open_link balad.ir` to open balad website on your default browser
open_link () {
  case "$(uname -s)" in
    Darwin)
      # macOS
      open "$1"
      ;;

    Linux)
      # Linux:
      xdg-open "$1"
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # Windows
      start "$1"
      ;;

     *)
       echo 'Not supported OS'
       ;;
  esac
}
