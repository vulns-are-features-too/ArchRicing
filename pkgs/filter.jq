to_entries[]
| select(.value.src == "aur")
| select(.value.is_guest_only != false)
| .key
