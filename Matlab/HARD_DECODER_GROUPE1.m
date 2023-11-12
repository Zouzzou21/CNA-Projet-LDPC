function c_cor = HARD_DECODER_GROUPE1(c, H, MAX_INTER)
    % Initialize corrected codeword as the input codeword
    c_cor = c;
    
    % If MAX_INTER is 1, return without further decoding
    if MAX_INTER == 1
        return
    end
    
    % Make a copy of matrix H for manipulation
    Hcopy = H;
    
    % Iterate through each element of Hcopy
    for i = 1:size(Hcopy,1)
        for j = 1:size(Hcopy,2)
            % Replace 1s in Hcopy with corresponding elements from codeword c
            if Hcopy(i,j) == 1
               Hcopy(i,j) = c(j);
            end
        end
    end
    
    % Calculate the syndrome matrix
    matrice = sum(Hcopy, 2);
    
    % Make another copy of Hcopy for further manipulation
    Hcopycopy = Hcopy;
    
    % Update Hcopycopy based on syndrome values
    for i = 1:size(H,1)
        for j = 1:size(H,2)
            if H(i,j) == 1
               Hcopycopy(i,j) = mod((matrice(i) - c(j)), 2);
            end
        end
    end
    
    % If the updated Hcopycopy is the same as the original Hcopy, no errors were found
    if isequal(Hcopycopy, Hcopy)
        c_cor = c; % Return the original codeword
        return
    end
    
    % Perform majority voting to correct errors
    for i = 1:size(Hcopycopy,1)
        sommesomme = sum(Hcopycopy(i, :));
        % If more than half of the bits are 1, set the corresponding bit in the codeword to 1
        if sommesomme / 4 > 0.5
            c(i) = 1;
        else
            c(i) = 0; % Otherwise, set it to 0
        end
    end
    
    % Recursively call the decoder with the updated codeword and reduced MAX_INTER
    MAX_INTER = MAX_INTER - 1;
    c_cor = HARD_DECODER_GROUPE1(c, H, MAX_INTER);
    return
end
