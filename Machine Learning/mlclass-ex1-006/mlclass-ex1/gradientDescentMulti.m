function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y) % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters,

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCostMulti) and gradient here.
    %
    n = size(theta, 1);
    J = zeros(1, n);

    for j =1:n,
        for i = 1:m,
            J(j) = J(j) + (sum(theta' .* X, 2)(i) - y(i)) * X(i, j) ;
        end;
        J(j) = J(j)/(m);
    end;

    for j =1:n,
        theta(j) = theta(j) - alpha * J(j);
    end;



    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCostMulti(X, y, theta);

end;

end;
