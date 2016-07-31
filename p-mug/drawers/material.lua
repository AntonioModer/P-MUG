local Path = string.sub(..., 1, -string.len(".drawers.material"))
local Class = require(Path..".third-party.middleclass")
local DBase = require(Path..".api.drawerbase")

local Material = require(Path..".third-party.material-love")

local DMaterial = Class("drawer.material",DBase)

local Config = {}
Config.rectangleExpand = 1 --How much to expand the rectangle when it's down ?
Config.circleExpand = 1 --How much to expand the circle when it's down ?

--[[
Drawing Args:
  rectangle shapes:
    DShadow, DExpand, RColor, NColor, HColor
      DShadow: boolean: To disable the shadow or not.
      DExpand: boolean: To disable the expand affect or not.
      RColor: table: {red,green,blue,alpha} The color of the ripple.
      NColor: table: {red,green,blue,alpha} The color of the rectangle when not hovered.
      HColor: table: {red,green,blue,alpha} The color of the rectangle when hovered.

  text shapes:
    FontType, FontColor
      FontType: string: The type of the material robot font to use.
      FontColor: table: {red,green,blue,alpha} The color of the text.
]]

function DMaterial:initialize()
  DBase.initialize(self)
  self.sd = {}
end

function DMaterial:getName()
  return "Material"
end

function DMaterial:draw_circle(shape,obj)
  local dtype, x, y, r = shape:getDType()
  local DShadow, DExpand, RColor, NColor, HColor = shape:getDrawingArgs()

  if not shape.ripple then --Creating the ripple
    shape.rippleStarted = false
    shape.ripple = Material.ripple.circle(x,y,r+Config.circleExpand,0.5)
    shape:addUpdate(function(dt,shp,obj) shp.ripple:update(dt) end) --Adding a hook to update the ripple.
  end

  local isDown, dx, dy = shape:isDown()
  local isHovered = shape:isHovered()

  if isDown and not DExpand then r = r+Config.circleExpand end --Expand Effect

  if isDown then
    if not shape.rippleStarted then
      shape.ripple.circle.x, shape.ripple.circle.y, shape.ripple.circle.r = x,y,r
      shape.ripple:start(dx,dy, unpack(RColor or {Material.colors.main("blue")}))
      shape.rippleStarted = true
    end
  else
    if shape.rippleStarted then
      shape.ripple.circle.x, shape.ripple.circle.y, shape.ripple.circle.r = x,y,r
      shape.ripple:fade()
      shape.rippleStarted = false
    end
  end

  if isHovered then
    love.graphics.setColor(HColor or {Material.colors("grey","100")})
  else
    love.graphics.setColor(NColor or {Material.colors.main("white")})
  end

  local _, _, z = obj:getPosition()
  if z and not DShadow then
    z = math.floor(z+0.5) if z > 4 then z = 4 end
    if isDown then Material.fab(x,y,r,z+1)
    elseif z > 0 then Material.fab(x,y,r,z) end
  end

  love.graphics.circle("fill",x,y,r)

  shape.ripple:draw()
end

function DMaterial:draw_rectangle(shape,obj)
  local dtype, x, y, w, h = shape:getDType()
  local DShadow, DExpand, RColor, NColor, HColor = shape:getDrawingArgs()
  
  if not shape.ripple then --Creating the ripple
    shape.rippleStarted = false
    shape.ripple = Material.ripple.box(x-Config.rectangleExpand,y-Config.rectangleExpand,w+Config.rectangleExpand*2,h+Config.rectangleExpand*2,0.5)
    shape:addUpdate(function(dt,shp,obj) shp.ripple:update(dt) end) --Adding a hook to update the ripple.
  end

  local isDown, dx, dy = shape:isDown()
  local isHovered = shape:isHovered()

  if isDown and not DExpand then x,y,w,h = x-Config.rectangleExpand,y-Config.rectangleExpand,w+Config.rectangleExpand*2,h+Config.rectangleExpand*2 end --Expand Effect

  if isDown then
    if not shape.rippleStarted then
      shape.ripple.box.x, shape.ripple.box.y, shape.ripple.box.w, shape.ripple.box.h = x,y,w,h
      shape.ripple:start(dx,dy, unpack(RColor or {Material.colors.main("blue")}))
      shape.rippleStarted = true
    end
  else
    if shape.rippleStarted then
      shape.ripple.box.x, shape.ripple.box.y, shape.ripple.box.w, shape.ripple.box.h = x,y,w,h
      shape.ripple:fade()
      shape.rippleStarted = false
    end
  end

  if isHovered then
    love.graphics.setColor(HColor or {Material.colors("grey","100")})
  else
    love.graphics.setColor(NColor or {Material.colors.main("white")})
  end

  love.graphics.setLineWidth(1)

  local _, _, z = obj:getPosition()
  if z and not DShadow then
    z = math.floor(z+0.5) if z > 4 then z = 4 end
    if isDown then Material.shadow.draw(x,y,w,h,false,z+1)
    elseif z > 0 then Material.shadow.draw(x,y,w,h,false,z) end
  end

  love.graphics.rectangle("fill",x,y,w,h)

  shape.ripple:draw()
end

function DMaterial:draw_text(shape,obj)
  local fonttype, fontcolor = shape:getDrawingArgs()
  local dtype, t, x, y, l, a = shape:getDType(Material.roboto[fonttype or "button"])
  love.graphics.setColor(fontcolor or {Material.colors.mono("black","button")})
  love.graphics.setLineWidth(1)
  love.graphics.setFont(Material.roboto[fonttype or "button"])
  love.graphics.printf(t, x, y, l, a)
end

function DMaterial:draw_icon(shape,obj)
  local dtype, icon, x,y, rotation, color, active, invert = shape:getDType()
  Material.icons.draw(icon, x,y, rotation, color, active, invert)
end

return DMaterial
