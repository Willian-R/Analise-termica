% script para curvas TG e DTG
% author: Willian B. Ribeiro
clear,clc
A = load('willian.txt');
for c = 1:length(A)
    tempo(c) = A(c,1);
    temperatura(c) = A(c,2);
    TGA(c) = A(c,3);
end
for c = 1:length(TGA)
    TG_porcentagem(c) = (TGA(c)/TGA(1))*100;
end

% calcular a derivada primeira da curva TG (DTG)
for i = 1:length(TG_porcentagem)
    if i == 1
        primeiro = (TG_porcentagem(i+1)-TG_porcentagem(i))/(tempo(i+1)-tempo(i));
        segundo = (TG_porcentagem(i)-0)/(tempo(i)-0);
    elseif i == length(TG_porcentagem)
        primeiro = (0-TG_porcentagem(i))/(0-tempo(i));
        segundo = (TG_porcentagem(i)-TG_porcentagem(i-1))/(tempo(i)-tempo(i-1));
    else
        primeiro = (TG_porcentagem(i+1)-TG_porcentagem(i))/(tempo(i+1)-tempo(i));
        segundo = (TG_porcentagem(i)-TG_porcentagem(i-1))/(tempo(i)-tempo(i-1));
    end
    derivada(i) = (1/2)*(primeiro + segundo);
end

% cria o gráfico TG/DTG
yyaxis left
plot(temperatura,TG_porcentagem)
ylabel('Massa (%)')
axis([25,930,0,105])

yyaxis right
plot(temperatura,derivada)
ylabel('DTG (%/s)')
axis([25,930,-0.6,0.05])

title('Curva TG e DTG')
xlabel('Temperatura (ºC)')
legend({'TG','DTG'}, 'Location', 'southwest')