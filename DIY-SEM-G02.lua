
-- DIY Scanning Electron Microscope author chris.deerleg
-- the full project could you find here https://hackaday.io/project/21831-3d-printed-scanning-electron-microscope
if 1 then -- Magnet class folding the comments below
Magnet = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(Magnet),"index", function(t,f) return %Magnet[f] end) -- class function table
end
function Magnet:new(SimName,MHR,MOR,MH,POS,MAT,MP)  -- create an instance of class Magnet 
-- functions to create a magnet for the B-Simulation 
  local t = {point={},SimName=SimName,MHR=MHR,MOR=MOR,MH=MH,POS=POS,MAT=MAT,MP=MP,label={}}
    settag(t,tag(Magnet))  -- tag the new table to tell it what its class type is
	if SimName==nil then error("empty SimName Magnet:new")end
	t.point[0]={x=0,y=0}
	t.label={x=0,y=0}
	
	mi_setfocus(t.SimName) --choose file for drawing
	 
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
	 t.MHR=MHR
	 t.MOR=MOR
	 t.MH=MH
	 t.POS=POS
	 t.MAT=MAT
	 t.MP=MP
	 
	-- Calculate coners of Magnet
	t.point[0]={x=t.MHR,				y=t.POS+t.MH/2}
	t.point[1]={x=t.MHR,				y=t.POS-t.MH/2}
	t.point[2]={x=t.MHR+t.MOR,	y=t.POS-t.MH/2}
	t.point[3]={x=t.MHR+t.MOR,	y=t.POS+t.MH/2}

	-- draw the coners
	for i=0,getn(t.point) do -- runs N times
		mi_addnode(t.point[i].x,t.point[i].y)
	end

	-- connect the coners
	for i=0,getn(t.point)-1 do -- runs N times
		mi_addsegment(t.point[i].x,t.point[i].y,t.point[1+i].x,t.point[1+i].y)
	end
	mi_addsegment(t.point[0].x,t.point[0].y,t.point[getn(t.point)].x,t.point[getn(t.point)].y)

	-- define Material
	t.label={x=t.MHR+t.MOR/2,y=t.POS}
	mi_addblocklabel(t.label.x,t.label.y)
	mi_selectlabel(t.label.x,t.label.y)
	mi_getmaterial(t.MAT)
	mi_setblockprop(t.MAT,0,t.MOR/10,0,t.MP,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)      
	mi_clearselected()
	mi_zoomnatural()-- zoom out
	mi_refreshview()
	
  return t
end

function Magnet:delMagnet() -- delete the magnet form the simulation enviroment
mi_setfocus(self.SimName)

for i=0,getn(self.point) do -- select all nodes
mi_selectnode(self.point[i].x,self.point[i].y)
end
mi_selectlabel(self.label.x,self.label.y) --select label
mi_deleteselected() --remove selction
end

