-- Aseprite Script to open dialog with relevant color shades
-- Written by Dominick John, 2019 
-- (rma fork)
-- https://github.com/alpineboarder/aseprite/

function lerp(x, y, a)
    return x * (1 - a) + y * a
end

function lerp_colors(c1, c2, a)
    return Color(
        lerp(c1.red, c2.red, a), lerp(c1.green, c2.green, a), lerp(c1.blue, c2.blue, a)
    )
end

function colorShift(color, hueShift, satShift, lightShift, shadeShift)
    local newColor = Color(color) -- Make a copy of the color so we don't modify the parameter

    -- SHIFT HUE
    newColor.hue = newColor.hue + hueShift * 359

    -- SHIFT SATURATION
    if (satShift > 0)
        then
        newColor.saturation = lerp(newColor.saturation, 1, satShift)
    elseif (satShift < 0)
        then
        newColor.saturation = lerp(newColor.saturation, 0, -satShift)
    end

    -- SHIFT LIGHTNESS
    if (lightShift > 0)
        then
        newColor.lightness = lerp(newColor.lightness, 1, lightShift)
    elseif (lightShift < 0)
        then
        newColor.lightness = lerp(newColor.lightness, 0, -lightShift)
    end

    -- SHIFT SHADING
    local newShade = Color{red = newColor.red, green = newColor.green, blue = newColor.blue}
     if (shadeShift >= 0)
        then
        newShade.hue = newShade.hue - 60
        newColor = lerp_colors(newColor, newShade, shadeShift)
    elseif (shadeShift < 0)
        then
        newShade.hue = newShade.hue + 60
        newColor = lerp_colors(newColor, newShade,-shadeShift)
    end

    return newColor
end

function showColors()
    local dlg
    dlg = Dialog{
        title="Color Shading",
        onclose=function()
            ColorShadingWindowBounds = dlg.bounds
        end
    }

    -- CURRENT FOREGROUND COLOR
    local foreground = app.fgColor

    -- SHADING COLORS
    local S1 = colorShift(foreground,  0.06, -0.78, -0.52, -0.5)
    local S2 = colorShift(foreground,  0.02, -0.58, -0.41, -0.35)
    local S3 = colorShift(foreground, -0.02, -0.15, -0.1,  -0.2)
    local S5 = colorShift(foreground, -0.03, -0.15,  0.2,  0.1)
    local S6 = colorShift(foreground, -0.04, -0.25,  0.3,  0.2)
    local S7 = colorShift(foreground, -0.05, -0.4,   0.4,  0.3)

    -- SHADING INV
    local I1 = colorShift(foreground, -0.06, -0.78, -0.52,  0.5)
    local I2 = colorShift(foreground, -0.02, -0.58, -0.41,  0.35)
    local I3 = colorShift(foreground,  0.02, -0.15, -0.1,   0.2)
    local I5 = colorShift(foreground,  0.03, -0.15,  0.2, -0.1)
    local I6 = colorShift(foreground,  0.04, -0.25,  0.3,  -0.2)
    local I7 = colorShift(foreground,  0.05, -0.4,   0.4,  -0.3)

    -- SHADING ORIGINAL
    local O1 = colorShift(foreground, 0, 0.3, -0.6, -0.6)
    local O2 = colorShift(foreground, 0, 0.2, -0.2, -0.3)
    local O3 = colorShift(foreground, 0, 0.1, -0.1, -0.1)
    local O5 = colorShift(foreground, 0, 0.1,  0.1,  0.1)
    local O6 = colorShift(foreground, 0, 0.2,  0.2,  0.2)
    local O7 = colorShift(foreground, 0, 0.3,  0.5,  0.4)

    -- LIGHTNESS COLORS
    local L1 = colorShift(foreground, 0, 0, -0.5,  0)
    local L2 = colorShift(foreground, 0, 0, -0.25, 0)
    local L3 = colorShift(foreground, 0, 0, -0.1,  0)
    local L5 = colorShift(foreground, 0, 0,  0.1,  0)
    local L6 = colorShift(foreground, 0, 0,  0.25, 0)
    local L7 = colorShift(foreground, 0, 0,  0.5,  0)

    -- SATURATION COLORS
    local C1 = colorShift(foreground, 0, -0.8, 0, 0)
    local C2 = colorShift(foreground, 0, -0.4, 0, 0)
    local C3 = colorShift(foreground, 0, -0.2, 0, 0)
    local C5 = colorShift(foreground, 0,  0.2, 0, 0)
    local C6 = colorShift(foreground, 0,  0.4, 0, 0)
    local C7 = colorShift(foreground, 0,  0.8, 0, 0)

    -- HUE COLORS
    local H1 = colorShift(foreground, -0.11, 0, 0, 0)
    local H2 = colorShift(foreground, -0.04, 0, 0, 0)
    local H3 = colorShift(foreground, -0.02, 0, 0, 0)
    local H5 = colorShift(foreground,  0.02, 0, 0, 0)
    local H6 = colorShift(foreground,  0.04, 0, 0, 0)
    local H7 = colorShift(foreground,  0.11, 0, 0, 0)

    -- DIALOGUE
    dlg
    :color{ label="Current Color", color=foreground }
    :button{ text="Change",
        onclick=function()
            dlg:close()
            showColors()
        end }

    -- SHADING
    :shades{ id='sha', label='Shading',
           colors={ S1, S2, S3, foreground, S5, S6, S7 },
           onclick=function(ev) app.fgColor=ev.color end }
    -- SHADING
    :shades{ id='sha', label='Shading Inv',
           colors={ I1, I2, I3, foreground, I5, I6, I7 },
           onclick=function(ev) app.fgColor=ev.color end }
    -- SHADING
    -- SHADING
    :shades{ id='sho', label='Shading Original',
           colors={ O1, O2, O3, foreground, O5, O6, O7 },
           onclick=function(ev) app.fgColor=ev.color end }

    -- LIGHTNESS
    :shades{ id='lit', label='Lightness',
           colors={ L1, L2, L3, foreground, L5, L6, L7 },
           onclick=function(ev) app.fgColor=ev.color end }

    -- SATURATION
    :shades{ id='sat', label='Saturation',
           colors={ C1, C2, C3, foreground, C5, C6, C7 },
           onclick=function(ev) app.fgColor=ev.color end }

    -- HUE
    :shades{ id='hue', label='Hue',
           colors={ H1, H2, H3, foreground, H5, H6, H7 },
           onclick=function(ev) app.fgColor=ev.color end }

    dlg:show{ wait=false, bounds=ColorShadingWindowBounds }
end

-- Run the script
do
  showColors()
end
