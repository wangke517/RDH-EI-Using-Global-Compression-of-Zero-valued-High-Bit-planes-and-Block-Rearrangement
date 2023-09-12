function [recoverImg] = Recover_error_matrix(error_matrix, error_sign_label)
[m, n] = size(error_matrix);
recoverImg = error_matrix;
index = 0;
for i = 1:m
    for j = 1:n
        if i == 1 && j == 1
            continue;
        end
        index = index + 1;
        error_sign = error_sign_label(index);
        error = error_matrix(i,j);
        if error_sign == 1
            error = -error;
        end
        if i == 1
            recoverImg(i,j) = recoverImg(i,j-1) - error;
        elseif j == 1
            recoverImg(i,j) = recoverImg(i-1,j) - error;
        else
            a = recoverImg(i-1, j-1);
            b = recoverImg(i-1, j);
            c = recoverImg(i, j-1);
            if a <= min(b, c)
                predict_value = max(b, c);
            elseif a >= max(b, c)
                predict_value = min(b, c);
            else
                predict_value = b + c - a;
            end
            recoverImg(i,j) = predict_value - error;
        end
    end
end
end

