%% LDPC_STUDENT_TEST_SCRIPT.m
% =========================================================================
% *Author:* Lélio CHETOT, *Date:* 2023, October 31 🎃
% =========================================================================
% This script provides the students with an automated process to test their
% decoders from a dataset.
%
% The script will load the dataset, extract the codewords and run the
% hard and soft decoders.
%
% Then, some comparisons are made between:
% - the corrected codewords obtained by the students and the true
% (error-free) codewords;
% - the corrected codewords obtained by the students and the corrected
% codewords obtained by the reference decoders.
%
% It is important to understand that this script does not test the BER of
% the decoders and so, even if all the comparison tests pass, it does not
% necessary mean that the decoders are correctly implemented.
% =========================================================================
clear all;
close all;
clc;

% Load dataset
loaded_data = load('student_dataset.mat');
dataset = loaded_data.subdataset;
N_data = length(dataset(:, 1, 1));

% Parity check matrix
H = logical([
        0 1 0 1 1 0 0 1; 
        1 1 1 0 0 1 0 0;
        0 0 1 0 0 1 1 1;
        1 0 0 1 1 0 1 0
    ]);

% Maximum number of iterations
MAX_ITER = 1000;

% Loop for the tests
fprintf('+--------------------------------------------------------------------------------------------------------------------------+\n')
fprintf('| Tests\t|\tTrue == Flip\t|\tTrue == Hard\tTrue == Hard\t|\tHard == Hard (ref)\tSoft == Soft (ref) |\n')
fprintf('+--------------------------------------------------------------------------------------------------------------------------+\n')
for n = 1:N_data
    fprintf('| %5d\t|\t', n)
    % Data
    data = squeeze(dataset(n, :, :));
    
    % Extract the codewords and probabilities
    c_ds_true = logical(data(:, 1));    % True codeword
    c_ds_flip = logical(data(:, 2));    % Flipped codeword (some of them may be identical to the true codeword)
    c_ds_hard = logical(data(:, 3));    % Hard decoded codeword (some of them were incorrectly decoded)
    c_ds_soft = logical(data(:, 4));    % Soft decoded codeword (some of them were incorrectly decoded)
    P1_ds = data(:, 5);                 % Probability such that P1(i) == P(c_flip(i) == 1 | y(i))
    
    % Run the decoders
    % Replace i with your group number.
    c_hard = HARD_DECODER_GROUPE1(c_ds_flip, H, MAX_ITER);
    c_soft = SOFT_DECODER_GROUPE1(c_ds_flip, H, P1_ds, MAX_ITER);
    %c_soft = SOFT_DECODER_EXEMPLE(c_ds_flip, H, P1_ds, MAX_ITER);
    
    % Comparison with the flipped codeword
    fprintf('%12s\t|\t', string(isequal(c_ds_true , c_ds_flip)))

    % Comparison with the true codeword
    % If they return 1, the two vectors are equal.
    fprintf('%12s\t', string(isequal(c_ds_true, c_hard)))
    fprintf('%12s\t|\t', string(isequal(c_ds_true, c_soft)))
    
    % Comparison with corrected data form the dataset
    % If they return 1, the two vectors are equal.
    fprintf('%18s\t', string(isequal(c_hard, c_ds_hard)))
    fprintf('%18s |\n', string(isequal(c_soft, c_ds_soft)))
end

fprintf('+--------------------------------------------------------------------------------------------------------------------------+\n')