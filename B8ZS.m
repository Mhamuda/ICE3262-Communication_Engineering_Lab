%Bipolar with 8-zero substitution (B8ZS) :

clc;    %clear command line
clear all;  %clear variables
close all;  %clear figures

bits = [1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1];

%Modulation :

bitRate = 1;
voltage = 5;

samplingRate = 1000;
samplingTime=1/samplingRate;
endTime = length(bits)/bitRate;
time = 0:samplingTime:endTime;

modulation = zeros(1,length(time));
cnt = 0;
lastbit = voltage;

for i = 1:length(bits)
    if(bits(i)==0)
        cnt=cnt+1;
        if(cnt==8)  %000VB0VB
            modulation((i-1-7)*samplingRate+1:(i-7)*samplingRate)=0;
            modulation((i-1-6)*samplingRate+1:(i-6)*samplingRate)=0;
            modulation((i-1-5)*samplingRate+1:(i-5)*samplingRate)=0;
            modulation((i-1-4)*samplingRate+1:(i-4)*samplingRate)=lastbit;
            modulation((i-1-3)*samplingRate+1:(i-3)*samplingRate)=-lastbit;
            modulation((i-1-2)*samplingRate+1:(i-2)*samplingRate)=0;
            modulation((i-1-1)*samplingRate+1:(i-1)*samplingRate)=-lastbit;
            modulation((i-1-0)*samplingRate+1:(i-0)*samplingRate)=lastbit;
            lastbit=-lastbit;
            cnt=0;
        end
    else
        modulation((i-1)*samplingRate+1:i*samplingRate)=-lastbit;
        lastbit=-lastbit;
        cnt=0;
    end
end

plot(time,modulation,'LineWidth',3);
axis([0 endTime -voltage-5 voltage+5]);
grid on;

%Demodulation :

count = 0;
lastbit = voltage;

for i = 1:length(time)
    if(time(i)>cnt)
        cnt=cnt+1;
        if(modulation(i)==lastbit)
            demodulation(cnt:cnt+4)=0;
            cnt=cnt+4;
        else
            if(modulation(i)==0)
                demodulation(cnt)=0;
            else
                demodulation(cnt)=1;
                lastbit=-lastbit;
            end
        end
    end
end

disp(demodulation);