
function[bdv]=Normalization(raw)
num_bag=size(raw,1);
for m=1:num_bag 
    raw(m,:) = raw(m,:) / norm(raw(m,:));
end
bdv=raw;

