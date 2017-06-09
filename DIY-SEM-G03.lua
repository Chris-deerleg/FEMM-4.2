
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
	mi_setblockprop(t.MAT,0,0,0,t.MP,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)     
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

function Magnet:drawPole (SimName, PolType) -- draw the contour of the pole
if SimName==nil then error("empty SimName Magnet:drawPole")end 
mi_setfocus(self.SimName)
end


if 1 then -- Deflector class folding the comments below
Deflector = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(Deflector),"index", function(t,f) return %Deflector[f] end) -- class function table
end
function Deflector:new(Sim,DHR,DOR,DH,POS,MAT,VOLT)  -- create an instance of class Deflector 
  local t = {point={},SimName=Sim.SimName,DHR=0,DOR=0,DH=0,POS=0,MAT=0,label={},VOLT=0,Solidness="solid"}
    settag(t,tag(Deflector))  -- tag the new table to tell it what its class type is
	
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
	
	
	ei_setblockprop(t.MAT,0,0,4)--("blockname", automesh, meshsize,group)
	
	      
	ei_clearselected()
	ei_zoomnatural()-- zoom out
	ei_refreshview()
	
  return t
end



if 1 then -- Particle class folding the comments below
Particle = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(Particle),"index", function(t,f) return %Particle[f] end) -- class function table
end

function Particle:new(Sim,X,Y,StepSize)  -- create an instance of class Particle 
-- functions to create a particle to move through fields
  local t = {point={},Q=-1.6021766208e-19,M=9.10938356e-31,SimName=Sim.SimName,collision=0}--E[V/m]; x[mm]; s= stepsize 1mm;q=charge of electron; m=mass of a electron 
    settag(t,tag(Particle))  -- tag the new table to tell it what its class type is
	t.point[0]={Bx=0,By=0,Ex=0,Ey=0,x=X,y=Y,Vx=0,Vy=0,Ttot=0,S=StepSize}
	
	return t	
end	

function Particle:move(objects)--calculate the next postion of a particle
	if self.collision==0 then 
	--http://www.leifiphysik.de/elektrizitaetslehre/bewegte-ladungen-feldern
	--https://www.youtube.com/watch?v=Nbuw_zWnlyA

		SolvName,NA=gsub (self.SimName, ".fee", ".res")--replace the end of filenam .fee with .res
		eo_setfocus(SolvName)
		N=getn(self.point) --get the numbers of point
		self.point[N+1]={Bx=0,By=0,Ex=0,Ey=0,x=0,y=0,Vx=0,Vy=0,Ttot=0,S=0} --create a new point
		self.point[N+1].S=self.point[N].S -- copy values 
		s=self.point[N].S
		
		V,Dx,Dy,Ex,Ey,zx,zy,pnrg=eo_getpointvalues(self.point[N].x,self.point[N].y) -- get the result of the simulation at a point
		if Ex == nil then Ex=0 end --catch the error when the no field result lead to nil error
		if Ey == nil then Ey=0 end
		
		vx=self.point[N].Vx
		vy=self.point[N].Vy
		
		absV =sqrt(vx^2+vy^2)
		
		ax = Ex * self.Q / self.M  --Acceleration by the field
		ay = Ey * self.Q / self.M
		
		absA=sqrt(ax^2+ay^2)
		
		if absA ~= 0 then ts=(sqrt(2*s*absA+absV^2)-absV)/absA end --normal case
		if absA == 0 then ts=s/absV end	-- catch div by zero
		if absA == 0 and absV ==0 then ts=10e10 end -- catch div by zero
			
		vxs=ax*ts+vx --speed after section
		sx = ax/2*ts^2+vx*ts --additional position after section
		vys=ay*ts+vy --speed after section
		sy=ay/2*ts^2+vy*ts --additional position after section

		
		self.point[N+1].Ex=Ex
		self.point[N+1].Ey=Ey
		
		self.point[N+1].Vx=vxs
		self.point[N+1].Vy=vys
		self.point[N+1].S=s
		self.point[N+1].x=self.point[N].x+sx*1000 -- new position of particle -- the result of the calculation is in m the sim calculate in mm therefor a correction of 1000 is needed
		
		self.point[N+1].y=self.point[N].y+sy*1000
		self.point[N+1].Ttot= self.point[N].Ttot+ts --total time
		
		for i=0 , getn(objects) do --run through all objects
		
			--check for segment from point 0 to the last point 
			cx,cy = intersection(self.point[N].x,self.point[N].y,self.point[N+1].x,self.point[N+1].y,objects[i].point[0].x,objects[i].point[0].y,objects[i].point[getn(objects[i].point)].x,objects[i].point[getn(objects[i].point)].y) --check for collision intersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2)
			
			if cx~=nil or cy~= nil then -- collision detected once intersection point returned 
				self.collision = -1
				break	
			end
				
			for g=0 , getn(objects[i].point)-1 do --run through all point of a objects
			
				--check for collision 
				cx,cy = intersection(self.point[N].x,self.point[N].y,self.point[N+1].x,self.point[N+1].y,objects[i].point[g].x,objects[i].point[g].y,objects[i].point[g+1].x,objects[i].point[g+1].y) --check for collision intersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2)
		
				if cx~=nil or cy~= nil then -- collision detected once intersection point returned
					self.collision = -1
					break
				end				
			end
		end							
end	
	return getn(self.point)
end

function intersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2) --check of a intersection between two lines
	x=nil
	y=nil
	if xa2 ~= xa1 and xb2 ~=xb1 then 
	
		ma=(ya2-ya1)/(xa2-xa1) -- calculate the values for the linear equation y=mx+b
		ba=ya1-ma*xa1
		
		mb=(yb2-yb1)/(xb2-xb1)
		bb=yb1-mb*xb1
		
		if ma~=mb then

			x=(ba-bb)/(mb-ma)
			y=ma*x+ba		
			
			f1=inrange(x,xa1,xa2)	-- check if the intersection in the rage of both lines
			f2=inrange(x,xb1,xb2)	
			f3=inrange(y,ya1,ya2)	
			f4=inrange(y,yb1,yb2)


			if f1==nil or f2==nil or f3==nil or f4==nil then --if not in range than nil
				x=nil
				y=nil
			end	
				
		end
	end		
	
	if xa2 == xa1 and xb2 ~=xb1 then
	
		mb=(yb2-yb1)/(xb2-xb1)
		bb=yb1-mb*xb1
		
		x=xa1
		y=mb*x+bb
		
			if f1==nil or f2==nil or f3==nil or f4==nil then
				x=nil
				y=nil
			end	

				
	end
		
	if xa2 ~= xa1 and xb2 == xb1 then
	
		ma=(ya2-ya1)/(xa2-xa1) 
		ba=ya1-ma*xa1
		
		x= xb1
		y=ma*x+ba
		
			f1=inrange(x,xa1,xa2)	
			f2=inrange(x,xb1,xb2)	
			f3=inrange(y,ya1,ya2)	
			f4=inrange(y,yb1,yb2)


			if f1==nil or f2==nil or f3==nil or f4==nil then
				x=nil
				y=nil
			end	
	end	
		
	return x,y
end
 
 function inrange(c,z1,z2)-- checks if a value c is in between z1 and z2 and return c or nil

	if z1>z2 then 
		high=z1 
		low=z2
	end
	if z1<z2 then 
		high = z2
		low = z1
	end
	
	cin=nil
	
	if c>=low and c<=high then -- when c between low and high return a value otherwise nothing
	
	cin=1
	
	end

	if cin==nil then
	
	c=nil
	
	end
		
	return c
 
 end
 
 function redTrace(sim,par)--draw the trace of the particles in red

	for i=0, getn(par)-1 do

		for n=0 , getn(par[i].point) do
		eo_addcontour(par[i].point[n].x,par[i].point[n].y)
		end
		M=getn(par[i].point)
		for n=0 , getn(par[i].point) do
		eo_addcontour(par[i].point[M-n].x,par[i].point[M-n].y)
		end
		
	end
end

function blueTrace(sim,par)
ei_setfocus(sim.SimName)
	for i=0, getn(par)-1 do

		for n=0 , getn(par[i].point) do
		ei_addnode(par[i].point[n].x,par[i].point[n].y)
		
		end
		for n=0 , getn(par[i].point)-1 do
		ei_addsegment(par[i].point[n].x,par[i].point[n].y,par[i].point[n+1].x,par[i].point[n+1].y)
		end
			
	end
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
		
		t.label={x=DIS*0.9,y=DIS*0.9} --position of simulaiton label
		ei_addblocklabel(t.label.x,t.label.y)
		ei_selectlabel(t.label.x,t.label.y)
		ei_getmaterial(MAT)
		ei_setblockprop(MAT,0,DIS/50,0,0,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)      
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

		t.label={x=DIS*0.9,y=DIS*0.9} --position of simulaiton label t.label={x=t.MHR+t.MOR/2,y=t.POS}
		mi_addblocklabel(t.label.x,t.label.y)	
		mi_selectlabel(t.label.x,t.label.y)
		mi_getmaterial(t.MAT)
		mi_setblockprop(t.MAT,0,0,0,0,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)      
		mi_clearselected()
		
	end
	
  return t
end

function SimBox:solve() --solve for electical and magdirectical simulaiton and reates the graphs

if self.ENV=="El" then --solve for electical simulaiton
	ei_setfocus(self.SimName) --choose file for drawing
	ei_analyze()-- start analyzes          
	ei_loadsolution() --load solution
	eo_hidepoints()
	eo_showdensityplot(1,0,2,2)-- create desityplot legend 0:1 ,gscale 0:1 ,upper_B,lower_B,type
	eo_showvectorplot(2,2) --plot veter arrows
	eo_zoomnatural()-- zoom out
	eo_refreshview()
	
end

if self.ENV=="Ma" then --solve for magnetical simulaiton
	mi_setfocus(self.SimName) --choose file for drawing
	mi_analyze()-- start analyzes          
	mi_loadsolution() --load solution
	mo_showdensityplot(1,0,0,2,"bmag")-- create desityplot legend 0:1 ,gscale 0:1 ,upper_B,lower_B,type
	mo_hidepoints()
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




-- Play ground -----------------------------------------------------------------------------------------------------

	sim4=SimBox:new(0,"Air","planar",10,"El") 
	
	tip=Deflector:new(sim4,0,1,3,6,"Air",-100) --SimName,DHR,DOR,DH,POS,MAT,VOLT
	rightAnod=Deflector:new(sim4,2,3,2,0,"Air",0)
	leftAnod=Deflector:new(sim4,-1,-3,4,0,"Air",0)
	
	
	SolidObjects={}
	SolidObjects[0]=sim4
	SolidObjects[1]=leftAnod
	SolidObjects[2]=rightAnod
	SolidObjects[3]=tip
	
	par={}
	for i=0 ,20 do --number of particle
	par[i]=Particle:new(sim4,i*0.3-03,4.0,0.00025) --(SimName,x,Y,StepSize)
	end
		
	sim4:solve()

	--print("start")--{Bx=0,By=0,Ex=0,Ey=0,X=x,y=y,Vx=0,Vy=0,Ttot=0,S=0.001
for i=0, 200 do -- step of the particle
	for n=0 , getn(par) do
		par[n]:move(SolidObjects)--objects
		end
	end


blueTrace(sim4,par)
sim4:solve()
--Draw the tace of the particle
















