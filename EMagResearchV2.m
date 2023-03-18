clc
clear

%Initialize variables
mB = ("01011"); %The message
mD = bin2dec(mB); %Convert our message to a decimal
kM = 4;
lC = 3;
kC = 2;

width = 0:0.1:25;

mPDF = makedist('Weibull','A',mD,'B',kM);
cPDF = makedist('Weibull','A',lC,'B',kC);
nPDF = makedist('Normal','mu',0,'sigma',1);
m = pdf(mPDF,width);
c = pdf(cPDF,width);
n = pdf(nPDF,width);

TX = conv(m,conv(c,n));

plot(width,m);
hold on
plot(width,c);
plot(width,n);
title("Individual PDFs");
legend("Message PDF","Clutter PDF","Noise PDF");
xlabel("Value");
ylabel("Probability Density");
hold off

figure()
plot(TX);
title("Combined Transmitted PDF");
xlabel("Value");
ylabel("Probability Density");

choice = 0;
while choice ~= 3
    disp("1. SCR vs Error");
    disp("2. SNR vs Error");
    disp("3. Exit");
    prompt = 'Your selection: ';
    choice = input(prompt,'s');
    choice = str2num(['uint8(',choice,')']);
    
    if choice == 1
        SCR_Plot(m,mD);
    elseif choice == 2
        SNR_Plot(m,mD);
    end
end