function c_cor = SOFT_DECODER_GROUPE1(c_ds_flip, H, P1_ds, MAX_ITER)
    c_cor = c_ds_flip;
    if MAX_ITER == 1
        c_cor=(P1_ds<0.5);
        return
    end
 
%     fprintf("\n  ----  \n")
%     fprintf("c_ds_flip =\n")
%     disp(c_ds_flip)
%     fprintf("Hazdeaz =\n")
%     disp(H)
%     fprintf("MAX_ITER =\n")
%     disp(MAX_ITER)
%     fprintf("P1_ds =\n")
%     disp(P1_ds)    
    Hcopy = H;
 
    Hcopy = double(Hcopy);
 
    for i = 1:size(Hcopy,1)
        for j = 1:size(Hcopy,2)
            if Hcopy(i,j) ~= 0
               Hcopy(i,j) = P1_ds(j);
            end
        end
    end
 
    disp(P1_ds)
 
%     fprintf("Hcopy after for =\n")
% 
%     disp(Hcopy)
 
    Hcopycopy = Hcopy;
 
%     fprintf("Hcopycopy \n")
%     disp(Hcopycopy)
 
    for i = 1:4
        % Boucle 4 fois
        matrice = [];
        matrice = double(matrice);
        for j = 1:size(H,2)
            if isa(Hcopy(i,j),'double')
                matrice = [matrice,double(Hcopy(i,j))];
            end
        end
 
        matrice = matrice';
%         display(matrice(3))
 
        r = 1;
        for j = 1:size(H,2)
 
            if isa(Hcopy(i,j),'double') && Hcopy(i,j)
                resultat = 0;
                if r == 1
                    resultat = (1-2*matrice(2))*(1-2*matrice(3))*(1-2*matrice(4));
                end
                if r == 2
                    resultat = (1-2*matrice(1))*(1-2*matrice(3))*(1-2*matrice(4));
                end
                if r == 3
                    resultat = (1-2*matrice(1))*(1-2*matrice(2))*(1-2*matrice(4));
                end
                if r == 4
                    resultat = (1-2*matrice(1))*(1-2*matrice(2))*(1-2*matrice(3));
                end
                Hcopycopy(i,j) = 1 - (0.5 + 0.5*resultat);
                r = r+1;
            end
            disp(Hcopycopy)
        end
    end
 
%     disp(P1_ds)
 
    MAX_ITER = MAX_ITER -1;
    c_cor = SOFT_DECODER_GROUPEi(c_ds_flip, H, P1_ds, MAX_ITER);
 
%     c_cor = binary;
 
end