function zz = zigzag(block)
    % Ye function 8x8 block ko zigzag order mein convert karta hai
    % Zigzag ka matlab hai top-left se start kar ke low frequency se high frequency tak jaana
    ind = [1  2  6  7 15 16 28 29;
           3  5  8 14 17 27 30 43;
           4  9 13 18 26 31 42 44;
          10 12 19 25 32 41 45 54;
          11 20 24 33 40 46 53 55;
          21 23 34 39 47 52 56 61;
          22 35 38 48 51 57 60 62;
          36 37 49 50 58 59 63 64];
    % ab block ke andar se values is zigzag order ke mutabiq le kar ek 1D vector banate hain
    zz = block(ind);
    %Zigzag pattern low-frequency se high-frequency values extract karta hai. Iska fayda ye
    % hai ke baad mein Run-Length Encoding zyada effective hoti hai.
end