function [d_le,d_re,a_le,a_re] = speaker2ear_dist_fixed(x,y,sp_x,sp_y,hrad)
% Calculating speaker to ears distance
% from given parameters
%
% INPUT:
% x     = x coordinate of the head in the room
% y     = y coordinate of the head in the room
% sp_x  = x coordinate of the speaker in the room
% sp_y  = y coordinate of the speaker in the room
% hrad  = head radius
%
% OUTPUT:
% d_le = speaker to left ear distance
% d_re = speaker to right ear distance
% a_le = speaker to left ear angle
% a_re = speaker to right ear angle

a = atand( (x-sp_x) / (y-sp_y) );
if (x-sp_x>0) && (y-sp_y<0)
    a=180+a;
elseif  (x-sp_x<0) && (y-sp_y<0)
    a=-180+a;
end

if a==180
    a=-a;
end

% Exporting same angle for both ears
a_le = floor(a);
a_re = floor(a);

% Distance accord. to Sound Source Localization (by Popper p.139)
if a>90
    a = (2*pi()/360)*(180-a);
    d_le = sqrt( (sp_x-(x-hrad))^2 + (y-sp_y)^2 );
    d_re = d_le + hrad*(a+sin(a));
elseif a>0 && a<=90
    a = (2*pi()/360)*(a);
    d_le = sqrt( (sp_x-(x-hrad))^2 + (y-sp_y)^2 );
    d_re = d_le + hrad*(a+sin(a));
elseif a<0 && a>=-90
    a = (2*pi()/360)*(-a);
    d_re = sqrt( (sp_x-(x+hrad))^2 + (y-sp_y)^2 );
    d_le = d_re + hrad*(a+sin(a));
elseif a<-90
    a = (2*pi()/360)*(180+a);
    d_re = sqrt( (sp_x-(x+hrad))^2 + (y-sp_y)^2 );
    d_le = d_re + hrad*(a+sin(a));
end