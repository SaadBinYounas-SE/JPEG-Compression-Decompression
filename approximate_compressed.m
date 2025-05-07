function img = approximate_compressed(encoded)
    % encoded input 3D cell array hai: har 8x8 block DCT ke quantized coefficients ko store karta hai
    [h_blocks, w_blocks, channels] = size(encoded);  % block dimensions aur channels lete hain
    img = zeros(h_blocks*8, w_blocks*8, channels);    % Empty image array banate hain (float)

    q = quant_matrix();  % Quantization matrix ko load karte hain

    % Her channel ke liye:
    for ch = 1:channels
        for i = 1:h_blocks
            for j = 1:w_blocks
                zig = encoded{i,j,ch};           % Zigzag se quantized coefficients lete hain
                q_block = inv_zigzag(zig);       % Unko 8x8 matrix mein wapas convert karte hain
                dct_block = q_block .* q;        % Dequantize karne ke liye multiply karte hain quant matrix se

                % DCT block ko proper jagah pe image mein place karte hain
                img((i-1)*8+1:i*8, (j-1)*8+1:j*8, ch) = dct_block;
            end
        end
    end

    % Ab poori image pe inverse DCT lagate hain har channel ke liye
    for ch = 1:channels
        img(:,:,ch) = idct2(img(:,:,ch));
    end

    % Values ko 0-255 ke darmiyan clamp karte hain aur uint8 mein convert karte hain
    img = uint8(min(max(img,0),255));  
end

%Flow Summary :
% encoded ke andar har 8x8 image block ki zigzag-ordered quantized DCT coefficients hote hain.
% 
% Har block ke:
% 
% Zigzag ko wapas normal 8x8 matrix banaya jaata hai (inv_zigzag).
% 
% Quantized matrix ko dequantize kiya jaata hai (.* quant_matrix()).
% 
% Ye DCT block image ke corresponding position par insert hota hai.
% 
% Har color channel ke liye inverse DCT apply kiya jaata hai.
% 
% Final image values ko 0–255 range mein clamp karke uint8 format mein convert kiya jaata hai.