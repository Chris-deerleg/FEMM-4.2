
-- DIY Scanning Electron Microscope author chris.deerleg
-- the full project could you find here https://hackaday.io/project/21831-3d-printed-scanning-electron-microscope

function GradToRad(grad) -- convert a angle from ° to rad
radial=grad*PI/180
return radial 
end

function Pentagon (h1,h2,w1,w2,turn,posx,posy) -- this function calculate the cornes of a pentagon
	
	point={}
	
	
	point[0]={x=w1/2*cos(GradToRad(turn))+posx , y= w1/2*sin(GradToRad(turn))+posy}
	
	point[1]={x=sqrt((w1/2)^2+h1^2)*cos(GradToRad(turn)+acos(w1/(2*sqrt((w1/2)^2+h1^2))))+posx, y= sqrt((w1/2)^2+h1^2)*sin(GradToRad(turn)+acos(w1/(2*sqrt((w1/2)^2+h1^2))))+posy}
	
	point[2]={x=sqrt((w1/2)^2+h1^2)*cos(GradToRad(turn)+PI-acos(w1/(2*sqrt((w1/2)^2+h1^2))))+ posx ,y=sqrt((w1/2)^2+h1^2)*sin(GradToRad(turn)+PI-acos(w1/(2*sqrt((w1/2)^2+h1^2))))+ posy }

	point[3]={x=w1/2*cos(GradToRad(turn)+PI)+ posx ,y=w1/2*sin(GradToRad(turn)+PI)+ posy } 
	
	point[4]={x= sqrt((w2/2)^2+h2^2)*cos(GradToRad(turn)+acos(w2/(2*sqrt((w2/2)^2+h2^2)))+PI)+ posx ,	y= sqrt((w2/2)^2+h2^2)*sin(GradToRad(turn)+acos(w2/(2*sqrt((w2/2)^2+h2^2)))+PI)+ posy }
	
	point[5]={x=-sqrt((w2/2)^2+h2^2)*cos(GradToRad(turn)+acos(-(w2/2)/sqrt((w2/2)^2+h2^2)))+ posx ,	y= -sqrt((w2/2)^2+h2^2)*sin(GradToRad(turn)+acos(-(w2/2)/sqrt((w2/2)^2+h2^2)))+ posy }
	
	lablex=posx+(point[1].x-posx)*0.8 --position for  label
	labley=posy+(point[1].y-posy)*0.8
	
	return point, lablex, labley
end

if 1 then -- Particle class folding the comments below
Particle = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(Particle),"index", function(t,f) return %Particle[f] end) -- class function table
end

function Particle:new(ElecticalSim,MagneticalSim,xa1,ya1,xa2,ya2,Particlenumber,Stepsize)  -- create an instance of class Particle 
-- functions to create a particle to move through fields
  local t = {par={},Q=-1.6021766208e-19,M=9.10938356e-31,Els=ElecticalSim,Mas=MagneticalSim}--E[V/m]; x[mm]; s= stepsize 1mm;q=charge of electron; m=mass of a electron 
    settag(t,tag(Particle))  -- tag the new table to tell it what its class type is
	
	
		
	if xa2~=xa1 then 
	
		if xa1<xa2 then 
			xmin=xa1
		end
		
		if xa1>xa2 then 
			xmin=xa2
		end
		
		dx=abs(xa1-xa2)/(Particlenumber-1) --number of particles to create
		
		ma=(ya2-ya1)/(xa2-xa1) -- calculate the values for the linear equation y=mx+b
		ba=ya1-ma*xa1
		
		for i=0 , Particlenumber do
		
		t.par[i]={point={},collision=0}
		t.par[i].point[0]={x=xmin+dx*i, y=ma*(xmin+dx*i)+ba,Bx=0,By=0,Ex=0,Ey=0,Vx=0,Vy=0,Ttot=0,S=Stepsize,Vphi=0}--1mm if grid is in mm 
	
		end
	
	
	end
	
	if xa2==xa1 then
	
		if ya1<ya2 then 
			ymin=ya1
		end
		
		if ya1>ya2 then 
			ymin=ya2
		end
		
		dy=abs(ya1-ya2)/(Particlenumber-1) --number of particles to create
		
		for i=0 , Particlenumber do
		
			t.par[i]={point={},collision=0}
			t.par[i].point[0]={x=xa1,y=(ymin+dy*i),Bx=0,By=0,Ex=0,Ey=0,Vx=0,Vy=0,Ttot=0,S=1}
	
		end
	
	end
	
	return t	
