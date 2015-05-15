function [correct_case] = test_rt_direction(R, t, X, RDirection, tDirection, type)

correct_case = false;

X2 = R(:,:,RDirection)*X + t(:,tDirection);
is_homogeneous
% On one of the four cases, we get a point
% infront of our cameras. Save the Rt for that case.
fprintf(type);
fprintf('X(3) = %f \n', X(3));
fprintf('X2(3) = %f \n', X2(3));
fprintf('======================== \n');
if (X(3) > 0) && (X2(3) > 0)
    correct_case = true;
end

% assert(correct_case == true, 'Not correct R and t (Should generate: x3 > 0 and xprim3 > 0)');

end