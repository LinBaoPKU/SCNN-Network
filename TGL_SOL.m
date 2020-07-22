run( '.\SCL_Train.m' );
Cross_Corr=[];
Time_Shift=[];

v_in_1=SCL_Out(:,1:3);
v_in_2=SCL_Out(:,4:6);

for i=1:12
    for j=1:3
        %Calculate Firing Probability Of N1/N2/N3
        p1=(21.19/(1+exp(-26.56*(v_in_1(i,j)-1.06)))+26.73)/50;
        %Spike Train Generation
        temp_pulse1=randsrc(1,50,[1,0;p1,(1-p1)]);
        %Mimiking WIRE OR Method To Combine All Spike Trains Together
        pulse_1(i,(j-1)*50+1:(j-1)*50+50)=temp_pulse1;
        
        %Calculate Firing Probability Of N4/N5/N6
        p2=(21.19/(1+exp(-26.56*(v_in_2(i,j)-1.06)))+26.73)/50;
        %Spike Train Generation
        temp_pulse2=randsrc(1,50,[1,0;p2,(1-p2)]);
        %Mimiking WIRE OR Method To Combine All Spike Trains Together
        pulse_2(i,(j-1)*50+1:(j-1)*50+50)=temp_pulse2;
    end
end
%Plot & Calculate The Cross Correlation
figure
for i=1:4
    subplot(4,1,i)
    stem(pulse_1(i,:));
end
figure
for i=1:3
    subplot(3,1,i)
    stem(pulse_2(1+4*(i-1),:));
end
figure
for i=1:4
    for j=1:3
        subplot(3,4,j+(i-1)*3)
        [Cross_Corr(j+(i-1)*3,:),Time_Shift(j+(i-1)*3,:)]=xcorr(pulse_1(j+(i-1)*3,:),pulse_2(j+(i-1)*3,:),'unbiased');
        bar(Time_Shift(j+(i-1)*3,:),Cross_Corr(j+(i-1)*3,:));
    end
end