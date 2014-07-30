function vn = normalize( v )

    magn = norm(v);
    if magn > 1e-8
       vn = v/magn; 
    else
       vn = zeros(size(v));
    end
end

