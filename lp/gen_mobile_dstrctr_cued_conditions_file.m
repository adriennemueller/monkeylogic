function gen_mobile_dstrctr_cued_conditions_file( numTrials, filename )
    path( path, '../' );

    fid = fopen(filename, 'w');
    
    textline = generate_condition('Header', 6, 'FID', fid);
    fprintf(fid,  '%s\n');
    
    anglelist = [0:45:315];
    
    for i = 1:numTrials
    
        % Generate 'tilt' values for the targets themselves
        t1 = randi(36)*5;
        t2 = randi(36)*5;
        t3 = randi(36)*5;
        t4 = randi(36)*5;
        
        if t1 == t2
            t2 = t2 -5;
        end
        if t3 == t4
            t4 = t4 -5;
        end
        
        
        %Generate New Positions for Targets
        angle_selection = randi(8); %Get Random Angle
        theta = anglelist(angle_selection);
        cueangle = theta;
        theta = theta * pi/180;

        radius = 3; %randi(5); %Get Randum Radius between 1 and 5
        [t1x, t1y] = pol2cart(theta, radius); %Convert to polar coordinates
        t2x = -t1x; t2y = -t1y;

        
        TaskObject(1).Type = 'Fix';
        TaskObject(1).Arg{1} = 0;
        TaskObject(1).Arg{2} = 0;

        TaskObject(2).Type = 'Pic';
        TaskObject(2).Arg{1} = ['rect_' num2str(t1)];
        TaskObject(2).Arg{2} = t1x;
        TaskObject(2).Arg{3} = t1y;
        TaskObject(2).Arg{4} = 150;
        TaskObject(2).Arg{5} = 150;

        TaskObject(3).Type = 'Pic';
        TaskObject(3).Arg{1} = ['rect_' num2str(t2)];
        TaskObject(3).Arg{2} = t1x;
        TaskObject(3).Arg{3} = t1y;
        TaskObject(3).Arg{4} = 150;
        TaskObject(3).Arg{5} = 150;

        TaskObject(4).Type = 'Pic';
        TaskObject(4).Arg{1} = ['rect_' num2str(t3)];
        TaskObject(4).Arg{2} = t2x;
        TaskObject(4).Arg{3} = t2y;
        TaskObject(4).Arg{4} = 150;
        TaskObject(4).Arg{5} = 150;

        TaskObject(5).Type = 'Pic';
        TaskObject(5).Arg{1} = ['rect_' num2str(t4)];
        TaskObject(5).Arg{2} = t2x;
        TaskObject(5).Arg{3} = t2y;
        TaskObject(5).Arg{4} = 150;
        TaskObject(5).Arg{5} = 150;

        TaskObject(6).Type = 'Pic';
        TaskObject(6).Arg{1} = ['cue_' num2str(cueangle)];
        TaskObject(6).Arg{2} = 0;
        TaskObject(6).Arg{3} = 0;
        TaskObject(6).Arg{4} = 400;
        TaskObject(6).Arg{5} = 400;
        
        textline = generate_condition('Condition', i, 'Block', 1, 'Frequency', 1, 'TimingFile', 'lp_dstrctr_cued_mobile', 'TaskObject', TaskObject, 'FID', fid);
    end
    
    fclose(fid);

end