if 1 then -- Deflector class folding the comments below
Deflector = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(Deflector),"index", function(t,f) return %Deflector[f] end) -- class function table
end
function Deflector:new(SimName,DHR,DOR,DH,POS,MAT,VOLT)  -- create an instance of class Deflector 
  local t = {point={},SimName=SimName,DHR=0,DOR=0,DH=0,POS=0,MAT=0,label={},VOLT=0}
    settag(t,tag(Deflector))  -- tag the new table to tell it what its class type is
	if SimName==nil then error("empty SimName Deflector:new")end
	 -- store parameters in class
	t.point[0]={x=0,y=0}
	t.label={x=0,y=0}
	t.DHR=DHR
	t.DOR=DOR
	t.DH=DH
	t.POS=POS
	t.MAT=MAT
	t.VOLT=VOLT
	
	ei_setfocus(t.SimName) --choose file for drawing
	 
	if nil then --#if_for_folding_the_comments_below

	--           DOR
	--      <------------------->
	--    --[0]................[3]                 y+ (z+)
	--  DHR  :                  :  ^               ^
	--<----->:                  :  :               | 
	--      POS                 :  : DH   (-r)-x <- -> x+ (r+)       
	--       :                  :  :               |   
	--       :                  :  v               v 
	--      [1]................[2]                -y (-z)

	-- Dimensionens of the Deflector
	----------------------------------- 
	--DHR: Deflector Hole Radius 
	--DOR: Deflector Outer Radius
	--DH:  Deflector Height 
	--POS: Center of Deflector drawing
	--MAT: Material of Deflector "Air" "NdFeB 40 MGOe"

	end
	-- Calculate coners of Deflector
	t.point[0]={x=t.DHR,				y=t.POS+t.DH/2}
	t.point[1]={x=t.DHR,				y=t.POS-t.DH/2}
	t.point[2]={x=t.DHR+t.DOR,	y=t.POS-t.DH/2}
	t.point[3]={x=t.DHR+t.DOR,	y=t.POS+t.DH/2}

	-- draw the coners
	for i=0,getn(t.point) do -- runs N times
		ei_addnode(t.point[i].x,t.point[i].y)
	end

	--preparation  of the Voltage for the Segments
	ConductorName="Volt"..random(999)..":"..t.VOLT
	ei_addconductorprop(ConductorName,t.VOLT,0,1) --unused property to zero. Last parameter is 0 for charge and 1 for voltages
	ei_setsegmentprop("None", 0, 1, 0, 0,ConductorName)

	-- connect the coners and set the voltage of the segments
	for i=0,getn(t.point)-1 do 
		ei_addsegment(t.point[i].x,t.point[i].y,t.point[1+i].x,t.point[1+i].y)
		xmid=(t.point[i].x+t.point[1+i].x)/2 --calculate the middel between the two point
		ymid=(t.point[i].y+t.point[1+i].y)/2
		ei_selectsegment(xmid,ymid)
		ei_setsegmentprop("None",0,1,0,0,ConductorName)
		ei_clearselected()
	end
	ei_addsegment	(t.point[0].x,t.point[0].y,t.point[getn(t.point)].x,t.point[getn(t.point)].y)
	xmid=(t.point[0].x+t.point[getn(t.point)].x)/2
	ymid=(t.point[0].y+t.point[getn(t.point)].y)/2
	ei_selectsegment(xmid,ymid)
	ei_setsegmentprop("None",0,1,0,0,ConductorName)
	ei_clearselected()
		
	-- define Material
	t.label={x=t.DHR+t.DOR/2,y=t.POS}
	ei_addblocklabel(t.label.x,t.label.y)
	ei_selectlabel(t.label.x,t.label.y)
	ei_getmaterial(t.MAT)
	ei_setblockprop(t.MAT,0,t.DOR/10,4)--("blockname", automesh, meshsize,group)      
	ei_clearselected()
	ei_zoomnatural()-- zoom out
	ei_refreshview()
	
  return t
end

function Deflector:delDeflector()

	
	ei_setfocus(self.SimName)

	for i=0,getn(self.point) do -- select all nodes
	ei_selectnode(self.point[i].x,self.point[i].y)

	end
	ei_selectlabel(self.label.x,self.label.y) --select label
	ei_deleteselected() --remove selction

end

function Magnet:drawPole (SimName, PolType) -- draw the contour of the pole
if SimName==nil then error("empty SimName Magnet:drawPole")end 
mi_setfocus(self.SimName)
end
 
if 1 then -- SimBox class folding the comments below
SimBox = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(SimBox),"index", function(t,f) return %SimBox[f] end) -- class function table
end

function SimBox:new(POS,MAT,TYPE,DIS,ENV)  -- create an instance of class SimBox 
--ENV is either "El" for a electical simulaiton or Ma for a magnetic simulaiton
--Type is 'planar' or 'axi'
-- functions to create a Simulation Box for a magnetic simulaiton
if POS==nil or MAT==nil or TYPE==nil or ENV==nil or DIS==nil then error("empty parameter SimBox:new")end
  local t = {point={},SimName="empty",POS=0,MAT="",label={},ENV=""}
    settag(t,tag(SimBox))  -- tag the new table to tell it what its class type is
	t.point[0]={x=0,y=0}
	t.label={x=0,y=0}
	t.MAT=MAT
	t.POS=POS
	t.ENV=ENV

	if TYPE=="axi" then -- calculate the coners	 
  
--    [0]................[3]  ^             y+ (z+)
--     :<------DIS------->:   DIS           ^
--     :                  :   v             | 
--    POS                 :        (-r)-x <- -> x+ (r+)       
--     :                  :                 |   
--     :                  :    	            v 
--    [1]................[2]                -y (-z)	

	t.point[0]={x=t.POS, 		y=t.POS+DIS}
	t.point[1]={x=t.POS, 		y=t.POS-DIS}
	t.point[2]={x=t.POS+DIS,	y=t.POS-DIS}
	t.point[3]={x=t.POS+DIS,	y=t.POS+DIS}

	end
	if TYPE=="planar" then -- calculate the coners	 
  
