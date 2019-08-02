rx = rotx(-90,'deg');
rz = rotz(180,'deg');
r = rx*rz
[r,p,y] = dcm2angle(r,'XYZ')

% angle2dcm()