end	

function Particle:move()--calculate the next postion of a particle
	for h=0, getn(self.par) do
		if self.par[h].collision==0 then 
		--http://www.leifiphysik.de/elektrizitaetslehre/bewegte-ladungen-feldern
		--https://www.youtube.com/watch?v=Nbuw_zWnlyA
		--https://www.youtube.com/watch?v=jSziTlvmAeo
			
			N=getn(self.par[h].point) --get the numbers of par[h].point
			self.par[h].point[N+1]={Bx=0,By=0,Ex=0,Ey=0,x=0,y=0,Vx=0,Vy=0,Ttot=0,S=0, Vphi=0} --create a new par[h].point
			self.par[h].point[N+1].S=self.par[h].point[N].S -- copy values 
			s=self.par[h].point[N].S
			
			ElSolvName,NA=gsub (self.Els.SimName, ".fee", ".res")--replace the end of filenam .fee with .res
			eo_setfocus(ElSolvName)
			
			MaSolvName,NA=gsub (self.Mas.SimName, ".fem", ".ans")--replace the end of filenam .fee with .res
			mo_setfocus(MaSolvName)
			
			e01,e02,e03,Ex,Ey,e06,e07,e08=eo_getpointvalues(self.par[h].point[N].x,self.par[h].point[N].y) -- get the result of the simulation at a par[h].point
			ma01,Bx,By,ma04,ma05,ma06,ma07,ma08,ma09,ma10,ma11,ma12,ma13,ma14 =mo_getpointvalues(self.par[h].point[N].x,self.par[h].point[N].y)
			
			
				
			if Bx == nil then Bx=0 end --catch the error when the no field result lead to nil error
			if By == nil then By=0 end	
			
			if Ex == nil then Ex=0 end --catch the error when the no field result lead to nil error
			if Ey == nil then Ey=0 end
								
								
			vx=self.par[h].point[N].Vx
			vy=self.par[h].point[N].Vy
			vphi=self.par[h].point[N].Vphi
			
			absV =sqrt(vx^2+vy^2)
			
			aphi=self.Q/self.M*(vy*Bx)+self.Q/self.M*(vx*By)
			
			axp=self.Q/self.M*(vphi*By)
			ayp=self.Q/self.M*(vphi*Bx)
				
			ax = Ex * self.Q / self.M  --Acceleration by the field
			ay = Ey * self.Q / self.M
			
			absA=sqrt((ax+axp)^2+(ay+ayp)^2)
			
			if absA ~= 0 then ts=(sqrt(2*s*absA+absV^2)-absV)/absA end --normal case
			if absA == 0 then ts=s/absV end	-- catch div by zero
			if absA == 0 and absV ==0 then ts=10e10 end -- catch div by zero
				
			vphi=aphi*ts
	
			vxs=(ax+axp)*ts+vx --speed after section
			sx = (ax+axp)/2*ts^2+vx*ts --additional position after section
			vys=(ay+ayp)*ts+vy --speed after section
			sy=(ay+ayp)/2*ts^2+vy*ts --additional position after section

			
			self.par[h].point[N+1].Ex=Ex
			self.par[h].point[N+1].Ey=Ey
			self.par[h].point[N+1].Bx=Bx
			self.par[h].point[N+1].By=By
			self.par[h].point[N+1].Vx=vxs
			self.par[h].point[N+1].Vy=vys
			self.par[h].point[N+1].Vphi=vphi
			self.par[h].point[N+1].S=s
			self.par[h].point[N+1].x=self.par[h].point[N].x+sx*1000			-- the result of the calculation is in m the sim calculate in mm therefor a correction of 1000 is needed
			self.par[h].point[N+1].y=self.par[h].point[N].y+sy*1000
			self.par[h].point[N+1].Ttot= self.par[h].point[N].Ttot+ts --total time
			
				
			for i=0 , getn(self.Els.part) do --collision detection for ElecticalSim
				
				--check for segment from point 0 to the last point 	
					cx,cy = intersection(self.par[h].point[N].x,self.par[h].point[N].y,self.par[h].point[N+1].x,self.par[h].point[N+1].y,self.Els.part[i].point[0].x,self.Els.part[i].point[0].y,self.Els.part[i].point[getn(self.Els.part[i].point)].x,self.Els.part[i].point[getn(self.Els.part[i].point)].y) --check for collision intersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2)
					
				if cx~=nil or cy~= nil then -- collision detected once intersection point returned
					if self.Els.part[i].solidness=="solid" then 
					self.par[h].collision = -1
					self.par[h].point[N+1].x=cx
					self.par[h].point[N+1].y=cy
					break
					end
				end	
				
				for j=0, getn(self.Els.part[i].point)-1 do

					cx,cy = intersection(self.par[h].point[N].x,self.par[h].point[N].y,self.par[h].point[N+1].x,self.par[h].point[N+1].y,self.Els.part[i].point[j].x,self.Els.part[i].point[j].y,self.Els.part[i].point[j+1].x,self.Els.part[i].point[j+1].y) --check for collision intersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2)
					if cx~=nil or cy~= nil then -- collision detected once intersection point returned
						if self.Els.part[i].solidness=="solid" then 
						self.par[h].collision = -1
						self.par[h].point[N+1].x=cx
						self.par[h].point[N+1].y=cy
						break
						end
					end	
						
				end
			end
					
						
			for i=0 , getn(self.Mas.part) do -- collision detection for MagneticalSim
				
				--check for segment from point 0 to the last point 	
				cx,cy = intersection(self.par[h].point[N].x,self.par[h].point[N].y,self.par[h].point[N+1].x,self.par[h].point[N+1].y,self.Mas.part[i].point[0].x,self.Mas.part[i].point[0].y,self.Mas.part[i].point[getn(self.Mas.part[i].point)].x,self.Mas.part[i].point[getn(self.Mas.part[i].point)].y) --check for collision intersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2)
				if cx~=nil or cy~= nil then -- collision detected once intersection point returned
					if self.Mas.part[i].solidness=="solid" then 
						self.par[h].collision = -1
						self.par[h].point[N+1].x=cx
						self.par[h].point[N+1].y=cy
						break
					end
				end	
				
				for j=0, getn(self.Mas.part[i].point)-1 do
					cx,cy = intersection(self.par[h].point[N].x,      self.par[h].point[N].y,      self.par[h].point[N+1].x,      self.par[h].point[N+1].y,         self.Mas.part[i].point[j].x,       self.Mas.part[i].point[j].y,       self.Mas.part[i].point[j+1].x,       self.Mas.part[i].point[j+1].y) --check for collision intersection(xa1,ya1,xa2,ya2,xb1,yb1,xb2,yb2)
		
					if cx~=nil or cy~= nil then -- collision detected once intersection point returned
						if self.Mas.part[i].solidness=="solid" then 
						self.par[h].collision = -1
						self.par[h].point[N+1].x=cx
						self.par[h].point[N+1].y=cy
						break
						end
					end	
						
				end
			end
			
				
		end	
	end
