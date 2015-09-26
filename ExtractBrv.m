% function [bdv]=ExtractBdv(data,ii,type)
% % for ii = 1:num_bag
% num_bag=size(data,1);
% K=1;
% minbdv=zeros(1,num_bag);
%  for jj=1:num_bag
%      asbdv=sort(pdist2(data{ii,1},data{jj,1}),2,'ascend');
%      %desbdv=sort(pdist2(data{ii,1},data{jj,1}),2,'descend');
%       if K>size(asbdv,2)
%          minbdv(1,jj)=min(mean(asbdv(:,1:size(asbdv,2))));
%         %maxbdv(ii,jj)=max(mean(asbdv(:,1:size(asbdv,2))));
%       else
%           minbdv(1,jj)=min(mean(asbdv(:,1:K)));
%         % maxbdv(ii,jj)=max(mean(asbdv(:,1:K)));
%       end
%  end
%  bdv=minbdv;
function [bdv]=ExtractBdv(data,ii,type,K)
% for ii = 1:num_bag
num_bag=size(data,1);
minbdv=zeros(1,num_bag);
%Std=zeros(1,num_bag);
 for jj=1:num_bag
     if type<=3
        sortbdv=sort(pdist2(data{ii,1},data{jj,1}),2,'ascend');
     else
        sortbdv=sort(pdist2(data{ii,1},data{jj,1}),2,'descend');
     end
      if K>size(sortbdv,2)
         %temp=mean(sortbdv(:,1:size(sortbdv,2)));
         temp=mean(sortbdv(:,1:size(sortbdv,2)),2);
      else
         %temp=mean(sortbdv(:,1:K));
         temp=mean(sortbdv(:,1:K),2);
      end
      %Std(jj)=std(temp);
        switch type
          case{1,4}
              minbdv(1,jj)=min(temp);
          case{2,5}
              minbdv(1,jj)=mean(temp);
          case{3,6}
              minbdv(1,jj)=max(temp);
        end
 end
 bdv=minbdv;
            

