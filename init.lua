
math = require("math")
 
m = {}
 
function m.mat4x4(identity)
  local n = 0
  if identity or false then
    n = 1
  end
  local temp = {
  {n,0,0,0},
  {0,n,0,0},
  {0,0,n,0},
  {0,0,0,n}}
  return temp
end
 
function m.vec4(x, y, z, w)
  x = x or 0
  y = y or 0
  z = z or 0
  w = w or 1
  local temp = {
  {x},
  {y},
  {z},
  {w}}
  return temp
end
 
function m.mul(m1, m2)
  local r1, r2 = #m1, #m2
  local c1, c2 = #m1[1], #m2[1]
 
  local temp = m.mat4x4()
  for i=1,r1 do
    for j=1,c2 do
      for k=1,c1 do
        temp[i][j] = temp[i][j] + m1[i][k] * m2[k][j]
      end
    end
  end
  if c2 == 4 then
    return temp
  else
    return m.vec4(temp[1][1], temp[2][1], temp[3][1], temp[4][1])
  end
end
 
function m.translate(x, y, z)
  x = x or 0
  y = y or 0
  z = z or 0
 
  local temp = m.mat4x4(true)
  temp[1][4] = x
  temp[2][4] = y
  temp[3][4] = z
 
  return temp
end
 
function m.rotationX(angle)
  local temp = m.mat4x4(true)
  angle = math.rad(angle)
 
  temp[2][2] = math.cos(angle)
  temp[3][2] = -math.sin(angle)
  temp[2][3] = math.sin(angle)
  temp[3][3] = math.cos(angle)
 
  return temp
end
 
function m.rotationY(angle)
  local temp = m.mat4x4(true)
  angle = math.rad(angle)
 
  temp[1][1] = math.cos(angle)
  temp[3][1] = math.sin(angle)
  temp[1][3] = -math.sin(angle)
  temp[3][3] = math.cos(angle)
 
  return temp
end
 
function m.rotationZ(angle)
  local temp = m.mat4x4(true)
  angle = math.rad(angle)
 
  temp[1][1] = math.cos(angle)
  temp[2][1] = -math.sin(angle)
  temp[1][2] = math.sin(angle)
  temp[2][2] = math.cos(angle)
 
  return temp
end
 
function m.rotateXYZ(x, y, z)
  local rX = m.rotationX(x)
  local rY = m.rotationY(y)
  local rZ = m.rotationZ(z)
 
  local f = m.mul(rZ, rY)
  return m.mul(f, rX)
end
 
function m.rotateYXZ(x, y, z)
  local rX = m.rotationX(x)
  local rY = m.rotationY(y)
  local rZ = m.rotationZ(z)
 
  local f = m.mul(rZ, rX)
  return m.mul(f, rY)
end
 
function m.rotateYZX(x, y, z)
  local rX = m.rotationX(x)
  local rY = m.rotationY(y)
  local rZ = m.rotationZ(z)
 
  local f = m.mul(rX, rZ)
  return m.mul(f, rY)
end
 
function m.rotateZXY(x, y, z)
  local rX = m.rotationX(x)
  local rY = m.rotationY(y)
  local rZ = m.rotationZ(z)
 
  local f = m.mul(rY, rX)
  return m.mul(f, rZ)
end
 
function m.rotateZYX(x, y, z)
  local rX = m.rotationX(x)
  local rY = m.rotationY(y)
  local rZ = m.rotationZ(z)
 
  local f = m.mul(rX, rY)
  return m.mul(f, rZ)
end
 
function m.scale(x, y, z)
  local temp = m.mat4x4(true)
  temp[1][1] = x
  temp[2][2] = y
  temp[3][3] = z
 
  return temp
end
 
function m.perspective(sizeX, sizeY, near, far, FOV)
  aspect = sizeX / sizeY
 
  top = near * math.tan(math.rad(FOV)/2)
  bottom = -top
  right = top * aspect
  left = -right
 
  local temp = m.mat4x4()
 
  temp[1] = {(2*near)/(right-left), 0, (right+left)/(right-left), 0}
  temp[2] = {0, (2*near)/(top-bottom), (top+bottom)/(top-bottom), 0}
  temp[3] = {0, 0, -(far+near)/(far-near), -(2*far*near)/(far-near)}
  temp[4] = {0, 0, -1, 0}
 
  return temp
end
 
function m.divW(vec)
  local temp = m.vec4()
  temp[1][1] = vec[1][1] / vec[4][1]
  temp[2][1] = vec[2][1] / vec[4][1]
  temp[3][1] = vec[3][1] / vec[4][1]
  return temp
end
 
function m.cross4(x1, y1, x2, y2, x3, y3, x4, y4)
  return (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)
end

function m.cross2(v1, v2)
  local x = v1[2] * v2[3] - v1[3] * v2[2]
  local y = v1[3] * v2[1] - v1[1] * v2[3]
  local z = v1[1] * v2[2] - v1[2] * v2[1]
  return {x, y, z}
end