end

function Particle:trace(with_lines) -- plot a tace of the particles in the simulation .fem .fee "1" mean connect the point
	if self.Els~=nil then
	
		ei_setfocus(self.Els.SimName)
			for i=0, getn(self.par)-1 do

				for n=0 , getn(self.par[i].point) do
				ei_addnode(self.par[i].point[n].x,self.par[i].point[n].y)
				
				end
				if with_lines==1 then
					for n=0 , getn(self.par[i].point)-1 do
					ei_addsegment(self.par[i].point[n].x,self.par[i].point[n].y,self.par[i].point[n+1].x,self.par[i].point[n+1].y)
					end
				end
					
			end
	end
	
	if self.Mas~=nil then
	
		mi_setfocus(self.Mas.SimName)
			for i=0, getn(self.par)-1 do

				for n=0 , getn(self.par[i].point) do
				mi_addnode(self.par[i].point[n].x,self.par[i].point[n].y)
				
				end
				if with_lines== 1 then 
					for n=0 , getn(self.par[i].point)-1 do
					mi_addsegment(self.par[i].point[n].x,self.par[i].point[n].y,self.par[i].point[n+1].x,self.par[i].point[n+1].y)
					end
				end
			end	
	
	end
end

function Particle:DelTrace()--Delite the tace of particles for a sim

	if self.Els~=nil then
		ei_setfocus(self.Els.SimName)
		
			for i=0, getn(self.par)-1 do
					
					
				if self.par[i].collision==0 then 
				LastPoint=getn(self.par[i].point)
				end
				
				if self.par[i].collision==-1 then 
				LastPoint=getn(self.par[i].point)-1
				end
					
				for n=0 , LastPoint do
				ei_selectnode(self.par[i].point[n].x,self.par[i].point[n].y)
				end					
			end
		ei_deleteselectednodes()
	end
	
	if self.Mas~=nil then
	
		mi_setfocus(self.Mas.SimName)
			for i=0, getn(self.par)-1 do

				if self.par[i].collision==0 then 
				LastPoint=getn(self.par[i].point)
				end
				
				if self.par[i].collision==-1 then 
				LastPoint=getn(self.par[i].point)-1
				end
			
				for n=0 , LastPoint do
				mi_selectnode(self.par[i].point[n].x,self.par[i].point[n].y)
				end
			end	
		ei_deleteselectednodes()
	end

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
			
			f1,c1=inrange(x,xa1,xa2)	-- check if the intersection in the rage of both lines
			f2,c2=inrange(x,xb1,xb2)	
			f3,c3=inrange(y,ya1,ya2)	
			f4,c4=inrange(y,yb1,yb2)

	
 
	
	
			
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
	if z1==z2 then 
		high = z1
		low = z1
	end
	
	-- Becaus LUA shows the behavior that sometime the expected result of zero is a littel bit off e.g. -7.401486830834377e-017 instead of 0. 
 -- This corrupts the intersection calculation in this manner that no intersection is found because the values are not in range. 
 -- The workaround is that if the numbers very close then the range will be increas see the next if statement
	
	if abs(z1-z2)<=1e-6 then 
	high = z1+1e-6
		low = z1-1e-6
	end
	
	cin=0
	
	if c>=low and c<=high then -- when c between low and high return a value otherwise nothing
	
	cin=1
	
	end

	if cin==0 then
	
	c=nil
	
	end
		
	return c,cin
 
 end
 
 if 1 then -- SimBox class folding the comments below
