
-- DIY Scanning Electron Microscope author chris.deerleg
-- the full project could you find here https://hackaday.io/project/21831-3d-printed-scanning-electron-microscope


-- functions to create a magnet for the B-Simulation 
if 1 then -- folding the comments below
Magnet = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(Magnet),"index", function(t,f) return %Magnet[f] end) -- class function table
end

function Magnet:new(SimName)  -- create an instance of class Magnet 
  local t = {point={},SimName=SimName,MHR=0,MOR=0,MH=0,POS=0,MAT=0,MP=0}
    settag(t,tag(Magnet))  -- tag the new table to tell it what its class type is
	if SimName==nil then error("empty SimName Magnet:new")end
	t.point[0]={x=0,y=0}
  return t
end

function Magnet:drawMagnet(MHR,MOR,MH,POS,MAT,MP) -- draw the contour of a magnet

mi_setfocus(self.SimName) --choose file for drawing
 
if nil then --#if_for_folding_the_comments_below

--           MOR
--<------------------------->
--    --[0]................[3]                 y+ (z+)
--  MHR  :                  :  ^               ^
--<----->:                  :  :               | 
--      POS                 :  : MH   (-r)-x <- -> x+ (r+)       
--       :                  :  :               |   
--       :                  :  v               v 
--      [1]................[2]                -y (-z)

-- Dimensionens of the Magnet
----------------------------------- 
--MHR: Magnet Hole Radius 
--MOR: Magnet Outer Radius
--MH:  Magnet Height 
--POS: Center of magnet drawing
--MAT: Material of Magnet "Air" "NdFeB 40 MGOe"
--MP: Magnet polarisation
end

 -- store parameters in class
 self.MHR=MHR
 self.MOR=MOR
 self.MH=MH
 self.POS=POS
 self.MAT=MAT
 self.MP=MP
 
-- Calculate coners of Magnet
self.point[0]={x=self.MHR,				y=self.POS+self.MH/2}
self.point[1]={x=self.MHR,				y=self.POS-self.MH/2}
self.point[2]={x=self.MHR+self.MOR,	y=self.POS-self.MH/2}
self.point[3]={x=self.MHR+self.MOR,	y=self.POS+self.MH/2}

-- draw the coners
for i=0,getn(self.point) do -- runs N times
	mi_addnode(self.point[i].x,self.point[i].y)
end

-- connect the coners
for i=0,getn(self.point)-1 do -- runs N times
	mi_addsegment(self.point[i].x,self.point[i].y,self.point[1+i].x,self.point[1+i].y)
end
mi_addsegment(self.point[0].x,self.point[0].y,self.point[getn(self.point)].x,self.point[getn(self.point)].y)

-- define Material
mi_addblocklabel(self.MHR+self.MOR/2,self.POS)
mi_selectlabel(self.MHR+self.MOR/2,self.POS)
mi_getmaterial(self.MAT)
mi_setblockprop(self.MAT,0,self.MOR/10,0,self.MP,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)      
mi_clearselected()
end

function Magnet:drawPole (SimName, PolType) -- draw the contour of the pole
if SimName==nil then error("empty SimName Magnet:drawPole")end 
mi_setfocus(SimName)
end

function Magnet:delMagnet() -- delete the magnet 
mi_setfocus(SimName)
end

function MaProbDef(Type) -- Creating a magnetostatics enviroment for the simulation
-- Problem Type 'planar' or 'axi'
newdocument(0) 
Frequency=0;            --Frequency in Hz
Unit='millimeters';    	--or 'centimeters' 'meters' 'inches''mils' 'micrometers'
Precision=1.e-8;     	--Accuracy of solution
Depth=0;           		--Axial length
minAngle=10;       		--Minimum angle for solving
acSolver=0;       		--AC solver method 0=Successive approximation 1=Newton 
mi_probdef(Frequency, Unit, Type,Precision ,Depth, minAngle,acSolver);
Name="MaProbDef_"..Type.."_"..random(9999)..".fee"-- creates a uniqu name
Dir="./ProbDef/"		-- Directory for the files
mi_saveas(Dir..Name)

return Name
end

function ElProbDef(Type) -- Creating a electrostatics enviroment for the simulation 
-- Problem Type 'planar' or 'axi'
newdocument(1)
Unit='millimeters'    	--or 'centimeters' 'meters' 'inches''mils' 'micrometers'
Precision=1.e-8     	--Accuracy of solution
Depth=0            		--Axial length
minAngle=10       		--Minimum angle for solving
ei_probdef(Unit,Type,Precision,Depth,minAngle)
Name="ElProbDef_"..Type.."_"..random(9999)..".fee"-- creates a uniqu name
Dir="./ProbDef/"		-- Directory for the files
ei_saveas(Dir..Name)
return Name
end


-- Play ground
Mfile1=MaProbDef("axi") --creating a simulation enviromentes

if 1 then -- disable the code below "nil" or to enable "1" 
Mfile2=MaProbDef("planar")
print("Files:"..Mfile1..Mfile2..Efile1..Mfile2) 
b=Magnet:new(Mfile2)
b:drawMagnet(1.5,4,4,0,"NdFeB 52 MGOe",90)
end


m=Magnet:new(Mfile1)
m:drawMagnet(1.5,4,4,0,"NdFeB 52 MGOe",90)


