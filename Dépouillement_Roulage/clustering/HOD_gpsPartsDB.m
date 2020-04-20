% list of HOD POI gps positions
% A13 :
gpsPOI = [
          49.248101, 1.190363, {'D6015'};
          49.139538, 1.316935, {'D6015'};
          49.131971, 1.317207, {'A13'};
          49.023213, 1.496007, {'A13'};
          49.021583, 1.498501, {'N13'};
          49.015213, 1.197049, {'N13'};
          49.018098, 1.191267, {'B154'};
          49.237811, 1.186242, {'N154'};
          ];
[xPOI,yPOI,utmZone] = deg2utm([gpsPOI{:,1}]',[gpsPOI{:,2}]');
indexes = zeros(size(xGPS));
currIndex = 1; % We start on D6015
for i = 1:size(indexes,1)
    switch currIndex
        case 1 % We are on D6015
            if yGPS(i)<yPOI(2) % Below the end of D6015
                currIndex = 1.5; % between D6015 and A13
            end
        case 1.5 % We are between D6015 and A13
            if yGPS(i) < yPOI(3) % Below beginning of A13
                currIndex = 2; % on A13
            end
        case 2 % We are on A13
            if xGPS(i) > xPOI(4) % Below end of A13
                currIndex = 2.5; % Between A13 and N13
            end
        case 2.5 % We are between A13 and N13
            if yGPS(i) < yPOI(5) % Below beginning of N13
                currIndex = 3;
            end
        case 3 % We are on N13
            if  xGPS(i) < xPOI(6) % left to the end of N13
                currIndex = 3.5;
            end
        case 3.5 % We are between N13 and N154
            if yGPS(i) > yPOI(7) % Above beginnig of N154
                currIndex = 4;
            end
        case 4 % We are on N154
            if yGPS(i) > yPOI(8) % Above end of N154
                currIndex = 4.5;
            end
        case 4.5
            if xGPS(i) > xPOI(1) % right to beginning of D6015
                currIndex = 1;
            end
    end
    indexes(i) = currIndex;
end

%% Plot Part
plot(xGPS,yGPS)
axis equal
hold on
grid minor

indD6015 = find(indexes == 1);
indA13   = find(indexes == 2);
indN13   = find(indexes == 3);
indN154  = find(indexes == 4);

plot(xGPS(indD6015),yGPS(indD6015),'LineStyle','--','Color',[0.0431 0.7922 0.0157],'LineWidth',1);
plot(xGPS(indA13),yGPS(indA13),'Color',[0.7216 0.0549 0.0118],'LineWidth',1);
plot(xGPS(indN13),yGPS(indN13),'Color',[1      0.7843 0.1137],'LineWidth',1);
plot(xGPS(indN154),yGPS(indN154),'Color',[0 0 1],'LineWidth',1);