SimBox = settag({},newtag()) -- settag() returns a table "{}" which has been tagged with a new tag value
settagmethod(tag(SimBox),"index", function(t,f) return %SimBox[f] end) -- class function table
end

function SimBox:new(POS,WIDTH,HIGHT,ENV)  -- create an area what the particle can not leave
--env is either "El" for a electical simulaiton or Ma for a magnetic simulaiton
--Type is 'planar' or 'axi'
-- functions to create a Simulation Box for a magnetic simulaiton
 local t = {part={},SimName="empty",env=ENV}
    settag(t,tag(SimBox))  -- tag the new table to tell it what its class type is
	t.part[0]={point={},label={},mat="Air",pos={},solidness="solid"}
	t.part[0].point[0]={x=0,y=0}
	t.part[0].label={x=0,y=0}
	t.part[0].pos={x=0,y=POS}
	
	
	

	-- calculate the coners	 
  
--    [0]..[4]...........[3]  ^             y+ (z+)
--     :      <---WIDTH-->:  HIGHT          ^
--     :                  :   v             | 
--     :       POS        :        (-r)-x <- -> x+ (r+)       
--     :                  :                 |   
--     :                  :    	            v 
--    [1]................[2]                -y (-z)

	
	t.part[0].point[0]={x=-WIDTH/2,y=POS+HIGHT/2}
	t.part[0].point[1]={x=-WIDTH/2,y=POS-HIGHT/2}
	t.part[0].point[2]={x=WIDTH/2,y=POS-HIGHT/2}
	t.part[0].point[3]={x=WIDTH/2,y=POS+HIGHT/2}
	t.part[0].point[4]={x=(-WIDTH/2)*0.99,y=POS+HIGHT/2}

	
	
	if ENV=="El" then --draw simulation box for electical simulaiton
		t.SimName = ElProbDef("planar") --set the boundaries of the electical simulation	
		
		for i=0,getn(t.part[0].point) do -- -- draw the coners 
			ei_addnode(t.part[0].point[i].x,t.part[0].point[i].y)
		end
		for i=0,getn(t.part[0].point)-1 do -- connect the coners
			ei_addsegment(t.part[0].point[i].x,t.part[0].point[i].y,t.part[0].point[1+i].x,t.part[0].point[1+i].y)
		end
	
		
		
	end
	
	if ENV=="Ma" then --draw simulaiton box for magnetic simulaiton
		t.SimName = MaProbDef("planar") --set the boundaries of the magnetic simulation
		for i=0,getn(t.part[0].point) do -- -- draw the coners 
			mi_addnode(t.part[0].point[i].x,t.part[0].point[i].y)
		end
		for i=0,getn(t.part[0].point)-1 do -- connect the coners
			mi_addsegment(t.part[0].point[i].x,t.part[0].point[i].y,t.part[0].point[1+i].x,t.part[0].point[1+i].y)
		end
		
		
	end
	
  return t
