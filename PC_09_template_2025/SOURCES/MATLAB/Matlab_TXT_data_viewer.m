FID = fopen ('../FIR_data/FIR_data_in.txt');
FIR_in = fscanf(FID,'%d');
fclose(FID);

FID = fopen ('../FIR_data/FIR_data_out.txt');
FIR_out = fscanf(FID,'%d');
fclose(FID);




% subplot(2,1,1)
% plot(FIR_in,'b','linewidth',2);
% 
% subplot(2,1,2)
% plot(FIR_out,'g','linewidth',2);
% 
% % Parameter
% Fs = 6.25e6;  
% Fclk = 50e6;     
% Fpass = 50e3;     
% Fstop = 200e3;    
% Apass = 1;       
% Astop = 40;
% 
% rp = (10^(Apass/20) - 1) / (10^(Apass/20) + 1);
% rs = 10^(-Astop/20);
% 
% fats = [Fpass Fstop];    
% a = [1 0];               
% devs = [rp rs];      
% 
% [N, fo, ao, w] = firpmord(fats, a, devs, Fs);
% 
% b = firpm(N, fo, ao, w);
% 
% fprintf('Navržený řád filtru (N): %d\n', N);
% fprintf('Počet koeficientů: %d\n', length(b));
% 
% fvtool(b, 1, 'Fs', Fs);
% 
% 
% % figure();
% % subplot(2,1,1)
% % plot(FIR_in,'b','linewidth',2);
% % 
% % subplot(2,1,2)
% % plot(FIR_out,'g','linewidth',2);

