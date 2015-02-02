% Suite of functions to make images files for rotating rectangular targets.

function movie = make_rotating_rect( Rwidth, Rheight )
    rect = rgb(make_rect( Rwidth, Rheight ));
    movie = make_rotating_movie( rect, 71 );
end

function movie = make_rotating_movie( I, nFrames )
    movie = I;
    step = 360 / (nFrames + 1);

    for angle = step : step : (360 - step)
        frame = imrotate(I, angle, 'bicubic', 'crop');
        imwrite( frame, ['rect_' num2str(round(angle)) '.jpeg'] );
        movie = cat(4, movie, frame);
    end
end

function img = make_rect( Rwidth, Rheight )
    Iwidth =  ceil(sqrt(Rwidth^2 + Rheight^2))+4;
    Iheight = Iwidth;

    % Define the image size for the background
    img = false(Iwidth, Iheight);

    % Make the rectangle
    left   = floor(Iwidth/2  - Rwidth/2);
    right  = floor(Iwidth/2  + Rwidth/2);
    top    = floor(Iheight/2 - Rheight/2);
    bottom = floor(Iheight/2 + Rheight/2);

    img(left:right, top:bottom) = true;
end

function I = rgb( I )
    I = double(I);
    if size(I, 3) == 1
        I = repmat(I, 1, 1, 3);
    end
end