end

function SimBox:softBorder(POS,WIDTH,HIGHT) -- create an area wehre the field will simulated

N=getn(self.part)+1


	-- calculate the coners	 
  
--    [0]................[3]  ^             y+ (z+)
--     :        <-WIDTH-->:  HIGHT          ^
--     :                  :   v             | 
--     :       POS        :        (-r)-x <- -> x+ (r+)       
--     :                  :                 |   
--     :                  :    	            v 
--    [1]................[2]                -y (-z)


	self.part[N]={point={},label={},mat="Air",pos={x=0,y=POS},solidness="porous"}
	
	
	
	array,xlable,ylable=Pentagon(HIGHT/2,HIGHT/2,WIDTH,WIDTH,0,0,self.part[N].pos.y) --h1,h2,w1,w2,turn,posx,posy calcualtes the points 
	self.part[N].label={x=xlable, y=ylable}
	
	
	for i=0, getn(array) do 
	self.part[N].point[i]={x=array[i].x,y=array[i].y} -- moves the points in the objects
	end
	
	
		
if self.env=="El" then -- draw the points in the simulaiton

drawEL(self)
drawElLable(self)
	
end

if self.env=="Ma" then -- draw the points in the simulaiton
	
drawMa(self)
drawMaLable(self,0)--air no polarity

end
	
end

function SimBox:Part(h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)

N=getn(self.part)+1

self.part[N]={point={},label={},mat=MAT,pos={},solidness="solid"} --add a new objects 
self.part[N].pos={x=POSX,y=POSY}
self.part[N].label={x=POSX,y=POSY} --position of simulaiton label
	
array,xlable,ylable=Pentagon(h1,h2,w1,w2,turn,self.part[N].pos.x,self.part[N].pos.y) --h1,h2,w1,w2,turn,posx,posy create the points of the objects
self.part[N].label={x=xlable, y=ylable}
	
for i=0, getn(array) do  --move the points in the class
	self.part[N].point[i]={x=array[i].x,y=array[i].y}
end


if self.env=="El" then

drawEL(self)
drawElLable(self)
drawElVoltage(self,volt_or_polari)	
end

if self.env=="Ma" then
	
drawMa(self)
drawMaLable(self,volt_or_polari+turn)

end

end

function SimBox:solve() --solve for electical and magdirectical simulaiton and reates the graphs



if self.env=="El" then --solve for electical simulaiton
	ei_setfocus(self.SimName) --choose file for drawing
	ei_analyze()-- start analyzes
		
	ei_loadsolution() --load solution
		--eo_hidepoints()
	eo_showdensityplot(0,0,2,2)-- create desityplot legend 0:1 ,gscale 0:1 ,upper_B,lower_B,type
	eo_showvectorplot(2,2) --plot veter arrows 1,1
	eo_zoomnatural()-- zoom out
	eo_refreshview()
	
end

if self.env=="Ma" then --solve for magnetical simulaiton
	mi_setfocus(self.SimName) --choose file for drawing
	mi_analyze()-- start analyzes
	
	mi_loadsolution() --load solution
	mo_showdensityplot(0,0,0,2,"bmag")-- create desityplot legend 0:1 ,gscale 0:1 ,upper_B,lower_B,type
	--mo_hidepoints()
	mo_showvectorplot(1,1) --plot veter arrows 
	mo_zoomnatural()-- zoom out
	mo_refreshview()
