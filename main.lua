io.stdout:setvbuf("no")

local PMug = require("p-mug")
local OBase = require("p-mug.api.objectbase")
local HBase = require("p-mug.api.handlerbase")


local Material = require("p-mug.third-party.material-love")

function love.load(args)
  love.graphics.setBackgroundColor(Material.colors.background("light"))
  local TView = PMug.newView("test")
  local TButton = PMug.Object.button(10,10,100,35,"Quit",function() love.event.quit() end)
  local TFrame = PMug.Object.frame(100,100,200,200,"Frame Test")
  TView:registerObject(TButton,0):registerObject(TFrame,4)
  PMug.setActiveView("test")
end

function love.update(dt)
  PMug.update(dt)
end

function love.draw()
  PMug.draw()
end

function love.mousepressed(x,y,button,istouch)
  PMug.mousepressed(x,y,button,istouch)
end

function love.mousemoved(x,y,dx,dy)
  PMug.mousemoved(x,y,dx,dy)
end

function love.mousereleased(x,y,button,istouch)
  PMug.mousereleased(x,y,button,istouch)
end

function love.touchpressed(id,x,y,dx,dy,pressure)
  PMug.touchpressed(id,x,y,dx,dy,pressure)
end

function love.touchmoved(id,x,y,dx,dy,pressure)
  PMug.touchmoved(id,x,y,dx,dy,pressure)
end

function love.touchreleased(id,x,y,dx,dy,pressure)
  PMug.touchreleased(id,x,y,dx,dy,pressure)
end

function love.keypressed(key,isrepeat)
  PMug.keypressed(key,isrepeat)
end

function love.keyreleased(key)
  PMug.keyreleased(key)
end

function love.textinput(text)
  PMug.textinput(text)
end