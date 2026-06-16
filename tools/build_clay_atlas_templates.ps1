param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )

    $fullPath = [System.IO.Path]::GetFullPath($Path)
    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($fullPath, $Content, $encoding)
}

function Ensure-Dir {
    param([string]$Path)
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
}

function New-Slot {
    param(
        [string]$Name,
        [int]$X,
        [int]$Y,
        [int]$W,
        [int]$H,
        [string]$Color,
        [string]$Notes
    )

    [ordered]@{
        name = $Name
        x = $X
        y = $Y
        w = $W
        h = $H
        color = $Color
        notes = $Notes
    }
}

function New-GridSlots {
    param(
        [object[]]$Definitions,
        [int]$Columns,
        [int]$SlotSize
    )

    $slots = @()
    for ($i = 0; $i -lt $Definitions.Count; $i++) {
        $def = $Definitions[$i]
        $x = ($i % $Columns) * $SlotSize
        $y = [math]::Floor($i / $Columns) * $SlotSize
        $slots += New-Slot -Name $def.name -X $x -Y $y -W $SlotSize -H $SlotSize -Color $def.color -Notes $def.notes
    }
    return $slots
}

function Add-UvData {
    param(
        [object[]]$Slots,
        [int]$Width,
        [int]$Height
    )

    foreach ($slot in $Slots) {
        $slot.uv_min = @(
            [math]::Round($slot.x / $Width, 6),
            [math]::Round($slot.y / $Height, 6)
        )
        $slot.uv_max = @(
            [math]::Round(($slot.x + $slot.w) / $Width, 6),
            [math]::Round(($slot.y + $slot.h) / $Height, 6)
        )
    }
    return $Slots
}

function Draw-ClayNoise {
    param(
        [System.Drawing.Graphics]$Graphics,
        [System.Drawing.Rectangle]$Rect,
        [System.Drawing.Color]$BaseColor,
        [System.Random]$Random
    )

    for ($i = 0; $i -lt 240; $i++) {
        $alpha = $Random.Next(14, 48)
        $delta = $Random.Next(-24, 25)
        $r = [math]::Max(0, [math]::Min(255, $BaseColor.R + $delta))
        $g = [math]::Max(0, [math]::Min(255, $BaseColor.G + $delta))
        $b = [math]::Max(0, [math]::Min(255, $BaseColor.B + $delta))
        $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($alpha, $r, $g, $b))
        $x = $Random.Next($Rect.Left, $Rect.Right)
        $y = $Random.Next($Rect.Top, $Rect.Bottom)
        $w = $Random.Next(2, 15)
        $h = $Random.Next(1, 8)
        $Graphics.FillEllipse($brush, $x, $y, $w, $h)
        $brush.Dispose()
    }

    for ($i = 0; $i -lt 24; $i++) {
        $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb($Random.Next(26, 66), 24, 15, 10)), $Random.Next(1, 4)
        $x1 = $Random.Next($Rect.Left, $Rect.Right)
        $y1 = $Random.Next($Rect.Top, $Rect.Bottom)
        $x2 = $x1 + $Random.Next(-90, 91)
        $y2 = $y1 + $Random.Next(-20, 21)
        $Graphics.DrawLine($pen, $x1, $y1, $x2, $y2)
        $pen.Dispose()
    }
}

