pointsTable = load_dino_2dpts_gt();
K = calibrate_camera('blabla', 'bavkbak');
[corrPts1, corrPts2] = get_correspondces(1,2,pointsTable);

E = estimate_essential_matrix(corrPts1, corrPts2, K);



error = corrPts1'*E*corrPts2