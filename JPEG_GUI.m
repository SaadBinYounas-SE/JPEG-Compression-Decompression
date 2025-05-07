function JPEG_GUI
    % GUI window create karte hain jiska title aur size set kar rahe hain
    fig = uifigure('Name','JPEG Compression & Decompression','Position',[100 100 1000 500]);

    % Teen axes banaye jahan images show hongi (original, compressed, decompressed)
    ax1 = uiaxes(fig, 'Position', [30 100 300 250]);
    title(ax1, 'Original');  % Original image ka title set kiya
    
    ax2 = uiaxes(fig, 'Position', [350 100 300 250]);
    title(ax2, 'Compressed');  % Compressed image ka title
    
    ax3 = uiaxes(fig, 'Position', [670 100 300 250]);
    title(ax3, 'Decompressed');  % Decompressed image ka title

    % Load Image button banaya, jab click ho to loadImage function chale
    btnLoad = uibutton(fig,'push','Text','Load Image',...
        'Position',[30 30 100 30],'ButtonPushedFcn',@(btn,event) loadImage());

    % Compress Image button banaya, click pe compressImage function chalega
    btnCompress = uibutton(fig,'push','Text','Compress',...
        'Position',[150 30 100 30],'ButtonPushedFcn',@(btn,event) compressImage());

    % Labels banaye jo sizes aur compression ratio display karenge
    lblOrig = uilabel(fig, 'Position',[30 360 300 20], 'Text','Original Size: ');
    lblComp = uilabel(fig, 'Position',[350 360 300 20], 'Text','Compressed Size: ');
    lblRatio = uilabel(fig, 'Position',[350 20 300 20], 'Text','Compression Ratio: ');
    lblDecomp = uilabel(fig, 'Position',[670 360 300 20], 'Text','Decompressed Size: ');

    % Ek structure use kiya jisme image ko temporarily store kar sakein
    imgData = struct('img',[]);

    % ----------- Function to load image from file ----------
    function loadImage()
        [file, path] = uigetfile({'*.jpg;*.png;*.bmp','Image Files'});  % Sirf image files allow hain
        if isequal(file,0)
            return;  % Agar user ne cancel kar diya to kuch na karo
        end

        img = imread(fullfile(path, file));  % Image ko read karte hain
        imgData.img = img;                  % Usay structure mein store karte hain

        imshow(img, 'Parent', ax1);         % Original image ko ax1 pe display karo

        % Size calculate karke label update karte hain (bits ko KB mein convert kiya)
        lblOrig.Text = sprintf('Original Size: %.2f KB', numel(img)*8/8192);
        lblComp.Text = 'Compressed Size: ';
        lblDecomp.Text = 'Decompressed Size: ';
        lblRatio.Text = 'Compression Ratio: ';

        % Purane graphs clear kar do
        cla(ax2); cla(ax3);
    end

    % ---------- Function to compress and decompress ----------
    function compressImage()
        % Agar image load nahi hui to alert show karo
        if isempty(imgData.img)
            uialert(fig,'Please load an image first','No Image');
            return;
        end

        % Original image ke height aur width nikaalte hain
        [height, width, ~] = size(imgData.img);

        % JPEG encoding function call karte hain
        [encoded, orig_size, comp_size] = jpeg_encoder(imgData.img);

        % JPEG decoder se decompressed image wapas le lete hain
        decompressed = jpeg_decoder(encoded, height, width);

        % Compressed image ka approx version bana ke show karte hain
        compressedImage = approximate_compressed(encoded);
        imshow(uint8(compressedImage), 'Parent', ax2);        % Ax2 pe show
        imshow(uint8(decompressed), 'Parent', ax3);           % Ax3 pe show

        % Size aur ratio update karte hain labels pe
        lblOrig.Text = sprintf('Original Size: %.2f KB', orig_size/8192);
        lblComp.Text = sprintf('Compressed Size: %.2f KB', comp_size/8192);
        lblDecomp.Text = sprintf('Decompressed Size: %.2f KB', numel(decompressed)*8/8192);
        lblRatio.Text = sprintf('Compression Ratio: %.2f', orig_size/comp_size);
    end

end
