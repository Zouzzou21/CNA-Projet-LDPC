function c_cor = HARD_DECODER_GROUPE1(c, H, MAX_INTER)
    c_cor = c;
    if MAX_INTER == 1
        return
    end
%     fprintf("\n  ----  \n")
%     fprintf("c =\n")
%     disp(c)
%     fprintf("H =\n")
%     disp(H)
%     fprintf("MAX_INTER =\n")
%     disp(MAX_INTER)
    Hcopy = H;
%     fprintf("Hcopy =\n")
%     disp(Hcopy)
%     disp(c')
    for i = 1:size(Hcopy,1)
        for j = 1:size(Hcopy,2)
            if Hcopy(i,j) == 1
               Hcopy(i,j) = c(j);
            end
        end
    end
%     fprintf("Hcopy after for =\n")
%     disp(Hcopy)
    matrice = [0,0,0,0];
    for i = 1:size(Hcopy,1)
        somme = 0;
        for j = 1:size(H,2)
            somme = somme + Hcopy(i,j);
        end
        matrice(i) = somme;
    end 
    Hcopycopy = Hcopy;
    for i = 1:size(H,1)
        for j = 1:size(H,2)
            if H(i,j) == 1
               Hcopycopy(i,j) = mod((matrice (i) - c(j)),2);
            end
        end
    end
%     disp(Hcopycopy)
    if Hcopycopy == Hcopy
%         fprintf('OKKKK')
        c_cor = c;
        return
    end
    for i = 1:size(Hcopycopy,1)
        sommesomme = 0;
        for j = 1:size(H,2)
            sommesomme = sommesomme + Hcopycopy(i,j);
        end
        if sommesomme/4 > 0.5
            c(i) = 1;
        else
            c(i) = 0;
        end
    end
    MAX_INTER = MAX_INTER -1;
    c_cor = HARD_DECODER_GROUPE1(c, H, MAX_INTER);
    return
end