--    [0]................[3]  ^             y+ (z+)
--     :        <---DIS-->:  DIS            ^
--     :                  :   v             | 
--     :       POS        :        (-r)-x <- -> x+ (r+)       
--     :                  :                 |   
--     :                  :    	            v 
--    [1]................[2]                -y (-z)

	
	t.point[0]={x=t.POS-DIS,y=t.POS+DIS}
	t.point[1]={x=t.POS-DIS,y=t.POS-DIS}
	t.point[2]={x=t.POS+DIS,y=t.POS-DIS}
	t.point[3]={x=t.POS+DIS,y=t.POS+DIS}
	
	end
	
	if ENV=="El" then --draw simulation box for electical simulaiton
		t.SimName = ElProbDef(TYPE) --set the boundaries of the electical simulation	
		
		for i=0,getn(t.point) do -- -- draw the coners 
			ei_addnode(t.point[i].x,t.point[i].y)
		end
		for i=0,getn(t.point)-1 do -- connect the coners
			ei_addsegment(t.point[i].x,t.point[i].y,t.point[1+i].x,t.point[1+i].y)
		end
		ei_addsegment(t.point[0].x,t.point[0].y,t.point[getn(t.point)].x,t.point[getn(t.point)].y) --connect last and first point
		
		t.label={x=DIS*0.9,y=DIS*0.9} --postion of simulaiton label
		ei_addblocklabel(t.label.x,t.label.y)
		ei_selectlabel(t.label.x,t.label.y)
		ei_getmaterial(MAT)
		ei_setblockprop(MAT,0,DIS/10,0,0,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)      
		ei_clearselected()
end
	
	if ENV=="Ma" then --draw simulaiton box for magnetic simulaiton
		t.SimName = MaProbDef(TYPE) --set the boundaries of the magnetic simulation
		for i=0,getn(t.point) do -- -- draw the coners 
			mi_addnode(t.point[i].x,t.point[i].y)
		end
		for i=0,getn(t.point)-1 do -- connect the coners
			mi_addsegment(t.point[i].x,t.point[i].y,t.point[1+i].x,t.point[1+i].y)
		end
		mi_addsegment(t.point[0].x,t.point[0].y,t.point[getn(t.point)].x,t.point[getn(t.point)].y) --connect last and first point

		t.label={x=DIS*0.9,y=DIS*0.9} --postion of simulaiton label t.label={x=t.MHR+t.MOR/2,y=t.POS}
		mi_addblocklabel(t.label.x,t.label.y)	
		mi_selectlabel(t.label.x,t.label.y)
		mi_getmaterial(t.MAT)
		mi_setblockprop(t.MAT,0,DIS/10,0,0,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)      
		mi_clearselected()
		
	end
	
  return t
end

function SimBox:solve()

if self.ENV=="El" then --solve for electical simulaiton
	ei_setfocus(self.SimName) --choose file for drawing
	ei_analyze()-- start analyzes          
	ei_loadsolution() --load solution
	eo_showdensityplot(1,0,0,2)-- create desityplot legend 0:1 ,gscale 0:1 ,upper_B,lower_B,type
	eo_showvectorplot(2,2) --plot veter arrows
	eo_zoomnatural()-- zoom out
	eo_refreshview()
	
end

if self.ENV=="Ma" then --solve for magnetical simulaiton
	mi_setfocus(self.SimName) --choose file for drawing
	mi_analyze()-- start analyzes          
	mi_loadsolution() --load solution
	mo_showdensityplot(1,0,0,2,"bmag")-- create desityplot legend 0:1 ,gscale 0:1 ,upper_B,lower_B,type
	mo_showvectorplot(1,1) --plot veter arrows
	mo_zoomnatural()-- zoom out
	mo_refreshview()
end 

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
Name="MaProbDef_"..Type.."_"..random(9999)..".fem"-- creates a uniqu name
Dir="./ProbDef/"		-- Directory for the files
mi_saveas(Dir..Name)

return Name
end

