run( '.\Training_Set_Gene.m' );

%The Output Vector Of SCL
SCL_Out=[];

N          = 10000; %Training Epoch
sam_sum    = 600;   %Training Sample Number
lambda     = 0.0000;%L2 Norm

%Four Layer Network
input  = 9;
output = 6;
hid1   = 8;
hid2   = 7;

%Parameter Initialization
w1 =0.1*randn([hid1,input]);
w2 =0.1*randn([hid2,hid1]);
w3 =0.1*randn([output,hid2]);
bias1 =0.1*randn(hid1,1);
bias2 =0.1*randn(hid2,1);
bias3 =0.1*randn(output,1);

%Learning Rate
rate1 =0.01;
rate2 =0.01;
rate3 =0.01;

%Temp Variables
net1 = zeros(hid1,1);
net2 = zeros(hid2,1);
z = zeros(output,1);


training_temp=training;

%Randomrize The Training Set
rowrank=randperm(size(training,1));
training=training(rowrank,:);
count_temp=1;

%Training 
for num = 1:N 
    for i = 1:length(training)
        train_x=training(i,1:9)';
        train_y=training(i,10:15)';
        
        %Forward
        net1  = relu(w1*train_x + bias1);
        net2  = relu(w2*net1 + bias2);
        z     = w3*net2 + bias3;
        error = train_y - z;

        %Backward
        delta_Z    = error;
        delta_net2 = ((net2>=0)+0.1*(net2<0)).*(w3'*delta_Z);
        delta_net1 = ((net1>=0)+0.1*(net1<0)).*(w2'*delta_net2);

        delta_w3 = delta_Z * net2';
        delta_w2 = delta_net2 * net1';
        delta_w1 = delta_net1 * train_x';

        w1 = (1-lambda*rate1/num)*w1 + rate1*delta_w1;
        w2 = (1-lambda*rate2/num)*w2 + rate2*delta_w2;
        w3 = (1-lambda*rate3/num)*w3 + rate3*delta_w3;

        bias1 = (1-lambda*rate1/num)*bias1 + rate1*delta_net1;
        bias2 = (1-lambda*rate2/num)*bias2 + rate2*delta_net2;
        bias3 = (1-lambda*rate3/num)*bias3 + rate3*delta_Z;

    end
   
    %Calculate The Error
    if(mod(num,20)==0)
        count=0;
        parfor i = 1:length(training_temp)
            test_ima = training_temp(i,1:9)';
            %forward
            net1  = relu(w1*test_ima + bias1);
            net2  = relu(w2*net1 + bias2);
            z     = w3*net2 + bias3;
            z_temp(i,:)=z;
            count=count+norm(z-training_temp(i,10:15)');    
        end
        total_error(count_temp,1)=count/length(training_temp);
        count_temp=count_temp+1;
        fprintf("Total Error£º%f\n ",total_error);
    end 
    h_wait=waitbar(num/N);
end
close(h_wait);

%Output & Plot
subplot(1,3,1)
for i=1:4
    SCL_Out(i,:)=z_temp(1+(i-1)*50,:);
    plot(SCL_Out(i,:));
    hold on;
end
subplot(1,3,2)
for i=5:8
    SCL_Out(i,:)=z_temp(1+(i-1)*50,:);
    plot(SCL_Out(i,:));
    hold on;
end
subplot(1,3,3)
for i=9:12
    SCL_Out(i,:)=z_temp(1+(i-1)*50,:);
    plot(SCL_Out(i,:));
    hold on;
end

%Activation Function
function output = relu(x)    
    output = max(0,0.9*x)+0.1*x;
end
