addpath('...\data\figure');
addpath('...\data\musk');
data_type=[1 2 3 4 5 6];
% You can choose the distance operators
% The default one is the combination of six operator
K=[2 2 2 2 2 2];
% You can choose the parameter k for each operator
 clear d
 clear bdv
inputname = 'musk1.mat';
% You can choose different dataset ,  "musk1", "musk2", "elephant", "fox" 
% "tiger".
load(inputname);
num_bag = size(data,1);
str = 'musk1_Index.mat'; 
% The different ".mat" files is related to different index files.
% "musk1_Index" is used for the musk1 data set. "musk2_Index" is used for musk2 
% The other image benchmark data sets,Elephant, Fox, and Tiger, share the
% "figure_testIndex" index files.
load(str);
%%
type_Index=data_type;
num_type=size(type_Index,2);
num_fold = 10;
num_CV = 10;
acc = zeros(num_fold,num_CV);
trainTime = zeros(num_fold,num_CV);
testTime = zeros(num_fold,num_CV);
for i = 1 : num_fold
    for j = 1 : num_CV
        tic
        cur_testIndex = testIndex((i-1)*num_CV+j,:);
        cur_trainIndex = 1:num_bag;
        cur_trainIndex(cur_testIndex) = [];
        num_train_bag = size(cur_trainIndex,2);
        num_test_bag = size(cur_testIndex,2);
       
        % Convert data into BRV format
        labels = zeros(num_bag,1);       
        for ii=1:num_bag
            labels(ii) = data{ii,2};
            for jj=1:num_type
                d{jj}(ii,:)=ExtractBrv(data,ii,type_Index(jj),K(jj));
            end 
        end
        
        % Combine the feature vectors of different operators
        bdv=[];
        for iii=1:num_type
               bdv=[bdv,Normalization(d{iii})];
        end
        
        bdv=Normalization(bdv);
        minv = min(bdv(cur_trainIndex,:));
        maxv = max(bdv(cur_trainIndex,:)) - minv;
        maxv = 1./maxv;
        bdv = (bdv -repmat(minv,num_bag,1)) .* repmat(maxv,num_bag,1);
        bdv(isnan(bdv))=0;

        bdv = sparse(bdv);
        
        % Train and Test
        model = train(labels(cur_trainIndex),bdv(cur_trainIndex,:),'-s 3 -c 5  -B -1 -q');      
        trainTime(i,j) = toc;
        tic
        [pred_label, accuracy, dec_val] = predict(labels(cur_testIndex),bdv(cur_testIndex,:),model);
        testTime(i,j) = toc;
        acc(i,j) = accuracy(1);
    end
end
acc = acc./100;
disp(' ');
disp(['The results of the ' inputname(1:(strfind(inputname,'.')-1)) ' data set are as follows:']);
disp(['Accuracy = ',num2str(mean(mean(acc))),'¡À',num2str(std(acc(:)))]);
disp(['TrainingTime = ',num2str(mean(mean(trainTime))),'¡À',num2str(std(trainTime(:)))]);
disp(['TestTime = ',num2str(mean(mean(testTime))),'¡À',num2str(std(testTime(:)))]);

