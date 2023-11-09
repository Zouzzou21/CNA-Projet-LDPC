function c_cor = SOFT_DECODER_GROUPE1(c_ds_flip, H, P1_ds, MAX_ITER)

    % [c_rows, c_cols] = size(c_ds_flip);
    [h_rows, h_cols] = size(H);
    
    c_node_in = 1 * ones(h_rows, h_cols);
    v_node_in = 1 * ones(h_rows, h_cols);
    
    % Initialise c_node_in with APP (a posteriori probabilities)
    
    for i = 1:h_rows
        for j = 1:h_cols
            if H(i, j)
                c_node_in(i, j) = P1_ds(j);
            end
        end
    end
    
    for iter = 1:MAX_ITER
        for i = 1:h_rows
            for j = 1:h_cols
                % Compute the product of every row
                total_products = prod(1-2*c_node_in, 2);
                
                % Divide the preceding product by the current value
                c_node_out(i, j) = 0.5 + 0.5 * (total_products(i) / (1 - 2*c_node_in(i, j)));
            end
        end
    end

end