function m.sub(v1, v2)
  local result = {}
  local n = math.min(#v1, #v2) -- Find the minimum number of components in both vectors

  for i = 1, n do
    result[i] = {v1[i][1] - v2[i][1], v1[i][2] - v2[i][2], v1[i][3] - v2[i][3]}
  end

  return result
end

function m.normalize(v)
  local magnitude = 0
  for i = 1, #v do
    magnitude = magnitude + v[i] * v[i]
  end

  magnitude = math.sqrt(magnitude)

  local result = {}
  for i = 1, #v do
    result[i] = v[i] / magnitude
  end

  return result
end

function m.dot(v1, v2)

  local dotProduct = 0
  for i = 1, #v1 do
    dotProduct = dotProduct + v1[i][1] * v2[i][1]
  end

  return dotProduct
end

function m.length(v)
  local magnitudeSquared = 0
  for i = 1, #v do
    magnitudeSquared = magnitudeSquared + v[i][1] * v[i][1]
  end
  return math.sqrt(magnitudeSquared)
end

local gpu = (require("component")).gpu
local keyboard = require("keyboard")
local event = require("event")
 
local w, h = gpu.getResolution()
 
local p = m.perspective(w, h, 0.05, 100, 60)
 
local l = m.translate(0, 0, 10)
 
local r = m.rotateYXZ(0, 0, 0)
 
local c = m.mat4x4(true)

local t = {...}
 
 
speed = 5
running = true
changed = true

--"_,-=+::;cba!01!123456789$W#@" inverted 
--"@#W$9876543210?!abc;:+=-,._" correct

local charString = "@#W$9876543210?!abc;:+=-,._"

local total_shades = 17 --27
local range = 2.5

local points = {}
 points[1] = m.vec4(-range,-range,-range)
 points[2] = m.vec4(range,-range,-range)
 points[3] = m.vec4(range,-range,range)
 points[4] = m.vec4(-range,-range,range)
 points[5] = m.vec4(-range,range,-range)
 points[6] = m.vec4(range,range,-range)
 points[7] = m.vec4(range,range,range)
 points[8] = m.vec4(-range,range,range)


local edges = {
  {1, 2}, {2, 3}, {3, 4}, {4, 1},
  {5, 6}, {6, 7}, {7, 8}, {8, 5},
  {1, 5}, {2, 6}, {3, 7}, {4, 8},
}

local faces = {
  {1, 2, 3, 4}, -- Bottom face
  {4, 3, 7, 8}, -- Top face
  {2, 6, 7, 3}, -- Front face
  {8, 7, 6, 5}, -- Right face
  {4, 8, 5, 1}, -- Back face
  {5, 6, 2, 1}, -- Left face
}

local color_palette_test = {
  0xFFFFFF,
  0xF0F0F0, 
  0xE1E1E1, 
  0xD2D2D2, 
  0xC3C3C3, 
  0xB4B4B4, 
  0xA5A5A5, 
  0x969696, 
  0x878787, 
  0x787878, 
  0x696969, 
  0x5A5A5A, 
  0x4B4B4B, 
  0x3C3C3C, 
  0x2D2D2D, 
  0x1E1E1E, 
  0x0F0F0F
}

local lightSource = {0, 0, -range*4}

local term = require("term")

term.clear()
 
local min_shading = math.huge
local max_shading = -math.huge

function drawPixel(x, y, shading)
  local sensitivity = 10 
  shading = shading * sensitivity

  -- Update the minimum and maximum shading values
  min_shading = math.min(min_shading, shading)
  max_shading = math.max(max_shading, shading)

  local shading_range = max_shading - min_shading

  local shading_ratio = (shading - min_shading) / shading_range

  local shade_level = (total_shades - 1) * shading_ratio

  if shade_level ~= shade_level then
      shade_level = 0 
  end

  local lower_shade = math.floor(shade_level)
  local upper_shade = math.min(total_shades - 1, lower_shade + 1)

  local weight = shade_level - lower_shade

  local final_palette_index = lower_shade * (1 - weight) + upper_shade * weight
  local printText = charString:sub(math.floor(final_palette_index + 1), math.floor(final_palette_index + 1))
  --gpu.set(1,1, "min_shading " .. min_shading)
  --gpu.set(1,2, "max_shading " .. max_shading)
  --gpu.set(1,3, "final_palette_index " .. final_palette_index)
  --gpu.set(1,4, "shading_number " .. shading)
  if color_palette_test[math.floor(final_palette_index)] == nil then
    final_palette_index = 1
  end
  --print(final_palette_index)
  --print(color_palette_test[math.floor(final_palette_index)])
  gpu.setForeground(color_palette_test[math.floor(final_palette_index)])
  gpu.set(x, y, printText)
end


function calculateShading(normal, lightVector)
  local dotProduct = m.dot(normal, lightVector)
  local normalLength = m.length(normal)
  local lightVectorLength = m.length(lightVector)
  local angle = math.acos(dotProduct / (normalLength * lightVectorLength))

  local shading = math.cos(angle) 
  return shading * 100
end

function drawQuadrilateral(x1, y1, x2, y2, x3, y3, x4, y4, shading)
  local minX = math.min(x1, x2, x3, x4)
  local maxX = math.max(x1, x2, x3, x4)
  local minY = math.min(y1, y2, y3, y4)
  local maxY = math.max(y1, y2, y3, y4)

  for y = minY, maxY do
    local x_left = math.huge
    local x_right = -math.huge

    for x = minX, maxX do
      if isPointInQuadrilateral(x, y, x1, y1, x2, y2, x3, y3, x4, y4) then
        x_left = math.min(x_left, x)
        x_right = math.max(x_right, x)
      end
    end

    for x = x_left, x_right do
      drawPixel(x, y, shading)
    end
  end
end

function isPointInQuadrilateral(x, y, x1, y1, x2, y2, x3, y3, x4, y4)
  local function sign(p1x, p1y, p2x, p2y, p3x, p3y)
      return (p1x - p3x) * (p2y - p3y) - (p2x - p3x) * (p1y - p3y)
  end

  local b1 = sign(x, y, x1, y1, x2, y2) < 0.0
  local b2 = sign(x, y, x2, y2, x3, y3) < 0.0
  local b3 = sign(x, y, x3, y3, x4, y4) < 0.0
  local b4 = sign(x, y, x4, y4, x1, y1) < 0.0

  return b1 == b2 and b2 == b3 and b3 == b4
end

local function connectPoints(i1, i2, i3, i4)

  local point1 = m.mul(p, l)
  point1 = m.mul(point1, r)
  point1 = m.mul(point1, points[i1])
  point1 = m.divW(point1)

  local point2 = m.mul(p, l)
  point2 = m.mul(point2, r)
  point2 = m.mul(point2, points[i2])
  point2 = m.divW(point2)

  local point3 = m.mul(p, l)
  point3 = m.mul(point3, r)
  point3 = m.mul(point3, points[i3])
  point3 = m.divW(point3)

  local point4 = m.mul(p, l)
  point4 = m.mul(point4, r)
  point4 = m.mul(point4, points[i4])
  point4 = m.divW(point4)

  local x1, y1, z1 = point1[1][1], point1[2][1], 1 - point1[3][1]
  local x2, y2, z2 = point2[1][1], point2[2][1], 1 - point2[3][1]
  local x3, y3, z3 = point3[1][1], point3[2][1], 1 - point3[3][1]
  local x4, y4, z4 = point4[1][1], point4[2][1], 1 - point4[3][1]

  if m.cross4(x1, y1, x2, y2, x3, y3, x4, y4) > 0 then
      return
  end

  if (x1 >= -1) and (x1 <= 1) and (y1 >= -1) and (y1 <= 1) and (z1 <= 0) and
     (x2 >= -1) and (x2 <= 1) and (y2 >= -1) and (y2 <= 1) and (z2 <= 0) and
     (x3 >= -1) and (x3 <= 1) and (y3 >= -1) and (y3 <= 1) and (z3 <= 0) and
     (x4 >= -1) and (x4 <= 1) and (y4 >= -1) and (y4 <= 1) and (z4 <= 0) then
      x1 = (x1 + 1) / 2 * w
      y1 = (y1 + 1) / 2 * h
      x2 = (x2 + 1) / 2 * w
      y2 = (y2 + 1) / 2 * h
      x3 = (x3 + 1) / 2 * w
      y3 = (y3 + 1) / 2 * h
      x4 = (x4 + 1) / 2 * w
      y4 = (y4 + 1) / 2 * h

      local faceCenterX = (x1 + x2 + x3 + x4) / 4
      local faceCenterY = (y1 + y2 + y3 + y4) / 4
      local faceCenterZ = (z1 + z2 + z3 + z4) / 4

      local edge1 = {x2 - x1, y2 - y1, z2 - z1}
      local edge2 = {x3 - x2, y3 - y2, z3 - z2}
      edge1 = m.normalize(edge1)
      edge2 = m.normalize(edge2)

      local faceNormal = m.cross2(edge1, edge2)
      faceNormal = m.normalize(faceNormal)
      
      local lightVector = {lightSource[1] - faceCenterX, lightSource[2] - faceCenterY, lightSource[3] - faceCenterZ}
      lightVector = m.normalize(lightVector)

      local faceNormal = m.vec4(faceNormal[1], faceNormal[2], faceNormal[3])
      local lightVector = m.vec4(lightVector[1], lightVector[2], lightVector[3])

      local shading = calculateShading(faceNormal, lightVector)


      drawQuadrilateral(x1, y1, x2, y2, x3, y3, x4, y4, shading)

  end
end

while running do

  local buffer = gpu.allocateBuffer(w, h)
  gpu.setActiveBuffer(buffer)

  for _, face in ipairs(faces) do
    local vertex1, vertex2, vertex3, vertex4 = face[1], face[2], face[3], face[4]
    connectPoints(vertex1, vertex2, vertex3, vertex4)
  end

  gpu.bitblt(0,1,1,w,h,buf)
  gpu.setActiveBuffer(0)
  gpu.freeBuffer(buffer)
  event.pull(0)

  r = m.mul(r, m.rotateYXZ(speed, speed, 0))

  running = not keyboard.isKeyDown("c")
 

end

