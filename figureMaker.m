cd './2Scatterers_Gaussian/';

mode=["xy"]  %choosing cartesian coordiante system

dx=60; % dimension of each cell in meters
divNum=7; % the size of heat map figure is divNum x divnum
PML=10; % the size of the PML layer (number of cells)
numInd=224; % max value for the x- or y- coordiante (index)
gridSizeM=numInd*dx; % max value for the x- or y- coordiante (meters)
exRate=0.025  %0.025 of data with higghest location error are considered as outliers and are not considered in the evaluation

% settings of the plots
sz=8;   % point size
fz=8; % font_size
width=9; %figure width
height=13; % figure height
lableFont='normal';
linewidth=0.5;

temp=[];
res=[];
load('a_h_target.mat')
load('a_h_output.mat')
temp(:,1)=y_target;
temp(:,2)=y_output;
load('b_h_target.mat')
load('b_h_output.mat')
temp(:,3)=y_target;
temp(:,4)=y_output;
temp(:,5)=sqrt((temp(:,1)-temp(:,2)).^2+(temp(:,3)-temp(:,4)).^2);
temp(:,6)=1:size(temp,1);
temp=sortrows(temp,5);
exNum=round(exRate*size(temp,1));
exInd=temp(end-exNum:end,6);
temp(end-exNum:end,:)=[];
maxErr=max(temp(:,5))*dx;
ex=find(temp(:,1)<PML | temp(:,1)>(numInd-PML) | temp(:,3)<PML | temp(:,3)>(numInd-PML));
temp(ex,:)=[];

res=table(dx*temp(:,1),dx*temp(:,2),dx*temp(:,3),dx*temp(:,4),dx*temp(:,5));
res.Properties.VariableNames{1} = 't_ah';
res.Properties.VariableNames{2} = 'o_ah';
res.Properties.VariableNames{3} = 't_bh';
res.Properties.VariableNames{4} = 'o_bh';
res.Properties.VariableNames{5} = 'err';

[xData_arg1, yData_arg1] = prepareCurveData(res.o_ah, res.t_ah);
[xData_arg2, yData_arg2] = prepareCurveData(res.o_bh, res.t_bh);
[fitresults_arg1, gof_arg1]=createFit(res.o_ah, res.t_ah);
[fitresults_arg2, gof_arg2]=createFit(res.o_bh, res.t_bh);
figure( 'Name', 'Results' );
subplot( 3, 1, 1 );
h = plot( fitresults_arg1, xData_arg1, yData_arg1);
legend( h, 'Taget vs. Output', 'Best-fit line', 'Location', 'southeast','FontSize',fz-3 );
% Label axes
xlabel 'Output (m)'
ylabel 'Target (m)'

xlim([0 numInd*dx])
ylim([0 numInd*dx])
title('(a) Results for the X-coordiante')
set(gca,'FontSize',fz,'FontWeight','normal','linewidth',linewidth);
txt1=['RMSE: ' num2str(round(gof_arg1.rmse,0)) ' m'];
txt2=['R^2: ' num2str(round(gof_arg1.rsquare,3))];
text(5*dx,(numInd-24)*dx,txt1,'FontSize',fz-3)
text(5*dx,(numInd-49)*dx,txt2,'FontSize',fz-3)

box on
grid on

subplot( 3, 1, 2 );
h = plot( fitresults_arg2, xData_arg2, yData_arg2);
legend( h, 'Taget vs. Output', 'Best-fit line', 'Location', 'southeast','FontSize',fz-3 );
% Label axes
xlabel 'Output (m)'
ylabel 'Target (m)'
xlim([0 numInd*dx])
ylim([0 numInd*dx])
title('(b) Results for the Y-coordiante')
set(gca,'FontSize',fz,'FontWeight','normal','linewidth',linewidth);
txt1=['RMSE: ' num2str(round(gof_arg2.rmse,0)) ' m'];
txt2=['R^2: ' num2str(round(gof_arg2.rsquare,3))];
text(5*dx,(numInd-24)*dx,txt1,'FontSize',fz-3)
text(5*dx,(numInd-49)*dx,txt2,'FontSize',fz-3)

box on
grid on

subplot(3,1,3)
%histogram(res.err,'Normalization','probability','FaceColor',[0.4706    0.6706    0.1882])
% res.err(find (res.err>maxErr))=maxErr;
histogram(res.err,0:100:maxErr,'Normalization','probability','FaceColor',[0.4706    0.6706    0.1882])

xlabel 'Location error (m)'
ylabel 'Probability (%)'
ytix = get(gca, 'YTick');
set(gca, 'YTick',ytix, 'YTickLabel',ytix*10^2)
xlim([0 Inf])
txt1=['Median location error: ' num2str(round(median(res.err))) ' m'];
%txt2=['R^2: ' num2str(round(gof_bh.rsquare,3))];
text(5*dx,max(ytix)-0.01,txt1,'FontSize',fz-3);

title('(c) Location error')
box on
set(gca,'FontSize',fz,'FontWeight','normal','linewidth',linewidth);
grid on
set(gcf,'PaperUnits', 'centimeters','PaperPosition', [0 0 width height]);
print (strcat("results_", mode),'-dpng', '-r600')


figure()
scatter(res.t_ah,res.t_bh,'o','SizeData',sz,'MarkerFaceColor','b');
hold on;
scatter(res.o_ah,res.o_bh,'o','SizeData',sz,'MarkerEdgeColor',[0.9294    0.6902    0.1294],'MarkerFaceColor',[0.9294    0.6902    0.1294]);

legend off
hold off;
line([res.t_ah,res.o_ah]',[res.t_bh,res.o_bh]','Color','r','linewidth',linewidth);
xlabel 'X (m)'
ylabel 'Y (m)'
xticks(linspace(0,gridSizeM,6));
yticks(linspace(0,gridSizeM,6));
box on
grid on
%legend( 'Taget', 'Output', 'Location', 'northoutside','FontSize',fz-3 );
set(gca,'FontSize',fz,'FontWeight','normal','linewidth',linewidth);
set(gcf,'PaperUnits', 'centimeters','PaperPosition', [0 0 width width-1]);
print (strcat("results_scatter_", mode),'-dpng', '-r600')


[xx,yy]=meshgrid(linspace(PML*dx,gridSizeM/(divNum-1)+gridSizeM,divNum));
x_grid=linspace(PML*dx,gridSizeM,divNum+1);
y_grid=linspace(PML*dx,gridSizeM,divNum+1);
error=zeros(divNum+1,divNum+1);
ind=zeros(divNum+1,divNum+1);
for i=1:size(res,1);
    x_index=find(x_grid>=res.t_ah(i),1,'first')-1;
    y_index=find(y_grid>=res.t_bh(i),1,'first')-1;
    error (x_index,y_index)=(error (x_index,y_index)*ind(x_index,y_index)+res.err(i))/(ind(x_index,y_index)+1);
    ind(x_index,y_index)=ind(x_index,y_index)+1;
end
figure
array=linspace(PML*dx,gridSizeM,divNum+1);
heatmap(round(array(1:end-1)),round(flip(round(array(1:end-1)))),round(flip(error((1:end-1),(1:end-1)),2)'));
ax=gca;
properties(ax);
ax.XLabel='X (m)';
ax.YLabel='Y (m)';
set(gca,'FontSize',fz-3);
set(gcf,'PaperUnits', 'centimeters','PaperPosition', [0 0 width width-1]);
print (strcat("results_heatmap_", mode),'-dpng', '-r600')
sprintf ('Mean of the location error: %d m', round(mean(res.err)))