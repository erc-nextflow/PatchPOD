function [U, S, V] = randomizedSVD(A, k,ov)
    % A: Input matrix (m x n)
    % k: Target rank
    % ov: oversampling parameter
    
    [m, n] = size(A);
    
    % Generate a random matrix
    R = randn(n, k+ov);
    
    % Form the sketched matrix
    Y = A * R;
    
    % Perform QR decomposition on the sketched matrix
    [Q, ~] = qr(Y, 0);
    
    % Compute the SVD of the smaller matrix B = A' * Q
    [U_tilde, S, V] = svd(Q' * A, 'econ');
    
    % Approximate the left singular vectors of A
    U = Q * U_tilde;
end
