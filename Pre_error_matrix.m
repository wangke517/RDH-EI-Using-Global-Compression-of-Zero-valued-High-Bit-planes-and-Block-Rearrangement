function [error_matrix, error_sign_label] = Pre_error_matrix(cover)
[m, n] = size(cover);
error_matrix = cover;
error_sign_label = zeros(1,m*n-1);
for i = 1:m
    for j = 1:n
        if i == 1 && j == 1
            continue;
        end
        if i == 1
            error = cover(i, j-1) - cover(i, j);
        elseif j == 1
            error = cover(i-1, j) - cover(i, j);
        else
            a = cover(i-1, j-1);
            b = cover(i-1, j);
            c = cover(i, j-1);
            if a <= min(b, c)
                predict_value = max(b, c);
            elseif a >= max(b, c)
                predict_value = min(b, c);
            else
                predict_value = b + c - a;
            end
            error = predict_value - cover(i, j);
        end
        if error < 0
                error_sign_label(1,(i-1)*n+j-1) = 1;
        end
        error_matrix(i, j) = abs(error);
    end
end
error_matrix(1, 1) = 0;
end

