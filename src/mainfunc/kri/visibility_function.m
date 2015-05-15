%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
%|                                                                         |
%| The visibility function                                                 |
%| -= [W] = is_visibility(PointTable)                                      |
%|                                                                         |
%| Input: A 2D-pointTable that is (N, 2P), N is amount of views            |
%|                                        P is amount of 2D-points.        |
%|        Ex: There is 300 2D-points                                       |
%|            There is 10 camera views                                     |
%|            The PointTable should be size(PointTable) -> [10 600]        |
%|                                                                         |
%|        THE POINTTABLE NEEDS TO BE in the following structure:           |
%|                 Ex: [ x11 y11 x12 y12 ... ... x1P y1P;                  |
%|                       x21 y21 x22 y22 ... ... x2P y2P;                  |
%|                        |   |   |   |  ... ...  |   | ;                  |
%|                       xN1 yN1 xN2 yN2 ... ... xNP yNP ];                |
%|        This is described why in IREG, Section 12.3.2 by Klas Nordberg   |
%|                                                                         |
%| Output: W that is (N,2P) but only consists of ones (if visible) and     |
%| zeros (if not visible).                                                 |
%|                                                                         |
%| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |

function [W] = visibility_function(PointTable)

    % If the position is equal to [-1; -1] it means that the point is not
    % visible in this view.
    W = PointTable > 0;
    
end