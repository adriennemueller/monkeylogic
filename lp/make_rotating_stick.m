% Suite of functions to make image files for a cue 'stick'.
% If centered variable is 1, it will center the stick otherwise it will
% make one that points out from the center.

function movie = make_rotating_stick( Rwidth, Rheight, centered )
    rect = rgb(make_rect( Rwidth, Rheight, centered ));
    rect = colorize_rect( rect, [0.001 0.69 0.001] ); % Green
    movie = make_rotating_movie( rect, 7 ); % Use 359 for 1deg steps
end

function movie = make_rotating_movie( I, nFrames )
    movie = I;
    step = 360 / (nFrames + 1);

    for angle = step : step : (360 - step)
        frame = imrotate(I, angle, 'bicubic', 'crop');
        frame(frame==0) = 0.55;
        imwrite( frame, ['cue_' num2str(round(angle)) '.jpeg'] );
        movie = cat(4, movie, frame);
    end
    mov = immovie(movie);
    movie2avi(mov, 'cue.avi', 'compression', 'Cinepak');    
end

function img = make_rect( Rwidth, Rheight, centered )
    Iwidth =  (ceil(sqrt(Rwidth^2 + Rheight^2)) *2) + 4;
    Iheight = Iwidth;
    
    % Define the image size for the background
    img = false(Iwidth, Iheight);

    % Make the rectangle
    if centered
        left   = floor(Iwidth/2  - Rwidth/2);
        right  = floor(Iwidth/2  + Rwidth/2);
        top    = floor(Iheight/2 - Rheight/2);
        bottom = floor(Iheight/2 + Rheight/2);
    else
        left   = floor(Iwidth/2  - Rwidth/2);
        right  = floor(Iwidth/2  + Rwidth/2);
        top    = floor(Iheight/2 -1);
        bottom = floor(Iheight/2 + Rheight);
    end

    img(left:right, top:bottom) = true;
end

function I = rgb( I )
    I = double(I);
    if size(I, 3) == 1
        I = repmat(I, [1 1 3]);
    end
end

function rslt = colorize_rect( rect, Rcolor )
    
    [m, n, o] = size( rect );
    for i = 1:m
        for j = 1:n
            if rect(i,j,1) == 1
                rect(i,j,1) = Rcolor(1);
            end
            if rect(i,j,2) == 1
                rect(i,j,2) = Rcolor(2);
            end
            if rect(i,j,3) == 1;
                rect(i,j,3) = Rcolor(3);
            end
        end
    end

    rslt = rect;
end
