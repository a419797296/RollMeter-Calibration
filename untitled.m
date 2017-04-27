function varargout = untitled(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
row=0;
set(handles.save,'userdata',row);
handles.output = hObject;
 %% warning('off');
%% 最后记得把clear和clc加上
%修改图标
% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon('头像.jpg'));
% hAxes = axes('visible', 'off', 'units', 'normalized', 'position', [0 0 1 1]);  %前面一个1表示左右充满宽，后面一个表示上下充满框
% axis off;
%% 显示图片
% cData = imread('背景图片.jpg');%%%%%%%%%%%%%%%图片自己下载，保存到当前目录即可
% image(cData);


guidata(hObject, handles);   %更新数据

% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
tmp_ad_value=0;
set(handles.edit7,'userdata',tmp_ad_value);
varargout{1} = handles.output;

function listbox3_Callback(hObject, eventdata, handles)

function listbox3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function COM_menu_Callback(hObject, eventdata, handles)

function COM_menu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in BAUD_menu.
function BAUD_menu_Callback(hObject, eventdata, handles)

function BAUD_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CHECK_menu.
function CHECK_menu_Callback(hObject, eventdata, handles)

function CHECK_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in STOP_menu.
function STOP_menu_Callback(hObject, eventdata, handles)

function STOP_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end 



% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)

function COM_menu_KeyPressFcn(hObject, eventdata, handles)

function figure1_CreateFcn(hObject, eventdata, handles)

function pushbutton2_Callback(hObject, eventdata, handles)
global s;
COM_value=get(handles.COM_menu,'value');  %得到当前COM_menu的值
CHECK_value=get(handles.CHECK_menu,'value'); %得到当前CHECK_menu的值
BAUD_value=get(handles.BAUD_menu,'value'); %得到当前BAUD_menu的值
STOP_value=get(handles.STOP_menu,'value'); %得到当前STOP_menu的值
DATA_value=get(handles.DATA_menu,'value'); %得到当前DATA_menu的值

getcom=instrhwinfo ('serial');
validcom=getcom.SerialPorts;   %获得有效的串口号

%获取所有menu的所有值
currentcom={'COM1','COM2','COM3','COM4','COM5','COM6','COM7','COM8','COM9','COM10','COM11','COM12','COM13','COM14','COM15'};
currentcheck={'NONE','ODD','EVEN'};
currentbaud=[300 600 1200 2400 4800 9600 19200 38400 43000 56000 57600 115200];
currentstop=[1 2];
currentdata=[6 7 8];
judge0=strcmpi(currentcom{COM_value},validcom); %如果有效串口和设置的串口一样为1，否则为0
if sum(judge0)
    s = serial(currentcom{COM_value},'BaudRate',currentbaud(1,BAUD_value),'DataBits',currentdata(1,DATA_value),... %创建有效COM口
        'Parity',currentcheck{CHECK_value},'StopBits',currentstop(1,STOP_value),...
        'InputBufferSize',1000,...  %接收缓冲值最大值为1000
        'TimeOut',1,...
          'TimerPeriod', 0.1,...   %每2秒调用一次接收的回调函数
          'timerfcn', {@mycallback,handles});
      %如果用下面两条代替上面两条，则发送数字无效
%         'BytesAvailableFcnMode','terminator',...   %一旦接收到终止符就启动回调函数，下位机每次发送一次数据，就会在数据的结尾加一个终止符
%         'BytesAvailableFcn',{@mycallback,handles});
      
else
     errordlg('无效COM口','提示','replace');   %提示错误  加上replace防止弹出多个窗口  
end

string=get(handles.pushbutton2,'string');%得到当前按键的名字

if(strcmpi(string,'关闭串口')==1)
    set(handles.pushbutton2,'string','打开串口');  %按键的名字设为‘打开串口’
    set(handles.stat,'backgroundcolor',[0.95 0.95 0.95]);      %关灯

    %关闭串口后允许修改menu
    set(handles.COM_menu,'Enable','on');
    set(handles.BAUD_menu,'Enable','on');
    set(handles.DATA_menu,'Enable','on');
    set(handles.CHECK_menu,'Enable','on');
    set(handles.STOP_menu,'Enable','on');    
    
    % 查找串口对象
    scoms = instrfind;
    % 尝试停止、关闭删除串口对象
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
else
    if sum(judge0)
        set(handles.pushbutton2,'string','关闭串口');  %按键的名字设为‘关闭串口’
        set(handles.stat,'backgroundcolor','g');      %开灯
        
        %打开串口后禁止修改menu
        set(handles.COM_menu,'Enable','off');
        set(handles.BAUD_menu,'Enable','off');
        set(handles.DATA_menu,'Enable','off');
        set(handles.CHECK_menu,'Enable','off');
        set(handles.STOP_menu,'Enable','off');
        
        fopen(s);  %打开串口
    end
