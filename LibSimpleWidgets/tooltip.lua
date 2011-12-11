local PADDING = 3
local MAX_WIDTH = 250
local MAX_HEIGHT = 500
local MOUSE_X_OFFSET = 18
local MOUSE_Y_OFFSET = 25

-- Public Functions

local function GetFontSize(self)
  return self.text:GetFontSize()
end

local function SetFontSize(self, size)
  self.text:SetFontSize(size)
  self:SetWidth(math.min(MAX_WIDTH, self.text:GetFullWidth() + PADDING * 2))
  self:SetHeight(math.min(MAX_HEIGHT, self.text:GetFullHeight() + PADDING * 2))
end

local function Show(self, owner, text)
  self.owner = owner
  self.text:SetText(text)
  self:SetWidth(math.min(MAX_WIDTH, self.text:GetFullWidth() + PADDING * 2))
  self:SetHeight(math.min(MAX_HEIGHT, self.text:GetFullHeight() + PADDING * 2))

  local m = Inspect.Mouse()
  local left, top = owner:GetBounds()
  self:SetPoint("TOPLEFT", owner, "TOPLEFT", m.x - left + MOUSE_X_OFFSET, m.y - top + MOUSE_Y_OFFSET)
  self:SetVisible(true)
end

local function Hide(self, owner)
  if self.owner ~= owner then return end
  self:SetVisible(false)
  self.owner = nil
end

local function InjectEvents(self, frame, tooltipTextFunc)
  local tooltip = self
  frame.Event.MouseIn = function() tooltip:Show(frame, tooltipTextFunc(tooltip)) end
  frame.Event.MouseMove = function() tooltip:Show(frame, tooltipTextFunc(tooltip)) end
  frame.Event.MouseOut = function() tooltip:Hide(frame) end
end


-- Constructor Function

function Library.LibSimpleWidgets.Tooltip(name, parent)
  local widget = UI.CreateFrame("Frame", name, parent)
  widget:SetBackgroundColor(0, 0, 0, 1)
  widget:SetLayer(999)
  Library.LibSimpleWidgets.SetBorder(widget, 1, 0.5, 0.5, 0.5, 1)

  local text = UI.CreateFrame("Text", name .. "Text", widget)
  text:SetPoint("TOPLEFT", widget, "TOPLEFT", PADDING, PADDING)
  text:SetPoint("BOTTOMRIGHT", widget, "BOTTOMRIGHT", -PADDING, -PADDING)
  text:SetWordwrap(true)
  widget:SetVisible(false)

  widget.text = text

  widget.GetFontSize = GetFontSize
  widget.SetFontSize = SetFontSize
  widget.Show = Show
  widget.Hide = Hide
  widget.InjectEvents = InjectEvents

  return widget
end