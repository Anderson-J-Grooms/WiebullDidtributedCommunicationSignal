function SCR_Plot(m,mD)
kM = 4;
lC = 3;
kC = 2;

width = 0:0.1:25;
clutter = linspace(1,0.01,1000);
SCR = zeros(1,1000);
error = zeros(1,1000);

count = 1;
%Check multiple SCR values
while count <= 1000
    loop = 1;
    ER = 0;
    SCRhold = 0;
    
    while loop <= 100
        cPDF = makedist('Weibull','A',lC,'B',kC);
        nPDF = makedist('Normal','mu',0,'sigma',1);
        csPDF = makedist('Weibull','A',lC,'B',kC);
        nsPDF = makedist('Normal','mu',0,'sigma',1);
        c = pdf(cPDF,width);
        n = pdf(nPDF,width);
        cs = pdf(csPDF,width);
        ns = pdf(nsPDF,width);
        
        %Calcualte the transmitted signal and recieved signal
        TX = conv(m,conv(c,n));
        out = conv(cs*clutter(count),ns);
        RX = ifft(fft(TX)./fft([out zeros(1,250)]));
        RX = RX(1:length(m));
        Rlam = mean(RX)/gamma(1+1/kM);
        
        ER = ER + abs(Rlam - mD);
        SCRhold = SCRhold + 10*log10(sum(m.^2)/sum((c*clutter(count)).^2));
        
        loop = loop + 1;
    end
    
    SCR(count) = SCRhold/100;
    error(count) = ER/100;
    count = count + 1;
end

figure();
plot(SCR,error);
title("Recieved Lambda Error vs SCR");
xlabel("SCR (dB)");
ylabel("|Received Lambda - Original Lambda|");
end