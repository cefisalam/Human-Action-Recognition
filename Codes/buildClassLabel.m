function [ trainClass ] = buildClassLabel(name )

% defining the labels of the clusters

     if contains(name,'handclapping')
         trainClass = 2;
     elseif contains(name,'boxing')
         trainClass = 1;
     elseif contains(name,'handwaving')
         trainClass = 3;
     elseif contains(name,'running')
         trainClass = 5;
     elseif contains(name,'jogging')
         trainClass = 4;
     elseif contains(name,'walking')
         trainClass = 6;
     end

end

