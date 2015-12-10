local cmpt = require("component")
local shell = require("shell")
local fs = require("filesystem")
local computer = require("computer")

if(not fs.exists(shell.getWorkingDirectory() .. "/radars.ids")) then
  print("You failed to provide an ID file named radars.ids.  Exiting...")
  return 1
end

local radars = {}
for rdr in io.lines(shell.getWorkingDirectory() .. "/radars.ids") do -- Fetch radar info from user-provided file
  local rdrParts = {}
  for i in string.gmatch(rdr, "%S+") do -- Split rdr into parts
    table.insert(rdrParts,i)
  end
  if(#rdrParts < 4) then
    print("A radar isn't fully defined.  Needs four parts: id, x coord, y coord, and z coord.  Exiting...")
    return 1
  end
  table.insert(radars,{radar=cmpt.proxy(rdrParts[1]), x=tonumber(rdrParts[2]), y=tonumber(rdrParts[3]), z=tonumber(rdrParts[4])})
end

if(#radars < 4) then
  print("radars.ids does not contain enough radar blocks to perform function (requires at least four).  Exiting...")
  return 1
end

local where = ...

print("Starting Radar-based player tracking.  Using the following radars:")
for rNum, radar in pairs(radars) do
  print(rNum .. "- " .. radar.radar.address .. " at (x " .. radar.x .. ", y " .. radar.y .. ", z " .. radar.z .. ")")
end

local whereLog = shell.getWorkingDirectory() .. "/players.log"

if(where ~= nil) then
  whereLog = where
end

print("Logging to " .. whereLog)

local plog = io.open(whereLog, "a")

function round(n, mult)
  mult = mult or 1
  return math.floor((n + mult/2)/mult) * mult
end

local loopCount = 0

while true do
  local serverGivesLocs = false
  local foundPlayers = {}
  for rNum, radar in pairs(radars) do
    for _, plyr in pairs(radar.radar.getPlayers(32)) do
      if(foundPlayers[plyr.name] == nil) then
        foundPlayers[plyr.name] = {}
      end
      
      if(plyr.x ~= nil) then -- Server allows for straight capture of player locations.  That'll make thing immensely easier.
        serverGivesLocs = true
        foundPlayers[plyr.name].x = plyr.x
        foundPlayers[plyr.name].y = plyr.y
        foundPlayers[plyr.name].z = plyr.z
      else -- Server will only give distance to player
        foundPlayers[plyr.name][rNum] = plyr.distance
      end
    end
  end

  if(not serverGivesLocs) then
    -- Uses code from https://github.com/gheja/trilateration.js/blob/master/trilateration.js
  
    local function sq(num)
      return num * num
    end
    
    local function mag(vec)
      return math.sqrt(sq(vec.x) + sq(vec.y) + sq(vec.z))
    end
    
    local function vecdot(a, b)
      return a.x * b.x + a.y * b.y + a.z * b.z
    end
    
    local function vecsub(a, b)
      return {x=a.x-b.x, y=a.y-b.y, z=a.z-b.z}
    end
    
    local function vecadd(a, b)
      return {x=a.x+b.x, y=a.y+b.y, z=a.z+b.z}
    end
    
    local function vecdiv(a, b)
      return {x=a.x/b, y=a.y/b, z=a.z/b}
    end
    
    local function vecmul(a, b)
      return {x=a.x*b, y=a.y*b, z=a.z*b}
    end
    
    local function veccross(a, b)
      return {x=a.y*b.z - a.z*b.y, y=a.z*b.x - a.x*b.z, z=a.x*b.y - a.y*b.x}
    end
    
    for name, plyr in pairs(foundPlayers) do
      while true do
        local rdrs = {}
        local dists = {}
        for rNum, dist in pairs(plyr) do
          local radar = radars[rNum]
          table.insert(rdrs, radar)
          table.insert(dists, dist)
        end
        
        ex = vecdiv(vecsub(rdrs[2], rdrs[1]), mag(vecsub(rdrs[2], rdrs[1])))
        i = vecdot(ex, vecsub(rdrs[3], rdrs[1]))
        a = vecsub(vecsub(rdrs[3], rdrs[1]), vecmul(ex, i))
        ey = vecdiv(a, mag(a))
        ez = veccross(ex, ey)
        d = mag(vecsub(rdrs[2], rdrs[1]))
        j = vecdot(ey, vecsub(rdrs[3], rdrs[1]))
      
        x = (sq(dists[1]) - sq(dists[2]) + sq(d)) / (2*d)
        y = (sq(dists[1]) - sq(dists[3]) + sq(i) + sq(j)) / (2*j) - (i/j) * x;
        if(math.abs(sq(dists[1]) - sq(x) - sq(y)) < 0.0001) then -- Effectively 0
          z = 0
        else
          z = math.sqrt(sq(dists[1]) - sq(x) - sq(y));
        end

        if(z < 0.0001) then z = 0 end
      
        if(z ~= z) then -- if z is NaN
          print("   Could not intuit position of player!")
          break -- out of this player and into the next
        end
      
        a = vecadd(rdrs[1], vecadd(vecmul(ex, x), vecmul(ey, y)))
        p4a = vecadd(a, vecmul(ez, z))
        p4b = vecsub(a, vecmul(ez, z))
        
        if(z == 0) then -- One solution, assign to player
          plyr.x = a.x
          plyr.y = a.y
          plyr.z = a.z
        else
          if(math.abs(mag(vecsub(p4a,rdrs[4])) - dists[4]) < 0.0001) then
            plyr.x = p4a.x
            plyr.y = p4a.y
            plyr.z = p4a.z
          else
            plyr.x = p4b.x
            plyr.y = p4b.y
            plyr.z = p4b.z
          end
        end
        break
      end
    end
  end
  
  plog:write("[" .. computer.uptime() .. "]:\n")
  for name, plyr in pairs(foundPlayers) do
    if(plyr.x ~= nil) then
      plog:write("    Player " .. name .. " was at (x " .. round(plyr.x, 1) .. ", y " .. round(plyr.y, 1) .. ", z " .. round(plyr.z, 1) .. ")\n")
    end
  end

  os.sleep(0.5)
  loopCount = loopCount + 1

  if(loopCount > 5) then
    plog:flush()
    loopCount = 0
  end
end