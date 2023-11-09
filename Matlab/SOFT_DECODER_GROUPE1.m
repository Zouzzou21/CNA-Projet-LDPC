% n = 8;
% m = 4;
% iterations = 2;
% 
% C = [1, 0, 0, 0, 0, 1, 0, 1];
% P = [0.9332, 0.0098, 0.0538, 0.2117, 0.9999, 0.9995, 0.0090, 0.9997];
% Probas = P;
% 
% H = [
%     0, 1, 0, 1, 1, 0, 0, 1;
%     1, 1, 1, 0, 0, 1, 0, 0;
%     0, 0, 1, 0, 0, 1, 1, 1;
%     1, 0, 0, 1, 1, 0, 1, 0
% ];


function c_cor = SOFT_DECODER_GROUPE1(c_ds_flip, H, P1_ds, MAX_ITER)
    C = c_ds_flip';
    Probas = P1_ds;
    iterations = MAX_ITER;
%     fprintf('MESSAGE : %s\n', mat2str(C));
    for iter = 1:iterations
%         fprintf('  ITERATION : %d\n', iter);
%         fprintf('  Probas : %s\n', mat2str(Probas));
        Resultat = [];
        Traite = [];
        for ligne = 1:size(H,1)
            inter = [];
            for col = 1:size(H,2)
                if H(ligne, col) == 1
                    Traite = [Traite, col];
                    inter = [inter, Probas(col)];
                end
            end
%             fprintf('    Inter : %s\n', mat2str(inter));
            for i = 1:length(inter)
                BibouTarget = inter;
                BibouTarget(i) = [];
                Resultat = [Resultat, 1 - Bibou(BibouTarget)];
            end
%             fprintf('    Resultat : %s\n', mat2str(Resultat));
%             fprintf('    Traite : %s\n', mat2str(Traite));
        end
        for i = 1:length(C)
            Aboubou = [];
            for j = 1:length(Resultat)
                if i == Traite(j)
                    Aboubou = [Aboubou, Resultat(j)];
                end
            end
            Boubou(i, Aboubou, Probas);
        end
    end
    res = zeros(1, size(H,2));
    for i = 1:length(Probas)
        if Probas(i) > 0.5
            res(i) = 1;
        else
            res(i) = 0;
        end
    end
%     fprintf('%s ==> %s\n', mat2str(C), mat2str(res));
    c_cor = res';
    return
end

function res = Bibou(BibouTarget)
    inter = 1;
    for i = 1:length(BibouTarget)
        inter = inter * (1 - 2 * BibouTarget(i));
    end
    res = 0.5 + inter / 2;
end
    
function Boubou(i, Aboubou, Probas)
    pb1 = ProbaU(i, Aboubou, Probas);
    pb0 = ProbaZ(i, Aboubou, Probas);
    pb = pb1 + pb0;
    k = 1 / pb;
    Probas(i) = k * pb1;
end

function res = ProbaZ(i, Aboubou, Probas)
    inter = 1;
    for k = 1:length(Aboubou)
        inter = inter * Aboubou(k);
    end
    res = (1 - Probas(i)) * inter;
end

function res = ProbaU(i, Aboubou, Probas)
    inter = 1;
    for k = 1:length(Aboubou)
        inter = inter * Aboubou(k);
    end
    res = Probas(i) * inter;
end