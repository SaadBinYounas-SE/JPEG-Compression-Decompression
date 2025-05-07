function img = jpeg_decoder(encoded, height, width)
    %Yeh function compressed zigzag data se wapas 8x8 blocks banata hai, un pe inverse DCT lagata hai, aur 
    % blocks ko jor ke image reconstruct karta hai. Agar padding hui ho to remove bhi karta hai.

    % Pehle original image ke dimensions se padding ka andaza lagate hain
    padH = mod(8 - mod(height,8), 8);
    padW = mod(8 - mod(width,8), 8);
    paddedHeight = height + padH;
    paddedWidth  = width + padW;

    % Encoded array ke size se andaza lagate hain ke kitne blocks aur channels hain
    [blocksH, blocksW, channels] = size(encoded);

    % Ek khali image banate hain jisme reconstructed blocks rakhne hain
    img = zeros(paddedHeight, paddedWidth, channels);

    % Har channel ke liye loop
    for ch = 1:channels
        for i = 1:blocksH
            for j = 1:blocksW
                zz = encoded{i,j,ch};               % Zigzag vector nikalte hain
                q_block = inv_zigzag(zz);           % Zigzag ko wapas 8x8 block mein
                dct_block = q_block .* quant_matrix();  % Dequantize karte hain
                block = idct2(dct_block);           % Inverse DCT lagate hain
                row = (i-1)*8 + 1;
                col = (j-1)*8 + 1;
                img(row:row+7, col:col+7, ch) = block;  % Block ko wapas image mein rakh dete hain
            end
        end
    end

    % Double se uint8 mein convert karte hain taake display ke laayak ho
    img = uint8(img);

    % Padding remove karte hain taake original size ki image mil jaye
    img = img(1:height, 1:width, :);

    % Agar image grayscale hai, to 3D ko 2D bana dete hain
    if channels == 1
        img = img(:,:,1);
    end
end