function ElProbDef(Type) -- Creating a electrostatics enviroment for the simulation 
-- Problem Type 'planar' or 'axi'
newdocument(1)
Unit='millimeters'    	--or 'centimeters' 'meters' 'inches''mils' 'micrometers'
Precision=1.e-8     	--Accuracy of solution
Depth=1            		--Axial length
minAngle=10       		--Minimum angle for solving
ei_probdef(Unit,Type,Precision,Depth,minAngle)
Name="ElProbDef_"..Type.."_"..random(9999)..".fee"-- creates a uniqu name
Dir="./ProbDef/"		-- Directory for the files
ei_saveas(Dir..Name)
return Name
end

if nil then -- folding the comments below
-- functions to crate a deflector for the E-Simulation

--drawDeflector(simlation name
--delDeflector
--ei setfocus

-- function to support the Simulation

-- collistions detection checks if a particle hit an static object 
-- GoToLine if a particle hit this line then some parameter of the particle are change immidetly 
--for manipulate the particles like mirror or move a particle to a other simulation type
--drawGoToLine 
--{x1,y1,x2,y2,


-- functions for create a particle like a electron

--particle 
--{charge,Bfield{x,y},setp,step-unit,Pos{x,y},velocit{x,y}, event}

-- functions to the simulation enviroment

-- Simumation settings creates a simulstion background

--		*magnetic simulstion
-- 		*
--createSimBox simusltion box
--createProbdef(
--solveProb(



---Simumation----

--createProblemdef(Eletrostatic,Planar,"meine E-Sim")
--createProblemdef(Magnetic,Axisymmetic,"meine B-Sim")

--draw the solid objects
--MA1.drawMagnet(
--MA1.drawPol(

--MA2.drawMagnet(
--MA2.drawPol(

--DE1.drawDeflector(

-- draw all the GoToLines
--L1.drawGoToLine(
--L2.drawGoToLine(
--L3.drawGoToLine(
--L4.drawGoToLine(

-- Calcules teh B-Sim
--solveProblem()

--ceate the particle
--PA[0]=Particle(.......) 

-- don't calculate the particle if stopt alreday some where
--if PA[0].event[getn]!="end" 
--then 

-- do a calcuations of the particle
--if PA[0] Simulationstyp = M-Sim then
--PA.[0].Bfield = mo_getb(PA[0].POS[x],PA.[0].POS[y])
--Calculate someting
--end


--stops further calcuations as the particle hit an solid object
--if collistions(PA[0],MA1) or collistions(PA[0],MA2) or collistions(PA[0],DE1) 
--then
--PA[0].status="end"
--end


-- checks if the paricel hit a GoToLine and set the newparamter for the particle
--collistions(PA[0],L1)
--PA[0].=.....
--collistions(PA[0],L2)
--collistions(PA[0],L3)
--collistions(PA[0],L4)
--end

--next particle
end

-- Play ground
if 1 then --Magnetic test sims

	sim1=SimBox:new(0,"Air","axi",40,"Ma")--POS,MAT,TYPE,DIS,ENV
	m={}
	
	for i=0 , 3 do
		m[i]=Magnet:new(sim1.SimName,1.5,4,4,i*10,"NdFeB 52 MGOe",90)
	end
	
		m[2]:delMagnet()

	sim2=SimBox:new(0,"Air","planar",40,"Ma")--POS,MAT,TYPE,DIS,ENV
	m2={}
	
	for i=0 , 3 do
		m2[i]=Magnet:new(sim2.SimName,1.5,4,4,i*10,"NdFeB 52 MGOe",90)
	end

	sim1:solve()
	sim2:solve()

end

if 1 then --Electical test sims
	sim3=SimBox:new(0,"Air","axi",7,"El")
	d={}
	
	for i=0 , 1 do
		d=Deflector:new(sim3.SimName,1,3,0.5,i*5,"Air",i*10)--SimName,DHR,DOR,DH,POS,MAT,Voltage
	end

	sim4=SimBox:new(0,"Air","planar",16,"El")
	d1={}
	
	for i=0 , 3 do
	
	d1[i]=Deflector:new(sim4.SimName,1,3,0.5,i*5,"Air",i*100)--SimName,DHR,DOR,DH,POS,MAT
	end
	
	d1[2]:delDeflector()

	sim3:solve()
	sim4:solve()
end




