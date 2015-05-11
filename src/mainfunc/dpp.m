% The distance function

function r = dpp(vars, N_VIEWS, Xt)

    % 3D positions
    Np = size(Xt,2);
    X = reshape(vars(((1+N_VIEWS)*12):end),[3 Np]);
    r = 0; 

    for m = 1:N_VIEWS
       Rt = reshape(vars(1+((m-1)*12):12+((m-1)*12)),[3 4]);
       Xtk = Xt(:,:,m);
       Wk = is_visibility(Xtk);
       Xtk = Xtk.*Wk;
       Xtp = Rt*[X;ones(1,Np)];

       r = r + sqrt((Xtk(1,:)-Xtp(1,:)./Xtp(3,:)).^2+(Xtk(2,:)-Xtp(2,:)./Xtp(3,:)).^2);
    end

end