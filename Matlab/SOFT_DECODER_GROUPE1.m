function corrected_code = SOFT_DECODER_GROUPE1(input_code_flip, parity_matrix, channel_probabilities, max_iterations)
    % Initialize variables
    code = input_code_flip'; % Transpose the input code for correct orientation
    probabilities = channel_probabilities;
    iterations = max_iterations;
 
    % Iterate through decoding process
    for iter = 1:iterations
        updated_probabilities = updateProbabilities(parity_matrix, probabilities);
        probabilities = updateCodeBits(code, updated_probabilities, probabilities);
    end
 
    % Make final decision on corrected code
    corrected_bits = zeros(1, size(parity_matrix, 2));
    for i = 1:length(probabilities)
        corrected_bits(i) = (probabilities(i) > 0.5); % Thresholding to make the final decision
    end
 
    corrected_code = corrected_bits'; % Transpose back to the original orientation
end
 
% Function to update probabilities based on parity matrix
function updated_probs = updateProbabilities(matrix_H, probs)
    updated_probs = zeros(1, size(matrix_H, 2));
    
    % Iterate through rows of the parity matrix
    for row = 1:size(matrix_H, 1)
        selected_indices = find(matrix_H(row, :) == 1);
 
        if ~isempty(selected_indices)
            selected_probs = probs(selected_indices);
 
            % Update probabilities for each selected index
            for i = 1:length(selected_probs)
                target_probs = selected_probs;
                target_probs(i) = [];
                updated_probs(selected_indices(i)) = 1 - calculateFproba(target_probs);
            end
        end
    end
end
 
% Function to update code probabilities based on result probabilities
function updated_code_probs = updateCodeBits(code, result_probs, channel_probs)
    updated_code_probs = channel_probs;
 
    % Iterate through rows of the code matrix
    for i = 1:size(code, 1)
        selected_indices = find(code(i, :) == 1);
 
        if ~isempty(selected_indices)
            selected_result_probs = result_probs(selected_indices);
            calculateCproba(i, selected_result_probs, channel_probs);
        end
    end
end
 
% Function to calculate the F-nodes probabilities
function result = calculateFproba(target_probs)
    product = 1;
    
    % Multiply the factors for each probability
    for i = 1:length(target_probs)
        product = product * (1 - 2 * target_probs(i));
    end
 
    % Compute the final F-nodes probabilities
    result = 0.5 + product / 2;
end
 
% Function to update C-nodes probabilities
function calculateCproba(index, result_probs, channel_probs)
    prob_1 = calculateProbaU(index, result_probs, channel_probs);
    prob_0 = calculateProbaZ(index, result_probs, channel_probs);
    total_prob = prob_1 + prob_0;
    scaling_factor = 1 / total_prob;
 
    % Update the channel probabilities based on C-nodes probabilities
    channel_probs(index) = scaling_factor * prob_1;
end
 
% Function to calculate probability for Z
function prob_Z = calculateProbaZ(index, result_probs, channel_probs)
    product = 1;
 
    % Multiply the factors for each result probability
    for k = 1:length(result_probs)
        product = product * result_probs(k);
    end
 
    % Compute the final probability for Z
    prob_Z = (1 - channel_probs(index)) * product;
end
 
% Function to calculate probability for U
function prob_U = calculateProbaU(index, result_probs, channel_probs)
    product = 1;
 
    % Multiply the factors for each result probability
    for k = 1:length(result_probs)
        product = product * result_probs(k);
    end
 
    % Compute the final probability for U
    prob_U = channel_probs(index) * product;
end