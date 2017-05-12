-- DIY Scanning Electron Microscope author chris.deerleg --
-- https://hackaday.io/project/21831-3d-printed-scanning-electron-microscope--

Particle = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(Particle),"index", function(t,f) return %Particle[f] end) -- class function table
function Particle:new()  -- create an instance of class Particle 
  local t = {P={}}
    settag(t,tag(Particle))  -- tag the new table to tell it what its class type is
  return t
end

function Particle:fill(N)
    for i=0,N do -- runs N times
      self.P[i] = {x=i,y=i*2,power=i*3}     -- add to each particle the parametes x , y , power
    end
end

function Particle:out()
print"Array"
for i=0,getn(self.P) do --getn() returns the length of the array
print(self.P[i].x)		-- print the content of x from particle i
print(self.P[i].y)		-- print the content of x from particle i
print(self.P[i].power)	-- print the content of x from particle i
end
print "ends"
end

-- here starts the actual the program

p = Particle:new()  -- creates a object p
p:fill(2)			-- fill particle 0 particle 1 particle 2
p:out()				-- pint the content


