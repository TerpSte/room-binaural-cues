function [left_ear,right_ear]=applying_hrtfs(data_l,data_r,angle_l,angle_r,irs)

% inserting files
ir = get_ir(irs,angle_l);
le = ir(:,1);
re = ir(:,2);

% left ear
left_ear = auralize_ir(le,data_l,0);

% right ear
right_ear = auralize_ir(re,data_r,0);