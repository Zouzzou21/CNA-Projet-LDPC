% Léo BONNAIRE
% Léonard PRINCÉ
% Lucas LANDY
% Étienne CAMBRAY-LAGASSY
% Alan JUMEAUCOUR
% LDPC SOFT DECODER
function c_cor = SOFT_DECODER_GROUPE1(c, H, p, MAX_ITER)

    [h_rows, h_cols] = size(H);
    c_cor = c;
    
    % Create vectors full of ones to later hold the layer inputs
    inputs = ones(h_rows, h_cols);
    outputs = ones(h_rows, h_cols);
    
    % Initialise c_node_in with APP (a posteriori probabilities)
    for i = 1:h_rows
        for j = 1:h_cols
            if H(i, j)
                inputs(i, j) = p(j);
            end
        end
    end
    
    % Note that some values in the inputs kept the values 1
    % Only the linked nodes were filled with APP
    
    for iter = 1:MAX_ITER
        % Realise the following a certain amount of iterations
        % The amount of iterations is the only stopping condition for the
        % soft decoder. It is impossible to have a equivalent to the parity
        % condition used in the hard decoder ...
        
        for i = 1:h_rows
            for j = 1:h_cols
                
                % Compute the product of every row
                total_products = prod(1 - 2 * inputs, 2);
                
                % This products simplifies the amount of calculations we'll
                % need to do. In fact, every factors in the row
                % multiplication except itself. Hence, the factors are the
                % row product ... divided by themself :
                
                % Divide the preceding product by the current value
                % ... And set it to be the input of the v-nodes
                outputs(i, j) = 0.5 + 0.5 * (total_products(i) / (1 - 2*inputs(i, j)));
                
            end
        end
        
        % At this point, the inputs for the v-nodes are ready;
        % So it's time to rebuild the v-nodes inputs from now on.
        
        for j = 1:h_cols  % do for every v-node, knowing there's h_cols v-nodes
            
            % Extract the colunm we're working in
            col = outputs(:, j);
            % and compute the products, as we did earlier
            total_products = prod(outputs, 1);
            
            % Compute first but wrong values of q1 and q2 ...
            q1 = (1 - p(j)) * total_products(j);
            q2 = p(j) * prod(nonzeros(1 - col), 1);
            % ... These values do not take the K factor into account.
            % If left that way, it will lead to a slow probability
            % deperdition
            
            % The goal of K is to make the sum of q1 and q2 to one.
            % Hence, to compute K, we use the following formula :
            K = 1 / (q1 + q2);
            
            % And now, we can update q1 and q2 we the correct values
            q1 = K * q1;
            q2 = K * q2;
            % Now, we can compare q1 and q2 to determine if the bit held by
            % the v-node if a 0 or a 1
            if q1 < q2
                c_cor(j) = 1;
            else
                c_cor(j) = 0;
            end
            
            % In fact, it was not usefull to compute the K factor here,
            % since the only operation made on q1 and q2 were their
            % comparison. 
            % Let's say that we did it for the beauty of the gesture.
            
            % Even though the value of the code has been updated, the
            % trip's not over yet. We still need to update the next inputs
            % for the c-nodes
            
            for i = 1:h_rows
               
                % The process is similar but still differs
                % The computations are quite the same but takes place in
                % different spot and have different ends
                
                % We should re-compute the values of q1 and q2 together
                % with the K factor, but the given connection this time,
                % not for the whole v-node. The only difference, is the
                % division of the total products by the received input, as
                % explained previously for the c-node
                q1_link = (1 - p(j)) * total_products(j) / outputs(i, j);
                q2_link = p(j) * prod(nonzeros(1 - col), 1) / (1 - outputs(i, j));
                
                % Re-compute the K factor for the link ...
                K_link = 1 / (q1_link + q2_link);
                
                % ... and finally update with the correct values
                inputs(i, j) = K_link * q1_link;
                
                % NOTE : For the sake of simplicity, we directly assign the
                % correct q1_link to the c_node_in matrix but multiplying
                % by the K factor
            end
            
        end
        
        % Now is the time to check wheter the newly obtained c fulfills the
        % partity condition.
        % It it fits, the iterations stops. Otherwise, they continue until
        % they reach MAX_ITER
        
        if parity_check(c_cor, H) == 1
            return
        end
        
    end
    
end


function parity_fulfilled = parity_check(c, H)

    [h_rows, h_cols] = size(H);
    
    % h_rows is the amount of check nodes
    % h_cols is the amount of variable nodes
    
    
    % Define a vector to holds parity information amoung the rows of H
    h_row_evenness = zeros(h_rows, 1);
    for i = 1:h_rows
        row_even = 0;
        for j = 1:h_cols
            if H(i, j)  == 1
                
                % For every link, verify that the bit of c stays even
                row_even = mod(row_even + c(j), 2);
                
            end
        end
        h_row_evenness(i) = row_even;    
    end
    
    % Now, sum the row evenness to globally verify the condition
    if sum(h_row_evenness) == 0
        parity_fulfilled = 1;
    else
        parity_fulfilled = 0;
    end

end