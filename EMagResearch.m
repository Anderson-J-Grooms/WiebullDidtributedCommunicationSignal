clc;
clear;

%Initialize variables
mB = ("01011"); %The message
mD = bin2dec(mB); %Convert our message to a decimal
kM = 2;
lC = 3;
kC = 2;

count = 1;
clutter = linspace(25,0.01,100);
noise = linspace(25,0.01,100);
SCR_AVG = zeros(1,100);
SNR_AVG = zeros(1,100);
error = zeros(1,100);
error2 = zeros(1,100);

M = wblrnd(mD,kM,1,100); %Generate noise using decimal message as lambda

% %Check different SCR values
% while count <= 100
%     loop = 1;
%     ER = 0;
%     SCR = 0;
%     while loop <= 1000
%         C = wblrnd(lC,kC,1,100); %Generate clutter
%         N = randn(1,100); %Generate noise
%         
%         Cs = wblrnd(lC,kC,1,100); %Clutter "samples" at reciever
%         Ns = randn(1,100); %Noise "samples" at receiver
%         
%         %Calcualte PDF of each signal component
%         [TX,x] = ksdensity(M+C*clutter(count)+N);
% 
%         %Calcualte the transmitted signal and recieved signal
%         RX = fft(TX)./(fft(ksdensity(Cs*clutter(count))).*fft(ksdensity(Ns)));
%         Rpdf = ksdensity(ifft(RX));
%         Rmean = dot(x,Rpdf)/sum(Rpdf);
%         Rlam = Rmean/gamma(1+1/kM);
% 
%         ER = ER + Rlam - mD;
%         loop = loop + 1;
%         SCR = SCR + 10*log10(sum(M.^2)/sum((C*clutter(count)).^2));
%     end
%     SCR_AVG(count) = SCR/1000;
%     error(count) = ER/1000;
%     count = count + 1;    
% end

count = 1;
%Check different SNR values
while count <= 100
    loop = 1;
    ER = 0;
    SNR = 0;
    while loop <= 1000
        C = wblrnd(lC,kC,1,100); %Generate clutter
        N = randn(1,100); %Generate noise
        
        Cs = wblrnd(lC,kC,1,100); %Clutter "samples" at reciever
        Ns = randn(1,100); %Noise "samples" at receiver
        
        %Calcualte PDF of each signal component
        [TX,x] = ksdensity(M+C+N*noise(count));

        %Calcualte the transmitted signal and recieved signal
        RX = fft(TX)./(fft(ksdensity(Cs)).*fft(ksdensity(Ns*noise(count))));
        Rpdf = ksdensity(ifft(RX));
        Rmean = dot(x,Rpdf)/sum(Rpdf);
        Rlam = Rmean/gamma(1+1/kM);
        
        SNR = SNR + 10*log10(sum(M.^2)/sum((N*noise(count)).^2));

        ER = ER + Rlam - mD;
        loop = loop + 1;
    end
    SNR_AVG(count) = SNR/1000;
    error2(count) = ER/1000;
    count = count + 1;
end

plot(SNR_AVG,error2);