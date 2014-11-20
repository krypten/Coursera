function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

	for iter = 1:num_iters

	    % ====================== YOUR CODE HERE ======================
	    % Instructions: Perform a single gradient step on the parameter vector
	    %               theta. 
	    %
	    % Hint: While debugging, it can be useful to print out the values
	    %       of the cost function (computeCost) and gradient here.
	    %
	    J1 = 0;
	    J2 = 0;
	    for i = 1:m,
	        J1 = J1 + ((theta(1) + X(i, 2) * theta(2)) - y(i)) * X(i, 1) ;
	    end;
	    J1 = J1/(m);

	    for i = 1:m,
	        J2 = J2 + ((theta(1) + X(i, 2) * theta(2)) - y(i)) * X(i, 2) ;
	    end;
	    J2 = J2/(m);

	    theta(1) = theta(1) - alpha * J1;
	    theta(2) = theta(2) - alpha * J2;



	    % ============================================================

	    % Save the cost J in every iteration    
	    J_history(iter) = computeCost(X, y, theta);

	end;

end;
