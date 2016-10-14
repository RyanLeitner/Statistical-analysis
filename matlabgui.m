% Activity Matlab Project: Statistical analysis of data file
% File: matlabgui.m
% Date:    3 May 2016
% By:      Ryan Leitner
%          924008862
% Section: 523
% Team:    3
%
% ELECTRONIC SIGNATURE
% Ryan Leitner
%
% The electronic signature above indicates the script
% submitted for evaluation is my individual work, and I 
% have a general understanding of all aspects of its
% development and execution.
%
% ENGR 112 Matlab project
%
function varargout = matlabgui(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matlabgui_OpeningFcn, ...
                   'gui_OutputFcn',  @matlabgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT





% --- Executes just before matlabgui is made visible.
function matlabgui_OpeningFcn(hObject, ~, handles, varargin)

handles.output = hObject;

% Update handles structure
%%set initial values
guidata(hObject, handles);
totalData = [];
set(handles.txtFile,'UserData',totalData)
set(handles.xValProb,'value',1)
set(handles.zValProb,'value',0)
histogram(totalData)






% --- Outputs from this function are returned to the command line.
function varargout = matlabgui_OutputFcn(~, ~, handles)
varargout{1} = handles.output;





function user_Callback(hObject, ~, ~)
username = get(hObject,'String');
set(hObject,'userdata',username)




% --- Executes during object creation, after setting all properties.
function user_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in txtFile.
function txtFile_Callback(hObject, ~, handles)

data = uigetfile('.txt','Select a text file'); %load('testdata.txt');
if data==0
    % user hit cancel
else
    data = load(data);
try
%% puts two column files into one column
count = 1;
for i=1:length(data)
    for j=1:length(data(i,:))
        totalData(count) = data(i,j);
        count = count + 1;
    end
end
%% performs statistical analysis
set(hObject,'userdata',totalData)
% total data holds all the data in a single array
mean1 = mean(totalData);                    % sets value for mean
meanLabel = sprintf('%.2f',mean1);
set(handles.meanDisp,'string',meanLabel);

median1 = median(totalData);                % sets value for median
medianLabel = sprintf('%.2f',median1);
set(handles.medDisp,'string',medianLabel);

mode1 = mode(totalData);                    % sets value for mode
modeLabel = sprintf('%.2f',mode1);
set(handles.modDisp,'string',modeLabel);

min1 = min(totalData);                      % sets value for minimum
minLabel = sprintf('%.2f',min1);
set(handles.minDisp,'string',minLabel);

max1 = max(totalData);                      % sets value for max
maxLabel = sprintf('%.2f',max1);
set(handles.maxDisp,'string',maxLabel);

countLabel = sprintf('%.2f',count-1);       % displays count value
set(handles.cntDisp,'string',countLabel);

var1 = var(totalData);                      % sets value for variance
varLabel = sprintf('%.2f',var1);
set(handles.varDisp,'string',varLabel);

std1 = std(totalData);                      % sets value for standard deviation
stdLabel = sprintf('%.2f',std1);
set(handles.stdDisp,'string',stdLabel);

histogram(totalData,16)                     % creates initial histogram
catch
    errordlg('Error loading file, make sure its a txt file')
    % error checking
    
end
end




function outFileName_Callback(hObject, ~, ~)
outFile_Name = get(hObject,'String');
set(hObject,'userdata',outFile_Name);                   % sets value for user defined output file




% --- Executes during object creation, after setting all properties.
function outFileName_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function givenProbVal_Callback(hObject, ~, handles)
%written by ryan leitner
prob = str2num(get(hObject,'string'));                  % gets value for probability, mean, stdev
mean = str2num(get(handles.meanDisp,'string'));     
stddev = str2num(get(handles.stdDisp,'string'));
median = str2num(get(handles.medDisp,'string'));

if (abs(median-mean)/median*100)>10                     % check to see if data is normally distributed
    errordlg('Is data normally distributed?')
else
if isempty(prob) || (prob<0 ||prob>1)
    errordlg('Enter a Probability between [0 1]')       % error checking 
else
    if isempty(stddev)||isempty(mean)
        errordlg('Upload data file')                    % checking to make sure there is data uploaded
    else
        xVal = sprintf('%.3f',norminv(prob,mean,stddev));   % disp x value from given probability
        set(handles.foundxVal,'string',xVal)
        zVal = norminv(prob,mean,stddev)
        zVal = (zVal-mean)/stddev
        zVal = sprintf('%.3f',(norminv(prob,mean,stddev)-mean)/stddev);     % disp z values from given probability
        set(handles.foundzVal,'string',zVal)
        fileID = fopen('XandZval.txt','a');
        fprintf(fileID,'User input Probability: %.2s\n',prob)
        fprintf(fileID,'X value: %.6s\n',xVal)
        fprintf(fileID,'Z value: %.7s\n',zVal)
    end
end
end





% written by ryan leitner
% --- Executes during object creation, after setting all properties.
function givenProbVal_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in xValProb.
function xValProb_Callback(hObject, ~, handles)
set(hObject,'value',1)                      % switches the button for x value/ z value
set(handles.zValProb,'value',0)




% --- Executes on button press in zValProb.
function zValProb_Callback(hObject, ~, handles)
set(hObject,'value',1)                      % switches the button for z value/ x value
set(handles.xValProb,'value',0)




function XZvalIn_Callback(hObject, ~, handles)      % finds the probability given x or z value
xVal = get(handles.xValProb,'value'); % check to see if given x or z value
zVal = get(handles.zValProb,'value');
inVal = str2num(get(hObject,'string')); % gets the user input value
mean = str2num(get(handles.meanDisp,'string')); % gets the mean and stdev
stddev = str2num(get(handles.stdDisp,'string'));
median = str2num(get(handles.medDisp,'string'))

if (abs(median-mean)/median*100)>10         % check to see if data is normally distributed
    errordlg('Is data normally distributed?')
else
if isempty(inVal)
    errordlg('Enter a number')  % checking to make sure user enters a number not letters
else
    if isempty(stddev)||isempty(mean)
        errordlg('Upload data file') % checking to make sure there is data uploaded
else
     % checking to see if x value or z value is selected
     if xVal==1
            xprob = sprintf('%.3f',normcdf(inVal,mean,stddev));
            set(handles.foundProbtxt,'string',xprob)                % set value for probability of x
     else
            if zVal==1                     % set value for probabiliy of z value
                    zprob = sprintf('%.3f',normcdf(inVal*stddev+mean,mean,stddev));
                    set(handles.foundProbtxt,'string',zprob)
            end
     end
    end
end
end




% --- Executes during object creation, after setting all properties.
function XZvalIn_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in histbtn.
% creates Histogram when Histogram button is pressed
function histbtn_Callback(~, ~, handles)   
data = get(handles.txtFile,'userdata');
if isempty(data)
    errordlg('upload data first');
else
    try
bins = inputdlg('How many bins do you want?')       % asking for number of bins the user wants
bins = str2num(bins{1});

if isempty(bins)
    errordlg('Error, enter a number');
else
    if isempty(get(handles.outFileName,'userdata'))  % check to see if out file name is input
        errordlg('Give a output file name')
    else
    histogram(get(handles.txtFile,'userdata'),floor(bins))
    print(strcat(get(handles.outFileName,'userdata'),'_Histogram'),'-dpdf')
    end
end
    catch
    end
end





% --- Executes on button press in histFitbtn.
%creates a Histogram with a fit line when Histogram w/Fit button pressed
function histFitbtn_Callback(~, ~, handles)
data = get(handles.txtFile,'userdata');
if isempty(data)
    errordlg('upload data first');
else
bins = inputdlg('How many bins do you want?')       % asking for number of bins the user wants
bins = str2num(bins{1})

if isempty(bins)
    errordlg('Error, enter a number');
else
    if isempty(get(handles.outFileName,'userdata'))  % check to see if out file name is input
        errordlg('Give a output file name')
    else
    histfit(get(handles.txtFile,'userdata'),floor(bins))
    print(strcat(get(handles.outFileName,'userdata'),'_HistFit'),'-dpdf')
    end
    
end
end
%end



%creates a probability plot when Probability plot button is pressed
function probPlotbtn_Callback(~, ~, handles)
data = get(handles.txtFile,'userdata'); %check to se if data is uploaded
if isempty(data)
    errordlg('upload data first');
else
    if isempty(get(handles.outFileName,'userdata'))  % check to see if out file name is input
        errordlg('Give a output file name')
    else
probplot(get(handles.txtFile,'userdata'))
print(strcat(get(handles.outFileName,'userdata'),'_ProbPlot'),'-dpdf')
    end
end





% --- Executes on button press in genOutFile.
function genOutFile_Callback(~, ~, handles) % Generates an output file when Generate output button pushed
fileName = get(handles.outFileName,'userdata'); % gets user defined outputfile name
if isempty(fileName)                        % check to make sure user set a output file name
    errordlg('Set a output filename')
else
fileName = strcat(fileName,'.txt'); % adds .txt to the end of the filename
fileID = fopen(fileName,'w');  % writes a new file with the user defined output filename
if isempty(get(handles.user,'userdata')) % check to see if the user set a username
    errordlg('Set a Username')
else
    if isempty(get(handles.meanDisp,'string'))
        errordlg('Upload a data file')
    else
        
        h = waitbar(0,'Generating');
steps = 100;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
end
close(h) 

        %% formatting output file
fprintf(fileID,'%s\n',num2str(get(handles.user,'userdata')));
fprintf(fileID,'%s\n',num2str(date));
fprintf(fileID,'Mean%5s  %5s\n','=',get(handles.meanDisp,'string'));
fprintf(fileID,'Median%3s  %5s\n','=',get(handles.medDisp,'string'));
fprintf(fileID,'Mode%5s  %5s\n','=',get(handles.modDisp,'string'));
fprintf(fileID,'Var%6s  %5s\n','=',get(handles.varDisp,'string'));
fprintf(fileID,'Stdev%4s  %5s\n','=',get(handles.stdDisp,'string'));
fprintf(fileID,'Min%6s  %3s\n','=',get(handles.minDisp,'string'));
fprintf(fileID,'Max%6s %3s\n','=',get(handles.maxDisp,'string'));
fprintf(fileID,'Count%4s %3s\n','=',get(handles.cntDisp,'string'));
    end
end
end
