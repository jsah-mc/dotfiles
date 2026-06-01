import { createBinding } from "ags"
import Hyprland from "gi://AstalHyprland"
import { execAsync } from "ags/process"

type WorkspaceConfig = {
  id: number
}

const WORKSPACE_CONFIG: WorkspaceConfig[] = [
  { id: 1} ,
  { id: 2},
  { id: 3},
  { id: 4},
  { id: 5},
]

function switchWorkspace(id: number) {
  execAsync(`hyprctl dispatch workspace ${id}`).catch(console.error)
}

export function Workspaces() {
  const hypr = Hyprland.get_default()
  const focusedWorkspace = hypr ? createBinding(hypr, "focusedWorkspace") : null

  return (
    <box class="Workspaces" spacing={8}>
      {WORKSPACE_CONFIG.map(({ id }) => (
        <button
          class={
            focusedWorkspace
              ? focusedWorkspace((ws) =>
                  ws?.id === id ? "WorkspaceButton active" : "WorkspaceButton",
                )
              : "WorkspaceButton"
          }
          tooltipText={`Switch to workspace ${id}`}
          onClicked={() => switchWorkspace(id)}
        >
          <label
            label={
              focusedWorkspace
                ? focusedWorkspace((ws) =>
                    ws?.id === id ? `󰮯` : ``,
                  )
                : ``
            }
          />
        </button>
      ))}
    </box>
  )
}

export default Workspaces
