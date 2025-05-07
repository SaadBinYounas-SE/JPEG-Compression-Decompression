function Q = quant_matrix()
    % Ye function ek standard JPEG quantization matrix return karta hai
    % Ye matrix DCT coefficients ko compress karne ke liye use hoti hai
    % Is matrix ke andar values zyada hone ka matlab hai uss frequency pe kam importance

    Q = [16 11 10 16 24 40 51 61;
         12 12 14 19 26 58 60 55;
         14 13 16 24 40 57 69 56;
         14 17 22 29 51 87 80 62;
         18 22 37 56 68 109 103 77;
         24 35 55 64 81 104 113 92;
         49 64 78 87 103 121 120 101;
         72 92 95 98 112 100 103 99];
    %Ye function ek fixed 8x8 matrix return karta hai jo JPEG compression mein DCT matrix ko 
    % divide karne ke liye use hota hai. Zyada values wale cells compress zyada karte hain.
end