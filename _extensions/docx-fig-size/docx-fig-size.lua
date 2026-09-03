--[[
  docx-fig-size — cap figure width in Word output.

  ggplot / base-R plots are written by the `ragg` PNG device, which does NOT
  embed a DPI (pHYs) tag. Word and Pandoc therefore assume 96 dpi, so a 900 px
  figure (3 in at 300 dpi) is treated as 9.4 in wide and clamped to the full
  6.5 in text column — every graph fills the page.

  This filter gives every figure that has no explicit width a fixed display
  width. Height is left unset so Word keeps the file's own aspect ratio.
  Only runs for docx; every other format is untouched.
]]

local DEFAULT_WIDTH = "2.5in"

if not (quarto and quarto.doc and quarto.doc.is_format("docx")) then
  return {}
end

local function has_width(img)
  local w = img.attributes and img.attributes["width"]
  return w ~= nil and w ~= ""
end

local function Image(img)
  if not has_width(img) then
    img.attributes["width"] = DEFAULT_WIDTH
    img.attributes["height"] = nil
    return img
  end
end

return {
  { Image = Image }
}
