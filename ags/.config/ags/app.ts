import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./widget/Bar"
import { LauncherWindow, toggleLauncher } from "./widget/Launcher"

app.start({
  instanceName: "dotfiles-shell",
  css: style,
  requestHandler(argv, response) {
    if (argv[0] === "launcher-toggle") {
      toggleLauncher()
      response("ok")
      return
    }
    response("unknown request")
  },
  main() {
    return [...app.get_monitors().map(Bar), LauncherWindow()]
  },
})
