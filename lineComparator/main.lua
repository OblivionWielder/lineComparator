-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
-- MAIN.LUA
 
local widget = require "widget" 
    -- This is only included because I used the widget.newButton API for the example "undo" & "erase" buttons. It's not required for the drawing functionality.
 
math.randomseed( os.time() )
    -- This is only included to help generate truly random line colors in this example. It is not required.
 
        
-----------------------------------
-- VARIABLES & LINE TABLE (required)
-----------------------------------
local lineTable = {}
    -- This is a required table that will contain each drawn line as a separate display group, for easy referral and removal
 
local lineWidth = 12
    -- This required variable sets the pixel width for your drawn lines
 
local lineColor = {R=math.random(0,255), G=math.random(0,255), B=math.random(0,255)}
    -- These required variables set the R, G, & B color values for your drawn lines. I've set it up in this example to pick random values.
 
        
-----------------------------------
-- DRAW LINE FUNCTIONALITY (required)
-----------------------------------
local newLine = function(event)
 
        local function drawLine()
                local line = display.newLine(linePoints[#linePoints-1].x,linePoints[#linePoints-1].y,linePoints[#linePoints].x,linePoints[#linePoints].y)
                        line:setStrokeColor(lineColor.R, lineColor.G, lineColor.B);
                        line.strokeWidth=lineWidth;
                        lineTable[i]:insert(line)

        end
 
        if event.phase=="began" then
                i = #lineTable+1
                lineTable[i]=display.newGroup()
                display.getCurrentStage():setFocus(event.target)
                

                
                linePoints = nil
                linePoints = {};
                
                local pt = {}
                        pt.x = event.x;
                        pt.y = event.y;
                        table.insert(linePoints,pt);
                                        
        elseif event.phase=="moved" then
                local pt = {}
                        pt.x = event.x;
                        pt.y = event.y;
                                
                if not (pt.x==linePoints[#linePoints].x and pt.y==linePoints[#linePoints].y) then
                        table.insert(linePoints,pt)
                        drawLine()
                end
        
        elseif event.phase=="cancelled" or "ended" then
                display.getCurrentStage():setFocus(nil)
                i=nil
        end
        
return true
end     
 
 
-----------------------------------
-- UNDO & ERASE FUNCTIONS (not required)
-----------------------------------
local undo = function()
        if #lineTable>0 then
                lineTable[#lineTable]:removeSelf()
                lineTable[#lineTable]=nil
        end
        return true
end
 
local erase = function()
        for i = 1, #lineTable do
                lineTable[i]:removeSelf()
                lineTable[i] = nil
        end
        return true
end
 
 
-----------------------------------
-- UNDO & ERASE BUTTONS (not required)
-----------------------------------
local undoButton = widget.newButton{
        left = 25,
        top = display.contentHeight - 50,
        label = "Undo",
        width = 200, height = 56,
        cornerRadius = 8,
        onRelease = undo
        }
        
local eraseButton = widget.newButton{
        left = display.contentWidth-125,
        top = display.contentHeight - 50,
        label = "Erase",
        width = 200, height = 56,
        cornerRadius = 8,
        onRelease = erase
        }
 
        
-----------------------------------
-- EVENT LISTENER TO DRAW LINES (required)
-----------------------------------
Runtime:addEventListener("touch",newLine)
        -- NOTE: I set this up as a Runtime listener, but you can certainly add the listener to display objects instead, to control where the user can touch to begin drawing.