end 

end


function SimBox:savePic(POSX,POSY,HIGHT,WIDTH,Infos)

ElSolvName,NA=gsub (self.SimName, ".fee", ".res")--replace the end of filenam .fee with .res
eo_setfocus(ElSolvName)

-- calculate the coners	 
  
--    []..    .........[x2y2]  ^             y+ (z+)
--     :      <---WIDTH-->:  HIGHT          ^
--     :                  :   v             | 
--     :       POS        :        (-r)-x <- -> x+ (r+)       
--     :                  :                 |   
--     :                  :    	            v 
--    [x1x1].............[]            -y (-z)

x1=POSX-WIDTH
y1=POSY-HIGHT
x2=POSX+WIDTH
y2=POSY+HIGHT

ratio=WIDTH/HIGHT
scale=500

WIDTH=scale*ratio
HIGHT=WIDTH/ratio


eo_restore()				
eo_resize(WIDTH,HIGHT)
eo_zoom(x1,y1,x2,y2)			
eo_resize(WIDTH,HIGHT)
eo_zoom(x1,y1,x2,y2)
eo_restore()

Dir="./SimPictures/"		-- Directory for the files
eo_savebitmap(Dir..ElSolvName.."_"..Infos..".jpg")
		
	

end


function closeWindows()
mi_close()	
ei_close()	
mo_close()
eo_close()
end

function drawEL(o) -- this function draws the points and set a label in a electical simulaiton

	ei_setfocus(o.SimName) --choose file for drawing
		
	for i=0,getn(o.part[N].point) do -- -- draw the coners 
		ei_addnode(o.part[N].point[i].x,o.part[N].point[i].y)
		
	end
	for i=0,getn(o.part[N].point)-1 do -- connect the coners
		ei_addsegment(o.part[N].point[i].x,o.part[N].point[i].y,o.part[N].point[1+i].x,o.part[N].point[1+i].y)
	end
	ei_addsegment(o.part[N].point[0].x,o.part[N].point[0].y,o.part[N].point[getn(o.part[N].point)].x,o.part[N].point[getn(o.part[N].point)].y) --connect last and first point
	ei_zoomnatural()-- zoom out
end

function drawElLable(o) --set a blocklable in electical simulaiton
	--set property of block
	ei_addblocklabel(o.part[N].label.x,o.part[N].label.y)
	ei_selectlabel(o.part[N].label.x,o.part[N].label.y)
	ei_getmaterial(o.part[N].mat)
	ei_setblockprop(o.part[N].mat,0,0,0,0,4,0)      
	ei_clearselected() 
	
end

function drawElVoltage(o,volt)--set voltage of segments

	
	
	--preparation  of the Voltage for the Segments
	ConductorName="Volt"..random(999)..":"..volt
	ei_addconductorprop(ConductorName,volt,0,1) --unused property to zero. Last parameter is 0 for charge and 1 for voltages
	ei_setsegmentprop("None", 0, 1, 0, 0,ConductorName)
	
	
	for i=0,getn(o.part[N].point)-1 do 
		
		xmid=(o.part[N].point[i].x+o.part[N].point[1+i].x)/2 --calculate the middel between the two point
		ymid=(o.part[N].point[i].y+o.part[N].point[1+i].y)/2
		ei_selectsegment(xmid,ymid)
		ei_setsegmentprop("None",0,1,0,0,ConductorName)
		ei_clearselected()
	end
	--o.part[N].point[i].x
	xmid=(o.part[N].point[0].x+o.part[N].point[getn(o.part[N].point)].x)/2
	ymid=(o.part[N].point[0].y+o.part[N].point[getn(o.part[N].point)].y)/2
	ei_selectsegment(xmid,ymid)
	ei_setsegmentprop("None",0,1,0,0,ConductorName)
	ei_clearselected()

	

end

