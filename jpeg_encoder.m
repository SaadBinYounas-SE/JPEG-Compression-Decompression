function [encoded, orig_size, comp_size] = jpeg_encoder(img)
   %Yeh function image ko chhoti blocks mein divide karta hai, har block pe DCT lagata hai,
   %quantize karta hai aur zigzag order mein store karta hai. Is se compressed version milta hai.

    % Pehle image ke size (height, width, channels) le lete hain
    [height, width, channels] = size(img);
    
    % Image ko double mein convert karte hain taake DCT etc. apply kar sakein
    img = double(img);

    % Agar image grayscale hai (sirf 1 channel), to usay 3D banana zaroori hai
    if channels == 1
        img = reshape(img, height, width, 1); % 2D ko 3D bana diya
    end

    % Agar height/width 8 ka multiple nahi hai to pad karte hain
    padH = mod(8 - mod(height,8), 8);
    padW = mod(8 - mod(width,8), 8);
    img = padarray(img, [padH padW], 'replicate', 'post'); 
    % 'replicate' ka matlab hai border values ko repeat karna

    % New size after padding
    [height, width, channels] = size(img);

    % Encoded image ko store karne ke liye cell array banate hain
    encoded = cell(height/8, width/8, channels);

    % Har channel (R/G/B ya grayscale) pe loop chalayenge
    for ch = 1:channels
        for i = 1:8:height          % 8x8 blocks mein divide karte hain vertically
            for j = 1:8:width       % aur horizontally bhi
                block = img(i:i+7, j:j+7, ch);       % 8x8 block lete hain
                dct_block = dct2(block);             % Us pe 2D DCT apply karte hain
                q_block = round(dct_block ./ quant_matrix());  % Quantization karte hain
                iDiv = floor(i/8) + 1;               % Block index nikalte hain
                jDiv = floor(j/8) + 1;
                encoded{iDiv, jDiv, ch} = zigzag(q_block);  % Zigzag order mein store karte hain
            end
        end
    end

    % Original image size in bits
    orig_size = numel(img) * 8;

    % Approximate compressed size in bits (assuming 64 coeffs/block)
    comp_size = numel(encoded) * 64;
end
