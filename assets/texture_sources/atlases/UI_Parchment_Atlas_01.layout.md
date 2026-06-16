# UI_Parchment_Atlas_01 Layout

Generated placeholder atlas. Replace the painted contents later, but keep slot names and bounds stable unless the Godot and Blender references are updated in the same commit.

- Image: `res://assets/ui/atlas/UI_Parchment_Atlas_01.png`
- Source imagery may be produced in ChatGPT or Google Flow, but this repository owns the slot layout, names, and import contract.
- Coordinates are pixels from the top-left corner.

| Slot | X | Y | W | H | Notes |
| --- | ---: | ---: | ---: | ---: | --- |
| `ledger_panel` | 0 | 0 | 512 | 512 | Living Ledger parchment backing. |
| `journal_panel` | 512 | 0 | 512 | 512 | Journal overlay backing. |
| `map_tab_active` | 1024 | 0 | 512 | 512 | Active floor tab. |
| `map_tab_locked` | 1536 | 0 | 512 | 512 | Locked floor tab. |
| `evidence_card` | 0 | 512 | 512 | 512 | Pinned evidence card face. |
| `button_frame` | 512 | 512 | 512 | 512 | Thin parchment UI borders. |
| `red_pin` | 1024 | 512 | 512 | 512 | Evidence/map player pin. |
| `black_ink_smudge` | 1536 | 512 | 512 | 512 | Ink pools, crossed-out notes, shadow trim. |

