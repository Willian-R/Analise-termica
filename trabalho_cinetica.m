clear,clc
for w = 1:4
    %% estrutura para abrir os dados de cada arquivo
    if w == 1
        filename = 'TGA-c145a-celulose tx 5.txt';
    elseif w == 2
        filename = 'TGA-c150a-celulose tx 10-1.txt';
    elseif w == 3
        filename = 'TGA-c151a-celulose tx 20.txt';
    else
        filename = 'TGA-c152a-celulose tx 40.txt';
    end
    
    % para limpar as listas para cada arquivo
    clear A; clear tempo; clear temperatura; clear TG_massa; clear TG_porc; 
    clear alfa; clear derivada
    
    % carrega os dados do arquivo txt para a vari�vel A 
    A = load (filename);
    
    %% Estrutura para aloca��o dos dados
    % pega dos dados da vari�vel A e coloca nas listas tempo, temperatura
    % e TG_massa
    for c = 1:length(A)
        tempo(c) = A(c,1);
        temperatura(c) = A(c,2);
        TG_massa(c) = A(c,3);
    end
    
    %% Estrutura que calcula TG em porcentagem e convers�o (alfa)
    % converte a TG_massa em mg para porcentagem (TG_porc) e calcula a
    % convers�o da degrada��o
    for c = 1:length(TG_massa)
         TG_porc(c) = (TG_massa(c)/TG_massa(1))*100;
         alfa(c) = (TG_massa(1)-TG_massa(c))/(TG_massa(1)-TG_massa(length(TG_massa)));
    end
    
    %% Estrutra para calcular a DTG de cada degrada��o
    for i = 1:length(TG_porc)
        if i == 1
            primeiro = (TG_porc(i+1)-TG_porc(i))/(tempo(i+1)-tempo(i));
            segundo = (TG_porc(i)-0)/(tempo(i)-0);
        elseif i == length(TG_porc)
            primeiro = (0-TG_porc(i))/(0-tempo(i));
            segundo = (TG_porc(i)-TG_porc(i-1))/(tempo(i)-tempo(i-1));
        else
            primeiro = (TG_porc(i+1)-TG_porc(i))/(tempo(i+1)-tempo(i));
            segundo = (TG_porc(i)-TG_porc(i-1))/(tempo(i)-tempo(i-1));
        end
        derivada(i) = (1/2)*(primeiro + segundo);
    end
    
    %% Cria os gr�ficos
    
    % Figura 1 - Curvas TG de cada taxa de aquecimento
    figure (1)
    plot(temperatura, TG_porc)
    axis([10 605 0 105])
    hold on
    
    % Figura 2 - Convers�o
    figure (2)
    plot(temperatura, alfa)
    axis([10 605 -0.1 1.1])
    hold on
    
    % Figura 3 - Curvas DTG
    figure (3)
    plot(temperatura, derivada)
    hold on
end

%% Adiciona t�tulo, r�tulos nos eixos e legenda
figure (1)
title('Curvas TG')
xlabel('Temperatura (�C)')
ylabel('Massa (%)')
legend('5 �C/min','10 �C/min', '20 �C/min', '40 �C/min')
figure (2)
title('Convers�o vs. Temperatura')
xlabel('Temperatura (�C)')
ylabel('Convers�o')
legend({'5 �C/min','10 �C/min', '20 �C/min', '40 �C/min'},'Location','northwest')
figure (3)
title('Curvas DTG')
xlabel('Temperatura (�C)')
ylabel('DTG (%/seg)')
legend({'5 �C/min','10 �C/min', '20 �C/min', '40 �C/min'},'Location','southwest')