end
%% 回调函数处理接收来的数据
function mycallback(s,BytsAvailable,handles)
hebing='';
hex_receive=get(handles.radiobutton1,'value');  %为1表示十六进制显示，否则字符显示
if hex_receive
    n_bytes = get(s,'BytesAvailable')     %% 数据总数量
    if n_bytes
        receive_data= fread(s, n_bytes, 'uchar')'    %% 读走数据并存入receive_data中 直接为十进制数值形式  最后面加一个’使数组横着排
        for i=1:n_bytes
            if receive_data(i)<16
                string_data{i}=sprintf('0%X',receive_data(i));  %把每个数字都变成一个小字符串
            else
                string_data{i}=sprintf('%2X',receive_data(i));  %把每个数字都变成一个小字符串
            end
        end
        for i=1:n_bytes
            hebing=strcat(hebing,32,32,string_data{i});  %在每个小字符串之间加两个空格，组成一个大的字符串
        end 
%         %%
%         %链接数据库
% %读取数据库内容                   
%                         waitsmart=database('willtech','root','willtech','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/willtech'); %连接rollmeter数据库
%     %                     waitsmart=database('rollmeter','root','willtech','com.mysql.jdbc.Driver','jdbc:mysql://127.0.0.1:3306/rollmeter'); %连接rollmeter数据库
%     %                     ping(waitsmart);
%                         if isempty(waitsmart.URL)
%                             pause(3);
%                             msgbox('登入超时，请检查您的网络或者本机防火墙设置。错误码：0x0001！')
%                         else
%                               %在数据库中查找与当前辊号一样的记录
%                             curs=exec(waitsmart,['SELECT userid, username, tel, email,ext_num,job_num,position FROM user_info WHERE userid=''',hebing,'''']);
%                             curs=fetch(curs);
%                             db_rollnames=curs.data;
%                             %如果找到结果，则在数据库中读取该辊号信息
%                             if strcmp(db_rollnames{1},hebing)
%                                 
%                                  set(handles.username,'string',db_rollnames{2})
%                                  set(handles.tel,'string',db_rollnames{3})
%                                  set(handles.email,'string',db_rollnames{4})
%                                  set(handles.ext_num,'string',db_rollnames{5})
%                                  set(handles.job_num,'string',db_rollnames{6})
%                                  set(handles.position,'string',db_rollnames{7})
%                             else
%                                 %插入用户信息
%                                 fastinsert(waitsmart,'user_info',{'userid'},{hebing});
% %                                 list={'username','password','cellphone','email'};
% %                                 fastinsert(waitsmart,'user_info',list,info);
% %                                 curs=exec(waitsmart,['UPDATE user_info SET userid=UUID(),villageid=UUID() WHERE cellphone=''',info{3},'''']);
% %                                 fetch(curs);
% %                                 curs=exec(waitsmart,['UPDATE user_info SET userid=UUID(),villageid=UUID() WHERE cellphone=''',info{3},'''']);
% %                                 curs=fetch(curs);                                
% %                                 msgbox('恭喜您已经注册成功！请回到登入界面进行登入。')
%         %                         fastinsert(waitsmart,'rollnums',list,info);
%                             end
%                         end
%                         close(curs);  
%                         close(waitsmart);   
        
    end
else
    n_bytes = get(s,'BytesAvailable');    %% 数据总数量
    if n_bytes
%         hebing=fscanf(s);    
          receive_data= fread(s, n_bytes, 'uchar')' ;   %% 读走数据并存入receive_data中 直接为十进制数值形式  最后面加一个’使数组横着排
          if mod(n_bytes,2)
             return
          end
          N=n_bytes/2;
          ad_value=zeros(1,N);
          
          for i=1:N
%               if receive_data(2*i-1)<=20   %5000最高位为13
                  ad_value(i)=receive_data(2*i-1)*256+receive_data(2*i);
                  if ad_value(i)>5000
                      ad_value(i)=str2double(get(handles.edit7,'string'));
                  else
                      set(handles.edit7,'string',num2str(ad_value(i)))
                  end
                  
%               end
          end
          tmp_ad_value=get(handles.edit7,'userdata');
        tmp_ad_value=[tmp_ad_value ad_value];
        if size(tmp_ad_value,2)<100
            plot(handles.disp,tmp_ad_value)
            set(handles.edit7,'userdata',tmp_ad_value);
        else
            plot(handles.disp,tmp_ad_value(end-50:end))
            set(handles.edit7,'userdata',tmp_ad_value(end-50:end));
        end
        
    end
end

% original=get(handles.edit7,'string');   %这两句是为了得到原来就显示的，这样原来的内容不会被覆盖，能够在原来的基础之上继续增加内容
% hebing=strcat(original,hebing);

%% 发送按键处理发送    
function button_send_Callback(hObject, eventdata, handles)
global s;
send_data=get(handles.edit4,'string');  %得到发送区的数据
hex_send=get(handles.radiobutton2,'value');

if hex_send  %若为十六进制发送，获取要发送的数据
    n = find(send_data == ' ');   %查找空格
    n =[0 n length(send_data)+1]; %空格的索引值
    %% 每两个相邻空格之间的字符串为数值的十六进制形式，将其转化为数值
    for i = 1 : length(n)-1 
        temp = send_data(n(i)+1 : n(i+1)-1);  %获得每段数据的长度，为数据转换为十进制做准备
        if ~rem(length(temp), 2)
            b{i} = reshape(temp, 2, [])'; %将每段十六进制字符串转化为单元数组
        else
            break;
        end
    end
    send_data= hex2dec(b)';     %将十六进制字符串转化为十进制数，等待写入串口
    fwrite(s,send_data,'uint8', 'async');
else   %如果是ASCII
    fprintf(s,send_data);
end

function DATA_menu_Callback(hObject, eventdata, handles)

function DATA_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)

function slider2_Callback(hObject, eventdata, handles)

function slider2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton4_Callback(hObject, eventdata, handles)
set(handles.edit4,'string','');    %清空发送区


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
set(handles.edit7,'string','');   %清空接收区


function edit7_Callback(hObject, eventdata, handles)
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function radiobutton1_Callback(hObject, eventdata, handles)

function radiobutton2_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function untitled_3_Callback(hObject, eventdata, handles)

 %% 创建一个隐藏的窗口，并调整窗口位置到屏幕中间
hFigure = figure('menubar', 'none', 'NumberTitle', 'off', 'position',...
    [0 0 550 550], 'name', 'About Software', 'Visible', 'off');  %图片的大小是550*550
movegui(hFigure, 'center');
%% 创建坐标轴，用于显示背景图片和文本
hAxes = axes('visible', 'off', 'units', 'normalized', 'position', [0 0 1 1]);  %前面一个1表示左右充满宽，后面一个表示上下充满框
axis off;
%% 显示图片
cData = imread('背景图片.jpg');%%%%%%%%%%%%%%%图片自己下载，保存到当前目录即可
image(cData);
%% 要显示的文本内容
strCell = {'我要像嫩芽一样            ', '冲破土壤的枷锁               ',...
    '寻找属于自己的                  ','蓝天和阳光!!!!                     ','by god of death'};
%% 逐列显示文本
for i = 1 : numel(strCell)  %穷举每条诗句
    strTemp = strCell{i};   %获取第i条诗句
 %   str = [strTemp; 10*ones(1, length(strTemp))]; %诗句的每个字后添加一个换行符
 %   str = str(:)';  %获取添加了换行符的诗句字符串
    text('string', strTemp, 'position', [500 i*50], 'Horizontal', 'right',... %position的[0 0]点在电脑屏幕的左上角
        'FontName', '华文楷体', 'FontSize', 18, 'FontWeight', 'bold');
end
%% 修改窗口左上角的图标
newIcon=javax.swing.ImageIcon('头像.jpg');
figFrame = get(hFigure,'JavaFrame'); %取得Figure的JavaFrame。
figFrame.setFigureIcon(newIcon); %修改图标
%% 显示窗口
set(hFigure, 'Visible', 'on');

%锣声
load gong
sound(y,Fs)
% --------------------------------------------------------------------
function activex1_Change(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)



function username_Callback(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of username as text
%        str2double(get(hObject,'String')) returns contents of username as a double


% --- Executes during object creation, after setting all properties.
function username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tel_Callback(hObject, eventdata, handles)
% hObject    handle to tel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tel as text
%        str2double(get(hObject,'String')) returns contents of tel as a double


% --- Executes during object creation, after setting all properties.
function tel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function email_Callback(hObject, eventdata, handles)
% hObject    handle to email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of email as text
%        str2double(get(hObject,'String')) returns contents of email as a double


% --- Executes during object creation, after setting all properties.
function email_CreateFcn(hObject, eventdata, handles)
% hObject    handle to email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ext_num_Callback(hObject, eventdata, handles)
% hObject    handle to ext_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ext_num as text
%        str2double(get(hObject,'String')) returns contents of ext_num as a double


% --- Executes during object creation, after setting all properties.
function ext_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ext_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function job_num_Callback(hObject, eventdata, handles)
% hObject    handle to job_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of job_num as text
%        str2double(get(hObject,'String')) returns contents of job_num as a double


% --- Executes during object creation, after setting all properties.
function job_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to job_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function position_Callback(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of position as text
%        str2double(get(hObject,'String')) returns contents of position as a double


% --- Executes during object creation, after setting all properties.
function position_CreateFcn(hObject, eventdata, handles)
% hObject    handle to position (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stat.
function stat_Callback(hObject, eventdata, handles)
% hObject    handle to stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function step_Callback(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step as text
%        str2double(get(hObject,'String')) returns contents of step as a double


% --- Executes during object creation, after setting all properties.
function step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% st=get(handles.step,'string');
% st=str2double(st)*1000;
list=get(handles.real_value,'string');
value=get(handles.real_value,'value');
real_value=list{value};
filepath='./calibration_data.txt';
% row=get(handles.save,'userdata');
% x=st*row;
% row=row+1;
% set(handles.save,'userdata',row);
fp = fopen(filepath,'a+');
if fp==-1
    return
else
    for i=1:10
        ad_value=get(handles.edit7,'string');
        if abs(str2double(real_value)-str2double(ad_value))>250
            msgbox('实际值与理论值差别较大，请选择正确的实际值再保存，此次保存无效！！')
            return
        end
        fprintf(fp, '%s\t%s\n',real_value,ad_value);
        pause(0.01)
    end
    fclose(fp);
end

% --- Executes on button press in clear_ad.
function clear_ad_Callback(hObject, eventdata, handles)
% hObject    handle to clear_ad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath='./calibration_data.txt';
delete(filepath)
row=0;
set(handles.save,'userdata',row);

% ff 07 d0 20 00 00



function para3_Callback(hObject, eventdata, handles)
% hObject    handle to para3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of para3 as text
%        str2double(get(hObject,'String')) returns contents of para3 as a double


% --- Executes during object creation, after setting all properties.
function para3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to para3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function para2_Callback(hObject, eventdata, handles)
% hObject    handle to para2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of para2 as text
%        str2double(get(hObject,'String')) returns contents of para2 as a double


% --- Executes during object creation, after setting all properties.
function para2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to para2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function para1_Callback(hObject, eventdata, handles)
% hObject    handle to para1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of para1 as text
%        str2double(get(hObject,'String')) returns contents of para1 as a double


% --- Executes during object creation, after setting all properties.
function para1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to para1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function para0_Callback(hObject, eventdata, handles)
% hObject    handle to para0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of para0 as text
%        str2double(get(hObject,'String')) returns contents of para0 as a double


% --- Executes during object creation, after setting all properties.
function para0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to para0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_calb.
function start_calb_Callback(hObject, eventdata, handles)
% hObject    handle to start_calb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.para1,'string','')
set(handles.para0,'string','')
set(handles.para2,'string','')
set(handles.para3,'string','')

meas_data=load('calibration_data.txt');
dist=meas_data(:,1);
ad_value=meas_data(:,2);

% p=polyfit(ad_value,dist,3);
% set(handles.para3,'string',num2str(p(1)))
% set(handles.para2,'string',num2str(p(2)))
% set(handles.para1,'string',num2str(p(3)))
% set(handles.para0,'string',num2str(p(4)))

% p=polyfit(ad_value,dist,2);
% set(handles.para2,'string',num2str(p(1)))
% set(handles.para1,'string',num2str(p(2)))
% set(handles.para0,'string',num2str(p(3)))

p=polyfit(ad_value,dist,1);
set(handles.para1,'string',num2str(p(1)))
set(handles.para0,'string',num2str(p(2)))
% fit_dist=ad_value;
fit_dist=polyval(p,ad_value);
plot(ad_value,fit_dist,ad_value,dist-fit_dist,'*')


% --- Executes on selection change in real_value.
function real_value_Callback(hObject, eventdata, handles)
% hObject    handle to real_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns real_value contents as cell array
%        contents{get(hObject,'Value')} returns selected item from real_value


% --- Executes during object creation, after setting all properties.
function real_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to real_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
