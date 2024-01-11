ccc
ROOTPATH = strcat(getRootDirPath(mfilename("fullpath"), 4), "Data\ProcessData\");
protStr = "ActiveFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_A = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_A = addFieldToStruct(popRes_A, repmat(cellstr(protStr), length(popRes_A), 1), "protStr");

popRes_B = [];

protStr = "ActiveNoneFreqRight";
temp = dirItem(strcat(ROOTPATH, protStr), "spkData.mat");
popRes_C = cell2mat(cellfun(@(x) NoveltySU.population.loadPopData(x), temp.file, "UniformOutput", false));
popRes_C = addFieldToStruct(popRes_C, repmat(cellstr(protStr), length(popRes_C), 1), "protStr");

% merge
popRes = [popRes_A; popRes_B; popRes_C];

% select data
matchIdx = NoveltySU.utils.selectData.decideRegion(popRes, "A1");
popSelect = popRes(cell2mat(matchIdx));
MonicaIdx = contains({popSelect.Date}', "Monica");
CMIdx = contains({popSelect.Date}', "CM");
popMonica = popSelect(MonicaIdx);
popCM = popSelect(CMIdx);

%% SFig4
figure
[frTemp, pushTemp] = cellfun(@(x) FR78910(x), {popMonica.trialAll}', "UniformOutput", false);
fr.Monica = cell2mat(frTemp);
push.Monica = cell2mat(pushTemp);
[frTemp, pushTemp] = cellfun(@(x) FR78910(x), {popCM.trialAll}', "UniformOutput", false);
fr.CM = cell2mat(frTemp);
push.CM = cell2mat(pushTemp);

Axes(1) = subplot(3, 2, 1);
Sfig6.a.pushMean = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum({push.Monica.pushRatio}'), "UniformOutput", false));
Sfig6.a.pushSE = cell2mat(cellfun(@(x) SE(x, 1), changeCellRowNum({push.Monica.pushRatio}'), "UniformOutput", false));
Sfig6.a.pushRaw = changeCellRowNum({push.Monica.pushRatio}');
% [Sfig6.a.pAnova, Sfig6.a.posthoc] = mAnovaCell(cellfun(@(x) reshape(x, [], 1), Sfig6.a.pushRaw, "UniformOutput", false));
[~, Sfig6.a.ttest] = ttest(Sfig6.a.pushRaw{2}(:, 5), Sfig6.a.pushRaw{4}(:, 5));

Axes(2) = subplot(3, 2, 3);
Sfig6.b.frMean_Early =  cell2mat(cellfun(@(x) mean(excludeNaN(x), 1), changeCellRowNum({fr.Monica.Mean_Early}'), "UniformOutput", false));
Sfig6.b.frSE_Early =  cell2mat(cellfun(@(x) SE(excludeNaN(x), 1), changeCellRowNum({fr.Monica.Mean_Early}'), "UniformOutput", false));

Axes(3) = subplot(3, 2, 5);
Sfig6.c.frMean_Late =  cell2mat(cellfun(@(x) mean(excludeNaN(x), 1), changeCellRowNum({fr.Monica.Mean_Late}'), "UniformOutput", false));
Sfig6.c.frSE_Late =  cell2mat(cellfun(@(x) SE(excludeNaN(x), 1), changeCellRowNum({fr.Monica.Mean_Late}'), "UniformOutput", false));
Sfig6.c.frRaw = changeCellRowNum({fr.Monica.Mean_Late}');
[~, Sfig6.c.ttest] = ttest(Sfig6.c.frRaw{2}(:, 5), Sfig6.c.frRaw{4}(:, 5));

Axes(4) = subplot(3, 2, 2);
Sfig6.d.pushMean = cell2mat(cellfun(@(x) mean(x, 1), changeCellRowNum({push.CM.pushRatio}'), "UniformOutput", false));
Sfig6.d.pushSE = cell2mat(cellfun(@(x) SE(x, 1), changeCellRowNum({push.CM.pushRatio}'), "UniformOutput", false));
Sfig6.d.pushRaw = changeCellRowNum({push.CM.pushRatio}');
[~, Sfig6.d.ttest] = ttest(Sfig6.d.pushRaw{2}(:, 5), Sfig6.d.pushRaw{4}(:, 5));

Axes(5) = subplot(3, 2, 4);
Sfig6.e.frMean_Early =  cell2mat(cellfun(@(x) mean(excludeNaN(x), 1), changeCellRowNum({fr.CM.Mean_Early}'), "UniformOutput", false));
Sfig6.e.frSE_Early =  cell2mat(cellfun(@(x) SE(excludeNaN(x), 1), changeCellRowNum({fr.CM.Mean_Early}'), "UniformOutput", false));

Axes(6) = subplot(3, 2, 6);
Sfig6.f.frMean_Late =  cell2mat(cellfun(@(x) mean(excludeNaN(x), 1), changeCellRowNum({fr.CM.Mean_Late}'), "UniformOutput", false));
Sfig6.f.frSE_Late =  cell2mat(cellfun(@(x) SE(excludeNaN(x), 1), changeCellRowNum({fr.CM.Mean_Late}'), "UniformOutput", false));
Sfig6.f.frRaw = changeCellRowNum({fr.CM.Mean_Late}');
[~, Sfig6.f.ttest] = ttest(Sfig6.f.frRaw{2}(:, 5), Sfig6.f.frRaw{4}(:, 5));

colors = ["r-", "m-", "b-", "k-"];
for sIndex = 1 : 4
    errorbar(Axes(1), Sfig6.a.pushMean(sIndex, :), Sfig6.a.pushSE(sIndex, :), colors(sIndex)); hold on
    errorbar(Axes(2), Sfig6.b.frMean_Early(sIndex, :), Sfig6.b.frSE_Early(sIndex, :), colors(sIndex)); hold on
    errorbar(Axes(3), Sfig6.c.frMean_Late(sIndex, :), Sfig6.c.frSE_Late(sIndex, :), colors(sIndex)); hold on
    errorbar(Axes(4), Sfig6.d.pushMean(sIndex, :), Sfig6.d.pushSE(sIndex, :), colors(sIndex)); hold on
    errorbar(Axes(5), Sfig6.e.frMean_Early(sIndex, :), Sfig6.e.frSE_Early(sIndex, :), colors(sIndex)); hold on
    errorbar(Axes(6), Sfig6.f.frMean_Late(sIndex, :), Sfig6.f.frSE_Late(sIndex, :), colors(sIndex)); hold on
end

save(strcat(getRootDirPath(mfilename("fullpath"), 1), "SFig6_Plot.mat"), "Sfig6", "-v7.3");