function drawMaLable(o,polari) --set a blocklable in magdirectical simulaiton

	mi_addblocklabel(o.part[N].label.x,o.part[N].label.y)
	mi_selectlabel(o.part[N].label.x,o.part[N].label.y)
	mi_getmaterial(o.part[N].mat)
	mi_setblockprop(o.part[N].mat,0,0,0,polari,4,0)--("blockname", automesh, meshsize, "incircuit", magdirection, group, turns)     
	mi_clearselected()

end

function drawMa(o) -- this function draws the points and set a label in a magnetic simulaiton

	mi_setfocus(o.SimName) --choose file for drawing
	
	for i=0,getn(o.part[N].point) do -- -- draw the coners 
		mi_addnode(o.part[N].point[i].x,o.part[N].point[i].y)
		
	end
	for i=0,getn(o.part[N].point)-1 do -- connect the coners
		mi_addsegment(o.part[N].point[i].x,o.part[N].point[i].y,o.part[N].point[1+i].x,o.part[N].point[1+i].y)
	end
	mi_addsegment(o.part[N].point[0].x,o.part[N].point[0].y,o.part[N].point[getn(o.part[N].point)].x,o.part[N].point[getn(o.part[N].point)].y) --connect last and first point
	mi_zoomnatural()-- zoom out

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

Name=date("%Y%m%d_%H-%M-%S_").."MaProbDef"..".fem"-- creates a uniqu name
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
Name=date("%Y%m%d_%H-%M-%S_").."ElProbDef"..".fee"-- creates a uniqu name
Dir="./ProbDef/"		-- Directory for the files
ei_saveas(Dir..Name)
return Name
end

-- Play ground -----------------------------------------------------------------------------------------------------
	simMa=SimBox:new(15,32,27,"Ma") --POS,WIDTH,HIGHT,Type
	simMa:softBorder(15,32,27) --POS,WIDTH,HIGHT)
	simMa:Part(2,2,2.9,2.9,0,-3,10,"NdFeB 40 MGOe",90)-- left Magnet h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(0.5,0.5,4,4,0,-2.5,13,"Pure Iron",0)--left Top Iron h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(4,3,1,1,0,-5,10,"Pure Iron",0)-- left side Iron h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(2.5,1.9,1,1,0,-1,10,"Pure Iron",0)-- left in side Iron h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(0.5,0.5,4,4,0,-2.5,7.5,"Pure Iron",0)--left bottom Iron h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	
	
	simMa:Part(2,2,2.9,2.9,0,3,10,"NdFeB 40 MGOe",90)--right Magnet h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(0.5,0.5,4,4,0,2.5,13,"Pure Iron",0)--right Top h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(4,3,1,1,0,5,10,"Pure Iron",0)-- right side Iron h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(2.5,1.9,1,1,0,1,10,"Pure Iron",0)-- right in side Iron h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simMa:Part(0.5,0.5,4,4,0,2.5,7.5,"Pure Iron",0)--right bottom Iron h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	
	if 1 then 
		simMa:solve()
	
	Voltage=-99
	
	simEl=SimBox:new(15,32,27,"El") 
	simEl:softBorder(15,32,27) --POS,WIDTH,HIGHT)
	simEl:Part(10,1,1,0.01,0,0,18,"Nylon",-1000)  --tip --h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simEl:Part(0.2,0.2,10,10,0,-5.25,16,"Nylon",0)  --left deflector --h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simEl:Part(0.2,0.2,10,10,0,5.25,16,"Nylon",0)  --right deflector --h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simEl:Part(0.2,0.2,10,10,0,-5.75,15,"Nylon",Voltage)  --left deflector --h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simEl:Part(0.2,0.2,10,10,0,5.75,15,"Nylon",Voltage)  --right deflector --h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simEl:Part(0.2,0.2,10,10,0,-5.25,14,"Nylon",-10)  --left deflector --h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simEl:Part(0.2,0.2,10,10,0,5.25,14,"Nylon",-10)  --right deflector --h1,h2,w1,w2,turn,POSX,POSY,MAT,volt_or_polari)
	simEl:solve() 
	
	par1=Particle:new(simEl,simMa,-0.1,16.9,0.1,16.9,11,0.0002)--ElecticalSim,MagneticalSim,xa1,ya1,xa2,ya2,Particlenumber)
	
	for i=0,200 do
	par1:move()
	end
	
	par1:trace()
	simEl:solve()
	simMa:solve()
	
	end












