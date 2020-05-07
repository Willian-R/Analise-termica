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
    
    % carrega os dados do arquivo txt para a variável A 
    A = load (filename);
    
    %% Estrutura para alocação dos dados
    % pega dos dados da variável A e coloca nas listas tempo, temperatura
    % e TG_massa
    for c = 1:length(A)
        tempo(c) = A(c,1);
        temperatura(c) = A(c,2);
        TG_massa(c) = A(c,3);
    end
    
    %% Estrutura que calcula TG em porcentagem e conversão (alfa)
    % converte a TG_massa em mg para porcentagem (TG_porc) e calcula a
    % conversão da degradação
    for c = 1:length(TG_massa)
         TG_porc(c) = (TG_massa(c)/TG_massa(1))*100;
         alfa(c) = (TG_massa(1)-TG_massa(c))/(TG_massa(1)-TG_massa(length(TG_massa)));
    end
    
    %% Estrutra para calcular a DTG de cada degradação
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
    
    %% Cria os gráficos
    
    % Figura 1 - Curvas TG de cada taxa de aquecimento
    figure (1)
    plot(temperatura, TG_porc)
    axis([10 605 0 105])
    hold on
    
    % Figura 2 - Conversão
    figure (2)
    plot(temperatura, alfa)
    axis([10 605 -0.1 1.1])
    hold on
    
    % Figura 3 - Curvas DTG
    figure (3)
    plot(temperatura, derivada)
    hold on
end

%% Adiciona título, rótulos nos eixos e legenda
figure (1)
title('Curvas TG')
xlabel('Temperatura (ºC)')
ylabel('Massa (%)')
legend('5 ºC/min','10 ºC/min', '20 ºC/min', '40 ºC/min')
figure (2)
title('Conversão vs. Temperatura')
xlabel('Temperatura (ºC)')
ylabel('Conversão')
legend({'5 ºC/min','10 ºC/min', '20 ºC/min', '40 ºC/min'},'Location','northwest')
figure (3)
title('Curvas DTG')
xlabel('Temperatura (ºC)')
ylabel('DTG (%/seg)')
legend({'5 ºC/min','10 ºC/min', '20 ºC/min', '40 ºC/min'},'Location','southwest')