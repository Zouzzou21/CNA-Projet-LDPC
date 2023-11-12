% LDPC SOFT DECODER
function corrected_code = SOFT_DECODER_GROUPE1(input_code_flip, parity_matrix, channel_probabilities, max_iterations)
    % Initialize variables
    received_code = input_code_flip'; % Transpose the input code for correct orientation
    beliefs = channel_probabilities;
    iterations = max_iterations;

    % Iterate through decoding process
    for iter = 1:iterations
        updated_beliefs = updateBeliefs(parity_matrix, beliefs);
        beliefs = updateDecodedBits(received_code, updated_beliefs, beliefs);
    end

    % Make final decision on corrected code
    corrected_bits = zeros(1, size(parity_matrix, 2));
    for i = 1:length(beliefs)
        corrected_bits(i) = (beliefs(i) > 0.5); % Thresholding to make the final decision
    end

    corrected_code = corrected_bits'; % Transpose back to the original orientation
end

% CHECK NODE (C NODE)
% Function to update beliefs based on parity matrix
function updated_beliefs = updateBeliefs(parity_matrix, beliefs)
    updated_beliefs = zeros(1, size(parity_matrix, 2));

    % Iterate through rows of the parity matrix
    for row = 1:size(parity_matrix, 1)
        selected_indices = find(parity_matrix(row, :) == 1);

        if ~isempty(selected_indices)
            selected_beliefs = beliefs(selected_indices);

            % Update beliefs for each selected index
            for i = 1:length(selected_beliefs)
                target_beliefs = selected_beliefs;
                target_beliefs(i) = [];
                updated_beliefs(selected_indices(i)) = 1 - calculateParity(target_beliefs);
            end
        end
    end
end

% VARIABLE NODE (V NODE)
% Function to update decoded bits based on result beliefs
function updated_decoded_bits = updateDecodedBits(received_code, result_beliefs, channel_beliefs)
    updated_decoded_bits = channel_beliefs;

    % Iterate through rows of the code matrix
    for i = 1:size(received_code, 1)
        selected_indices = find(received_code(i, :) == 1);

        if ~isempty(selected_indices)
            selected_result_beliefs = result_beliefs(selected_indices);
            updateChannel(i, selected_result_beliefs, channel_beliefs);
        end
    end
end

% Function to calculate the parity value
function result = calculateParity(target_beliefs)
    product = 1;

    % Multiply the factors for each belief
    for i = 1:length(target_beliefs)
        product = product * (1 - 2 * target_beliefs(i));
    end

    % Compute the final parity value
    result = 0.5 + product / 2;
end

% Function to update channel beliefs
function updateChannel(index, result_beliefs, channel_beliefs)
    prob_1 = calculateProbabilityU(index, result_beliefs, channel_beliefs);
    prob_0 = calculateProbabilityZ(index, result_beliefs, channel_beliefs);
    total_prob = prob_1 + prob_0;
    scaling_factor = 1 / total_prob;

    % Update the channel beliefs based on parity values
    channel_beliefs(index) = scaling_factor * prob_1;
end

% Function to calculate probability for Z
function prob_Z = calculateProbabilityZ(index, result_beliefs, channel_beliefs)
    product = 1;

    % Multiply the factors for each result belief
    for k = 1:length(result_beliefs)
        product = product * result_beliefs(k);
    end

    % Compute the final probability for Z
    prob_Z = (1 - channel_beliefs(index)) * product;
end

% Function to calculate probability for U
function prob_U = calculateProbabilityU(index, result_beliefs, channel_beliefs)
    product = 1;

    % Multiply the factors for each result belief
    for k = 1:length(result_beliefs)
        product = product * result_beliefs(k);
    end

    % Compute the final probability for U
    prob_U = channel_beliefs(index) * product;
end