function Save-Atlas {
    param(
        [string]$Path,
        [string]$Title,
        [int]$Width,
        [int]$Height,
        [object[]]$Slots,
        [bool]$Transparent = $false
    )

    $bitmap = New-Object System.Drawing.Bitmap $Width, $Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    if ($Transparent) {
        $graphics.Clear([System.Drawing.Color]::FromArgb(0, 0, 0, 0))
    } else {
        $graphics.Clear([System.Drawing.ColorTranslator]::FromHtml("#160f0b"))
    }

    $random = New-Object System.Random 247
    $font = New-Object System.Drawing.Font "Arial", 20, ([System.Drawing.FontStyle]::Bold)
    $smallFont = New-Object System.Drawing.Font "Arial", 14, ([System.Drawing.FontStyle]::Regular)
    $labelBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(235, 238, 219, 190))
    $labelBack = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(92, 0, 0, 0))
    $borderPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(190, 218, 180, 108)), 2
    $guidePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(80, 218, 180, 108)), 1

    foreach ($slot in $Slots) {
        $rect = New-Object System.Drawing.Rectangle $slot.x, $slot.y, $slot.w, $slot.h
        $baseColor = [System.Drawing.ColorTranslator]::FromHtml($slot.color)
        $slotBrush = New-Object System.Drawing.SolidBrush $baseColor
        $graphics.FillRectangle($slotBrush, $rect)
        $slotBrush.Dispose()

        Draw-ClayNoise -Graphics $graphics -Rect $rect -BaseColor $baseColor -Random $random

        $graphics.DrawRectangle($borderPen, $rect)
        $graphics.DrawLine($guidePen, $rect.Left, $rect.Top, $rect.Right, $rect.Bottom)
        $graphics.DrawLine($guidePen, $rect.Right, $rect.Top, $rect.Left, $rect.Bottom)

        $textRect = New-Object System.Drawing.RectangleF ($rect.Left + 14), ($rect.Bottom - 68), ($rect.Width - 28), 52
        $graphics.FillRectangle($labelBack, $textRect)
        $graphics.DrawString($slot.name, $smallFont, $labelBrush, $textRect)
    }

    $titleBack = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(150, 0, 0, 0))
    $graphics.FillRectangle($titleBack, 0, 0, $Width, 54)
    $graphics.DrawString($Title, $font, $labelBrush, 18, 14)

    $titleBack.Dispose()
    $guidePen.Dispose()
    $borderPen.Dispose()
    $labelBack.Dispose()
    $labelBrush.Dispose()
    $smallFont.Dispose()
    $font.Dispose()
    $graphics.Dispose()

    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()
}

function Write-SlotJson {
    param(
        [string]$Path,
        [string]$AtlasName,
        [string]$ImagePath,
        [int]$Width,
        [int]$Height,
        [object[]]$Slots
    )

    $data = [ordered]@{
        atlas = $AtlasName
        image = $ImagePath
        size = @($Width, $Height)
        coordinate_space = "pixels_from_top_left_and_normalized_uv"
        slots = (Add-UvData -Slots $Slots -Width $Width -Height $Height)
    }

    $json = $data | ConvertTo-Json -Depth 8
    Write-Utf8NoBom -Path $Path -Content ($json + [Environment]::NewLine)
}

function Write-LayoutDoc {
    param(
        [string]$Path,
        [string]$Title,
        [string]$ImagePath,
        [object[]]$Slots
    )

    $lines = @()
    $lines += "# $Title"
    $lines += ""
    $lines += "Generated placeholder atlas. Replace the painted contents later, but keep slot names and bounds stable unless the Godot and Blender references are updated in the same commit."
    $lines += ""
    $lines += "- Image: ``$ImagePath``"
    $lines += "- Source imagery may be produced in ChatGPT or Google Flow, but this repository owns the slot layout, names, and import contract."
    $lines += "- Coordinates are pixels from the top-left corner."
    $lines += ""
    $lines += "| Slot | X | Y | W | H | Notes |"
    $lines += "| --- | ---: | ---: | ---: | ---: | --- |"
    foreach ($slot in $Slots) {
        $lines += "| ``$($slot.name)`` | $($slot.x) | $($slot.y) | $($slot.w) | $($slot.h) | $($slot.notes) |"
    }
    $lines += ""

    Write-Utf8NoBom -Path $Path -Content (($lines -join [Environment]::NewLine) + [Environment]::NewLine)
}

