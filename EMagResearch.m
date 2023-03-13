clc;
clear;

%Initialize Message Parameters
mB = ("01011"); %The message
mD = bin2dec(mB); %Convert our message to a decimal
kM = 2;

%Initialize Clutter Parameters
lC = 3;
kC = 2;

%Clutter and Noise Multipliers to be Iterated Over
clutter = linspace(25,0.01,100);
noise = linspace(25,0.01,100);

%Initialize Arrays to Hold Data
SCR_AVG = zeros(1,100);
SNR_AVG = zeros(1,100);
error = zeros(1,100);
error2 = zeros(1,100);

%Generate Weibull Distribution sing decimal message as lambda
M = wblrnd(mD,kM,1,100);

%Check different SCR values
count = 1;
while count <= 100
    loop = 1;
    ER = 0;
    SCR = 0;
    
    %Iterate each SCR value 1000 times and average
    while loop <= 1000
        C = wblrnd(lC,kC,1,100); %Generate clutter
        N = randn(1,100)+1; %Generate noise
        
        Cs = wblrnd(lC,kC,1,100); %Clutter "samples" at reciever
        Ns = randn(1,100)+1; %Noise "samples" at receiver
        
        %Calcualte PDF of combined signal
        [TX,x] = ksdensity(M+C*clutter(count)+N);

        %Calcualte the recieved signal
        RX = fft(TX)./(fft(ksdensity(Cs*clutter(count))).*fft(ksdensity(Ns)));
        Rpdf = ksdensity(ifft(RX));
        Rmean = dot(x,Rpdf)/sum(Rpdf);
        Rlam = Rmean/gamma(1+1/kM);

        %Sum the lambda error and SCR for each iteration
        ER = ER + Rlam - mD;
        SCR = SCR + 10*log10(sum(M.^2)/sum((C*clutter(count)).^2));
        
        loop = loop + 1;
    end
    
    %Plot the PDF for the last iteration
    if(count == 100)
        subplot(1,3,1);
        plot(x,ksdensity(M));
        title("M PDF");
        subplot(1,3,2);
        plot(x,TX);
        title("TX PDF");
        subplot(1,3,3);
        plot(x,Rpdf);
        title("RX PDF");
    end
    
    %Average the SCR and error
    SCR_AVG(count) = SCR/1000;
    error(count) = ER/1000;
    count = count + 1;    
end

count = 1;
%Check different SNR values
while count <= 100
    loop = 1;
    ER = 0;
    SNR = 0;
    
    %Iterate each SCR value 1000 times and average
    while loop <= 1000
        C = wblrnd(lC,kC,1,100); %Generate clutter
        N = randn(1,100)+1; %Generate noise
        
        Cs = wblrnd(lC,kC,1,100); %Clutter "samples" at reciever
        Ns = randn(1,100)+1; %Noise "samples" at receiver
        
        %Calcualte PDF of each signal component
        [TX,x] = ksdensity(M+C+N*noise(count));

        %Calcualte the recieved signal
        RX = fft(TX)./(fft(ksdensity(Cs)).*fft(ksdensity(Ns*noise(count))));
        Rpdf = ksdensity(ifft(RX));
        Rmean = dot(x,Rpdf)/sum(Rpdf);
        Rlam = Rmean/gamma(1+1/kM);
        
        %Sum the lambda error and SNR for each iteration
        ER = ER + Rlam - mD;
        SNR = SNR + 10*log10(sum(M.^2)/sum((N*noise(count)).^2));

        loop = loop + 1;
    end
    
    %Plot the PDF for the last iteration
    if(count == 100)
        figure();
        subplot(1,3,1);
        plot(x,ksdensity(M));
        title("M PDF");
        subplot(1,3,2);
        plot(x,TX);
        title("TX PDF");
        subplot(1,3,3);
        plot(x,Rpdf);
        title("RX PDF");
    end
    
    %Average the SNR and error
    SNR_AVG(count) = SNR/1000;
    error2(count) = ER/1000;
    count = count + 1;
end

%Plot Lambda Error vs SCR
figure();
plot(SCR_AVG,error);
title("Lambda Error vs SCR");
xlabel("SCR in dB");
ylabel("Lambda Error");

%Plot Lambda Error vs SNR
figure();
plot(SNR_AVG,error2);
title("Lambda Error vs SNR");
xlabel("SNR in dB");
ylabel("Lambda Error");