function Write-Material {
    param(
        [string]$Path,
        [string]$Name,
        [string]$Color,
        [string]$Roughness
    )

    $c = [System.Drawing.ColorTranslator]::FromHtml($Color)
    $r = [math]::Round($c.R / 255, 4)
    $g = [math]::Round($c.G / 255, 4)
    $b = [math]::Round($c.B / 255, 4)

    $lines = @(
        '[gd_resource type="StandardMaterial3D" format=3]'
        ''
        '[resource]'
        "resource_name = `"$Name`""
        "albedo_color = Color($r, $g, $b, 1)"
        "roughness = $Roughness"
    )

    Write-Utf8NoBom -Path $Path -Content (($lines -join [Environment]::NewLine) + [Environment]::NewLine)
}

$sourceDir = Join-Path $Root "assets\texture_sources\atlases"
$textureDir = Join-Path $Root "assets\textures\atlases"
$uiDir = Join-Path $Root "assets\ui\atlas"
$materialDir = Join-Path $Root "assets\materials\clay"

Ensure-Dir $sourceDir
Ensure-Dir $textureDir
Ensure-Dir $uiDir
Ensure-Dir $materialDir

$surfaceDefs = @(
    @{ name = "plaster_warm"; color = "#8a6748"; notes = "Primary clay-plaster wall tone." }
    @{ name = "plaster_cold"; color = "#665b4f"; notes = "Dim blue-grey plaster for colder rooms." }
    @{ name = "aged_wood"; color = "#4b2d1d"; notes = "Door frames, panels, shelves, bannisters." }
    @{ name = "floor_clay_boards"; color = "#3d2418"; notes = "Clay floorboards and darker timber." }
    @{ name = "burgundy_runner"; color = "#681b18"; notes = "Rugs, runners, red thresholds." }
    @{ name = "dark_room_clay"; color = "#18100d"; notes = "Unwritten/underlit room massing." }
    @{ name = "iron_aged"; color = "#38312a"; notes = "Keys, locks, hinges, and plates." }
    @{ name = "candle_wax"; color = "#d9c495"; notes = "Candles and pale wax buildup." }
    @{ name = "lemon_leaf"; color = "#475636"; notes = "Conservatory lemon foliage." }
    @{ name = "lemon_peel"; color = "#c7a137"; notes = "Lemon fruit and yellowed labels." }
    @{ name = "black_book_cover"; color = "#110d0b"; notes = "Register, hidden books, void props." }
    @{ name = "raw_plaster"; color = "#b69670"; notes = "Exposed clay, chipped walls, repair areas." }
    @{ name = "soot_stain"; color = "#211b16"; notes = "Burn marks and chimney-dark surfaces." }
    @{ name = "damp_stone"; color = "#504b41"; notes = "Cellar, well, and water tank stone." }
    @{ name = "clay_flesh"; color = "#c49b7b"; notes = "Puppet skin base." }
    @{ name = "reserve_surface"; color = "#7b6a58"; notes = "Reserved for first Blender discovery." }
)

$detailDefs = @(
    @{ name = "fingerprint_smear"; color = "#6f574a"; notes = "Soft thumbprint and dragged clay marks." }
    @{ name = "thumbprint_whorl"; color = "#8b7565"; notes = "Close clay whorl detail from Mara references." }
    @{ name = "hairline_cracks"; color = "#221712"; notes = "Thin surface cracks." }
    @{ name = "wall_weeps"; color = "#30100e"; notes = "Dark red/brown wall seep marks." }
    @{ name = "black_mold"; color = "#111513"; notes = "Mold and corner dirt." }
    @{ name = "soot_edge"; color = "#1e1712"; notes = "Burnt edge and fireplace residue." }
    @{ name = "wax_drip"; color = "#d8be82"; notes = "Candle drips and warm highlights." }
    @{ name = "red_thread"; color = "#7b1715"; notes = "Evidence board red thread and thin horror lines." }
    @{ name = "handwriting_lines"; color = "#241610"; notes = "Ledger strokes and wall-script decals." }
    @{ name = "tape_measure_marks"; color = "#c9a96d"; notes = "Caton measure ticks and ruler marks." }
    @{ name = "compass_scratch"; color = "#b19865"; notes = "Compass lie scratches and map nicks." }
    @{ name = "rose_trace"; color = "#5b1b24"; notes = "Sealed wing rose scent only." }
    @{ name = "lemon_pollen"; color = "#d8b957"; notes = "Conservatory lemon pollen marks." }
    @{ name = "nail_marks"; color = "#2a1713"; notes = "Dragged fingernail scratches." }
    @{ name = "paper_tape"; color = "#b99b6f"; notes = "Archive repair tape and parchment seams." }
    @{ name = "reserve_detail"; color = "#514234"; notes = "Reserved for room-specific discoveries." }
)

$uiDefs = @(
    @{ name = "ledger_panel"; color = "#5a3d25"; notes = "Living Ledger parchment backing." }
    @{ name = "journal_panel"; color = "#3c281b"; notes = "Journal overlay backing." }
    @{ name = "map_tab_active"; color = "#7c5b32"; notes = "Active floor tab." }
    @{ name = "map_tab_locked"; color = "#302218"; notes = "Locked floor tab." }
    @{ name = "evidence_card"; color = "#b99a69"; notes = "Pinned evidence card face." }
    @{ name = "button_frame"; color = "#876533"; notes = "Thin parchment UI borders." }
    @{ name = "red_pin"; color = "#9d241d"; notes = "Evidence/map player pin." }
    @{ name = "black_ink_smudge"; color = "#17100d"; notes = "Ink pools, crossed-out notes, shadow trim." }
)

$surfaceSlots = New-GridSlots -Definitions $surfaceDefs -Columns 4 -SlotSize 512
$detailSlots = New-GridSlots -Definitions $detailDefs -Columns 4 -SlotSize 512
$uiSlots = New-GridSlots -Definitions $uiDefs -Columns 4 -SlotSize 512

Save-Atlas -Path (Join-Path $textureDir "Clay_Surface_Atlas_01.png") -Title "Clay_Surface_Atlas_01 - template" -Width 2048 -Height 2048 -Slots $surfaceSlots
Save-Atlas -Path (Join-Path $textureDir "Clay_Detail_Decal_Atlas_01.png") -Title "Clay_Detail_Decal_Atlas_01 - template" -Width 2048 -Height 2048 -Slots $detailSlots
Save-Atlas -Path (Join-Path $uiDir "UI_Parchment_Atlas_01.png") -Title "UI_Parchment_Atlas_01 - template" -Width 2048 -Height 1024 -Slots $uiSlots

Write-SlotJson -Path (Join-Path $textureDir "Clay_Surface_Atlas_01_slots.json") -AtlasName "Clay_Surface_Atlas_01" -ImagePath "res://assets/textures/atlases/Clay_Surface_Atlas_01.png" -Width 2048 -Height 2048 -Slots $surfaceSlots
Write-SlotJson -Path (Join-Path $textureDir "Clay_Detail_Decal_Atlas_01_slots.json") -AtlasName "Clay_Detail_Decal_Atlas_01" -ImagePath "res://assets/textures/atlases/Clay_Detail_Decal_Atlas_01.png" -Width 2048 -Height 2048 -Slots $detailSlots
Write-SlotJson -Path (Join-Path $uiDir "UI_Parchment_Atlas_01_slots.json") -AtlasName "UI_Parchment_Atlas_01" -ImagePath "res://assets/ui/atlas/UI_Parchment_Atlas_01.png" -Width 2048 -Height 1024 -Slots $uiSlots

Write-LayoutDoc -Path (Join-Path $sourceDir "Clay_Surface_Atlas_01.layout.md") -Title "Clay_Surface_Atlas_01 Layout" -ImagePath "res://assets/textures/atlases/Clay_Surface_Atlas_01.png" -Slots $surfaceSlots
Write-LayoutDoc -Path (Join-Path $sourceDir "Clay_Detail_Decal_Atlas_01.layout.md") -Title "Clay_Detail_Decal_Atlas_01 Layout" -ImagePath "res://assets/textures/atlases/Clay_Detail_Decal_Atlas_01.png" -Slots $detailSlots
Write-LayoutDoc -Path (Join-Path $sourceDir "UI_Parchment_Atlas_01.layout.md") -Title "UI_Parchment_Atlas_01 Layout" -ImagePath "res://assets/ui/atlas/UI_Parchment_Atlas_01.png" -Slots $uiSlots

Write-Material -Path (Join-Path $materialDir "WW_Mat_Clay_Wall.tres") -Name "WW_Mat_Clay_Wall" -Color "#8a6748" -Roughness "0.95"
Write-Material -Path (Join-Path $materialDir "WW_Mat_Clay_Wood.tres") -Name "WW_Mat_Clay_Wood" -Color "#4b2d1d" -Roughness "0.9"
Write-Material -Path (Join-Path $materialDir "WW_Mat_Clay_Floor.tres") -Name "WW_Mat_Clay_Floor" -Color "#3d2418" -Roughness "0.93"
Write-Material -Path (Join-Path $materialDir "WW_Mat_Clay_Dark.tres") -Name "WW_Mat_Clay_Dark" -Color "#18100d" -Roughness "0.98"

$materialReadme = @(
    "# Clay Material Placeholders"
    ""
    "These are Godot-side placeholder materials for imported GLB rooms. Blender remains the source of truth for UV layout and final baked texture assignments."
    ""
    "- Use ``WW_Mat_Clay_Wall`` for plaster shell pieces."
    "- Use ``WW_Mat_Clay_Wood`` for frames, shelves, doors, and rails."
    "- Use ``WW_Mat_Clay_Floor`` for clay boards and ground timber."
    "- Use ``WW_Mat_Clay_Dark`` for unwritten, hidden, or not-yet-rendered house geometry."
    ""
    "Atlas slot definitions live in ``assets/textures/atlases`` and ``assets/ui/atlas`` as JSON. Keep slot names stable once Blender meshes start using them."
)
Write-Utf8NoBom -Path (Join-Path $materialDir "README.md") -Content (($materialReadme -join [Environment]::NewLine) + [Environment]::NewLine)

Write-Host "Clay atlas templates generated."
