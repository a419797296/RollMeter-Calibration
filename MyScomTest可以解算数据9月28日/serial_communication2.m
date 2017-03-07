function varargout = serial_communication2(varargin)
%   作者：罗华飞
%   功能；串口收发
%   版本：20101103 V2.0
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @serial_communication2_OpeningFcn, ...
                   'gui_OutputFcn',  @serial_communication2_OutputFcn, ...
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

function serial_communication2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
warning('off');
javaFrame = get(hObject, 'JavaFrame');
javaFrame.setFigureIcon(javax.swing.ImageIcon('icon.jpg'));
%% 初始化参数
hasData = false; %表征串口是否接收到数据
isShow = false;  %表征是否正在进行数据显示，即是否正在执行函数dataDisp
isStopDisp = false;  %表征是否按下了【停止显示】按钮
isHexDisp = false;   %表征是否勾选了【十六进制显示】
isHexSend = false;   %表征是否勾选了【十六进制发送】
numRec = 0;    %接收字符计数
numSend = 0;   %发送字符计数
strRec = '';   %已接收的字符串
Last_Serial_Data = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]; % 1*20 double

Serial_Data_Format = 0;  %默认为8位字节数据

isLast_Serial_StartByte_First = false ;

%% 10月11日 建立数据接收数组 
Aver_Data_Rec = 0;
Serial_Data_2BeContinued = false ;

%% 将上述参数作为应用数据，存入窗口对象内
setappdata(hObject, 'hasData', hasData);
setappdata(hObject, 'strRec', strRec);
setappdata(hObject, 'numRec', numRec);
setappdata(hObject, 'numSend', numSend);
setappdata(hObject, 'isShow', isShow);
setappdata(hObject, 'isStopDisp', isStopDisp);
setappdata(hObject, 'isHexDisp', isHexDisp);
setappdata(hObject, 'isHexSend', isHexSend);

%% 2012-9-20 DaydreamerZ Modify
setappdata(hObject,'Serial_Data_Format',Serial_Data_Format);

setappdata(hObject, 'isLast_Serial_StartByte_First', isLast_Serial_StartByte_First);
setappdata(hObject,'Serial_Data_2BeContinued',Serial_Data_2BeContinued);

%% 2012-10-11 New Added
setappdata(hObject,'Aver_Data_Rec',Aver_Data_Rec);

guidata(hObject, handles);


function varargout = serial_communication2_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function com_Callback(hObject, ~, handles)

    function com_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rate_Callback(hObject, eventdata, handles)

function rate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function jiaoyan_Callback(hObject, eventdata, handles)

function jiaoyan_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function data_bits_Callback(hObject, eventdata, handles)

function data_bits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stop_bits_Callback(hObject, eventdata, handles)

function stop_bits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function start_serial_Callback(hObject, eventdata, handles)
%   【打开/关闭串口】按钮的回调函数
%    打开串口，并初始化相关参数

%% 若按下【打开串口】按钮，打开串口
if get(hObject, 'value')
    %% 获取串口的端口名
    com_n = sprintf('com%d', get(handles.com, 'value'));
    %% 这里展示了不同方法使用PopUp下拉菜单的方法1
    %% 获取波特率
    rates = [300 600 1200 2400 4800 9600 19200 38400 43000 56000 57600 115200];
     %% 这里相当于目录与索引 'value'中的值为索引值 rates为枚举出的目录
     %% 这里展示了不同方法使用PopUp下拉菜单的方法2
    baud_rate = rates(get(handles.rate, 'value'));
    %% 获取校验位设置
    switch get(handles.jiaoyan, 'value')
        case 1
            jiaoyan = 'none';
        case 2
            jiaoyan = 'odd';
        case 3
            jiaoyan = 'even';
    end
    %% 这里展示了不同方法使用PopUp下拉菜单的方法3
    %% 获取数据位个数
    data_bits = 5 + get(handles.data_bits, 'value');
    %% 这里展示了不同方法使用PopUp下拉菜单的方法4
    %% 获取停止位个数
    stop_bits = get(handles.stop_bits, 'value');
    %% 创建串口对象
    scom = serial(com_n);
    %% 配置串口属性，指定其回调函数
    set(scom, 'BaudRate', baud_rate, 'Parity', jiaoyan, 'DataBits',...
        data_bits, 'StopBits', stop_bits,'InputBufferSize',1000,...  %%书本上的说法似乎有误 缓冲区最大可以不止512 可以到接近5000
     'TimerPeriod', 0.1, 'timerfcn', {@dataDisp1, handles}); %%  ... % 串口缓冲区获得10个数据后才调用该函数？  %% 9月21日测试 %%    'BytesAvailableFcn', {@dataDisp, handles}, 'BytesAvailableFcnCount', 20,...   %%@dataDisp bytes
    %% 字节数模式 终止模式
    %% 将串口对象的句柄作为用户数据，存入窗口对象
    set(handles.figure1, 'UserData', scom);
    %% 尝试打开串口
    try
        fopen(scom);  %打开串口
    catch   % 若串口打开失败，提示“串口不可获得！”
        msgbox('串口不可获得！');
        set(hObject, 'value', 0);  %弹起本按钮 
        return;
    end
    %% 打开串口后，允许串口发送数据，清空接收显示区，点亮串口状态指示灯，
    %% 并更改本按钮文本为“关闭串口”
    set(handles.period_send, 'Enable', 'on');  %启用【自动发送】按钮
    set(handles.manual_send, 'Enable', 'on');  %启用【手动发送】按钮
    
%%    set(handles.xianshi, 'string', ''); %清空接收显示区
    
%     set(handles.activex1, 'value', 1);  %点亮串口状态指示灯
    set(hObject, 'String', '关闭串口');  %设置本按钮文本为“关闭串口”
else  %若关闭串口
    %% 停止并删除定时器
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    %% 停止并删除串口对象
    scoms = instrfind;
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
    %% 禁用【自动发送】和【手动发送】按钮，熄灭串口状态指示灯
    set(handles.period_send, 'Enable', 'off', 'value', 0); %禁用【自动发送】按钮
    set(handles.manual_send, 'Enable', 'off');  %禁用【手动发送】按钮
%     set(handles.activex1, 'value', 0);  %熄灭串口状态指示灯
    set(hObject, 'String', '打开串口');  %设置本按钮文本为“关闭串口”
    %% 使能数据格式选项
%%    set(handles.Data_Format_Confirm,'enable','on');
%%    set(handles.Half_Word_H_First,'enable','on');
%%    set(handles.Half_Word_L_First,'enable','on');
%%    set(handles.Byte_Enable,'enable','on');
end

               
        


function dataDisp(obj, event, handles)
%	串口的TimerFcn回调函数
%   串口数据显示
%% 获取参数
hasData = getappdata(handles.figure1, 'hasData'); %串口是否收到数据
strRec = getappdata(handles.figure1, 'strRec');   %串口数据的字符串形式，定时显示该数据
numRec = getappdata(handles.figure1, 'numRec');   %串口接收到的数据个数
%% 若串口没有接收到数据，先尝试接收串口数据
if ~hasData
    bytes(obj, event, handles);
end
%% 若串口有数据，显示串口数据
if hasData
    %% 给数据显示模块加互斥锁
    %% 在执行显示数据模块时，不接受串口数据，即不执行BytesAvailableFcn回调函数
    setappdata(handles.figure1, 'isShow', true); 
    %% 若要显示的字符串长度超过10000，清空显示区
    if length(strRec) > 10000
        strRec = '';
        setappdata(handles.figure1, 'strRec', strRec);
    end
    %% 显示数据
    set(handles.xianshi, 'string', strRec);
    %% 更新接收计数
    set(handles.rec,'string', numRec);
    %% 更新hasData标志，表明串口数据已经显示
    setappdata(handles.figure1, 'hasData', false);
    %% 给数据显示模块解锁
    setappdata(handles.figure1, 'isShow', false);
end

function dataDisp1(obj, event, handles)
   n_bytes = get(obj,'BytesAvailable');     %% 数据总数量
   if n_bytes      %% 有效读取 防止Matlab延迟进入或误进入
   Data = fread(obj, n_bytes, 'uchar')';     %% 读走数据并存入Data中 直接为十进制数值形式
   
   StartByteFirst_Index = find(Data == 254);   %% 找寻可能的帧起始标志位第一个 0xfe
   StartByteSecond_Index = find(Data == 255);   %% 找寻可能的帧起始标志位第二个 0xff
  
   StartByteSecond_Index1 = StartByteSecond_Index - 1; %% 相邻位自减1 使真正的帧标志位0xff 对正 0xfe            
%% Start_Index = find(Start_Index_Temp);   %% 帧起始标志位为2个 0xfe + 0xff   
   StartIndex_Real = intersect(StartByteFirst_Index,StartByteSecond_Index1) + 1 ;    %% 找出被帧隔离的数据索引值(数据中可以找到的帧起始标志位0xff位置)       
   
 %    if StartIndex_Real(1) == 22
 %      display('Empty detected!');
 %    end
   
%    display(StartIndex_Real);
%  if ~isempty(StartByteSecond_Index)   %% 有BUG? 
   if StartByteSecond_Index(1) == 1             %% 可能的帧数据位错开了  状况1 状况描述：...,Data,Data,StartByteFirst||StartByteSecond,Data,Data,....  
      if getappdata(handles.figure1,'isLast_Serial_StartByte_First');  %% 确实出现了帧起始标志位错位
      %% 准备填补函数
       StartIndex_Real = [1,StartIndex_Real];     %% 增加新的数据头位置
       setappdata(handles.figure1,'isLast_Serial_StartByte_First',false);  %% 清标志位  
%       display('detected!');
%      display(StartIndex_Real);
      end  
   end
   
   Num_StartIndex_Real = numel(StartIndex_Real);
%  end
   
   if StartByteFirst_Index(end) == n_bytes   %% 串口缓冲区最后一位是数据的帧头第一个数据 0xfe     
      setappdata(handles.figure1,'isLast_Serial_StartByte_First',true);   
%      display('Cross!');          % 状况2 状况描述： ...,Data,Data, StartByteFirst||StartByteSecond,Data,...     
   end
   
    if StartIndex_Real(1) > 2    %% 出现定时器读取数据周期中同一帧数据隔离
    Last_Serial_Data1 = getappdata(handles.figure1,'Last_Serial_Data');  %%读取上次未读完的数据
    Last_Serial_Data2 = Data(1:StartIndex_Real(1) - 2);  %% 读取上次没有完全接收完的数据
    if StartIndex_Real(1) < 22 
    Last_Serial_Data2 = [zeros(1,20 - numel(Last_Serial_Data2)),Last_Serial_Data2];
    end
    
   if numel(Last_Serial_Data1) ~=numel(Last_Serial_Data2)  % 不知为何这里会出现BUG 常规理解是不会出现的 这里的if应该是不可能进入的 
       %但是Matlab 在开启串口的时候报错 出现 ？？？Matrix dimensions must agree.  Last_Data
       %= Last_Serial_Data1 + Last_Serial_Data2 ; %加上if 来避开BUG?
       display(numel(Last_Serial_Data1));
       display(numel(Last_Serial_Data2));
   else
    Last_Data = Last_Serial_Data1 + Last_Serial_Data2 ;   %% Last_Data 即为合并修复后的数据
   end
    
    %% 试写数据处理函数  前提 已经获得了一帧完整的数据共20个 低位在前 高位在后 
%    display(Last_Data);  
     setappdata(handles.figure1,'Serial_Data_2BeContinued',false);
    end
   
   if StartIndex_Real(end) > n_bytes - 20    %% 一帧数据被中途断开 
       setappdata(handles.figure1,'Serial_Data_2BeContinued',true);      %% 更新中断标志      
   %% 存取未读完的数据     %% 状况  ...,StartByteFirst,StartByteSecond,Data,...,Data|  接收到的Data不满一帧
   %% 把数据读走   
%   if StartIndex_Real(end) == n_bytes
%       display('Empty detected!1');
%   end
   
   Data1 = Data(StartIndex_Real(end) + 1 : n_bytes);  %%
   if isempty(Data1) 
      Last_Serial_Data = zeros(1,20);
%      display('Empty detected!2');
   else      
   Data1_Num = numel(Data1);
   Last_Serial_Data = [Data1,zeros(1,20 - Data1_Num)]; 
   end       
   setappdata(handles.figure1,'Last_Serial_Data',Last_Serial_Data);   %% 存储数据
%   display(Last_Serial_Data);
   %% 这里方法笨了一点？有没有更好的方法？ 
   end
          
   Mul_Matrix = [1;256;1;256;1;256;1;256;1;256;1;256;1;256;1;256;1;256;1;256];   %% 可视为权重数组
       
    if StartIndex_Real(end) > n_bytes - 20   % 出现数据错位
       Aver_Data = zeros(1,Num_StartIndex_Real - 1,'double');   %预分配空间 提高效率 
        for Count = 1 :1: Num_StartIndex_Real - 1  
     Aver_Data(Count) =  Data(StartIndex_Real(Count)+1:StartIndex_Real(Count)+20)*Mul_Matrix/4096*0.33;  %通过预先准备好的矩阵Mul_Matrix 使用矩阵相乘就获得了平均值
%     Aver_Data(Count) = (Aver_Data/4096)*0.33;
%    display(Aver_Data);  
        end
      else   % 没有出现数据错位情况 一般比较少见
   %% 获得每帧数据中的20个一帧数据 共计有X帧(数量不定) 
     Aver_Data = zeros(1,Num_StartIndex_Real,'double');  %预分配空间 提高效率 
     for Count = 1 :1: Num_StartIndex_Real            
     Aver_Data(Count) =  Data(StartIndex_Real(Count)+1:StartIndex_Real(Count)+20)*Mul_Matrix/4096*0.33;
 %    Aver_Data(Count) = (Aver_Data/4096)*0.33;
   %   display(Aver_Data);
     end
    end       
    
       %% 新增加对Last_Data 的处理 不要丢失这个读取错位后修复的数据
    if StartIndex_Real(1) > 2   % if exist('Last_Data') 这样来表达更好理解 但是不知道如何来写这个函数 暂时这么做 
    %% 表明已经有合并修复的数据
    Aver_Data_Last = Last_Data * Mul_Matrix/4096*0.33;
    Aver_Data = [Aver_Data_Last, Aver_Data];   
%    display('Data_Added!');
    end  %% end if
      
    %% 更新数据 
  Aver_Data_Rec = getappdata(handles.figure1,'Aver_Data_Rec');
%  display(Aver_Data_Rec);
  Aver_Data_Rec = [Aver_Data_Rec,Aver_Data];
  setappdata(handles.figure1,'Aver_Data_Rec',Aver_Data_Rec);
 
  %% 准备画图 把数据Aver_Data 画到Data_Axes 上来观察 这里是动态显示 一次显示不能超过100个数据点
 if numel(Aver_Data_Rec) > 100
      Data_2BeDisplayed = Aver_Data_Rec(numel(Aver_Data_Rec) - 100 : numel(Aver_Data_Rec));
      plot(handles.Data_Axes,Data_2BeDisplayed,':.r');
  else
      plot(handles.Data_Axes,Aver_Data_Rec,':.r');
  end
 numRec = getappdata(handles.figure1,'numRec');
 %numRec = numRec + n_bytes ;
 numRec = numRec + numel(Aver_Data);
 set(handles.rec, 'String', numRec);
 setappdata(handles.figure1,'numRec',numRec);
% display(numRec);
 
   end
 
   
            

function bytes(obj, ~, handles)
%   串口的BytesAvailableFcn回调函数
%   串口接收数据
%% 获取参数
strRec = getappdata(handles.figure1, 'strRec'); %获取串口要显示的数据
numRec = getappdata(handles.figure1, 'numRec'); %获取串口已接收数据的个数
isStopDisp = getappdata(handles.figure1, 'isStopDisp'); %是否按下了【停止显示】按钮
isHexDisp = getappdata(handles.figure1, 'isHexDisp'); %是否十六进制显示
isShow = getappdata(handles.figure1, 'isShow');  %是否正在执行显示数据操作
%% 若正在执行数据显示操作，暂不接收串口数据
if isShow
    return;
end
%% 获取串口可获取的数据个数
n = get(obj, 'BytesAvailable');
display(n);
%% 若串口有数据，接收所有数据
if n
    %% 更新hasData参数，表明串口有数据需要显示
    setappdata(handles.figure1, 'hasData', true);
     display('Data Detected!');
    %% 读取串口数据
    a = fread(obj, n, 'uchar');
    display(a);
    %% 若没有停止显示，将接收到的数据解算出来，准备显示
    if ~isStopDisp 
        %% 根据进制显示的状态，解析数据为要显示的字符串
        if ~isHexDisp 
            c = char(a');
        else
            strHex = dec2hex(a')';
            strHex2 = [strHex; blanks(size(a, 1))];
            c = strHex2(:)';
        end
        %% 更新已接收的数据个数
        numRec = numRec + size(a, 1);
        %% 更新要显示的字符串
        strRec = [strRec c];
    end
    %% 更新参数
    setappdata(handles.figure1, 'numRec', numRec); %更新已接收的数据个数
    setappdata(handles.figure1, 'strRec', strRec); %更新要显示的字符串
end


function qingkong_Callback(hObject, eventdata, handles)
%% 清空要显示的字符串
setappdata(handles.figure1, 'strRec', '');
%% 清空显示
% set(handles.xianshi, 'String', '');

function stop_disp_Callback(hObject, eventdata, handles)
%% 根据【停止显示】按钮的状态，更新isStopDisp参数
if get(hObject, 'Value')
    isStopDisp = true;
else
    isStopDisp = false;
end
setappdata(handles.figure1, 'isStopDisp', isStopDisp);

function radiobutton1_Callback(hObject, eventdata, handles)

function radiobutton2_Callback(hObject, eventdata, handles)

function togglebutton4_Callback(hObject, eventdata, handles)

function hex_disp_Callback(hObject, eventdata, handles)
%% 根据【十六进制显示】复选框的状态，更新isHexDisp参数
if get(hObject, 'Value')
    isHexDisp = true;
else
    isHexDisp = false;
end
setappdata(handles.figure1, 'isHexDisp', isHexDisp);

function manual_send_Callback(hObject, eventdata, handles)
scom = get(handles.figure1, 'UserData');
numSend = getappdata(handles.figure1, 'numSend');
val = get(handles.sends, 'UserData');
numSend = numSend + length(val);
set(handles.trans, 'string', num2str(numSend));
setappdata(handles.figure1, 'numSend', numSend);
%% 若要发送的数据不为空，发送数据
if ~isempty(val)
    %% 设置倒计数的初值
    n = 1000;
    while n
        %% 获取串口的传输状态，若串口没有正在写数据，写入数据
        str = get(scom, 'TransferStatus');
        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
            fwrite(scom, val, 'uint8', 'async'); %数据写入串口
            break;
        end
        n = n - 1; %倒计数
    end
%% else  %% 新增测试
%%  msgbox('发送为空!');  
end


function clear_send_Callback(hObject, eventdata, handles)
%% 清空发送区
set(handles.sends, 'string', '')
%% 更新要发送的数据
set(handles.sends, 'UserData', []);

function checkbox2_Callback(hObject, eventdata, handles)


function period_send_Callback(hObject, eventdata, handles)
%   【自动发送】按钮的Callback回调函数
%% 若按下【自动发送】按钮，启动定时器；否则，停止并删除定时器
if get(hObject, 'value')
    display(get(handles.period1, 'string'));
    t1 = 0.001 * str2double(get(handles.period1, 'string'));%获取定时器周期
    t = timer('ExecutionMode','fixedrate', 'Period', t1, 'TimerFcn',...
        {@manual_send_Callback, handles}); %创建定时器
    set(handles.period1, 'Enable', 'off'); %禁用设置定时器周期的Edit Text对象
    set(handles.sends, 'Enable', 'inactive'); %禁用数据发送编辑区
    start(t);  %启动定时器
else
    set(handles.period1, 'Enable', 'on'); %启用设置定时器周期的Edit Text对象
    set(handles.sends, 'Enable', 'on');   %启用数据发送编辑区
    t = timerfind; %查找定时器
    stop(t); %停止定时器
    delete(t); %删除定时器
end

function period1_Callback(hObject, eventdata, handles)

function period1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clear_count_Callback(hObject, eventdata, handles)
%% 计数清零，并更新参数numRec和numSend
set([handles.rec, handles.trans], 'string', '0')
setappdata(handles.figure1, 'numRec', 0);
setappdata(handles.figure1, 'numSend', 0);

function copy_data_Callback(hObject, eventdata, handles)
%% 设置是否允许复制接收数据显示区内的数据
if get(hObject,'value')
    set(handles.xianshi, 'enable', 'on');
else
    set(handles.xianshi, 'enable', 'inactive');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
%   关闭窗口时，检查定时器和串口是否已关闭
%   若没有关闭，则先关闭
%% 查找定时器
t = timerfind;
%% 若存在定时器对象，停止并关闭
if ~isempty(t)
    stop(t);  %若定时器没有停止，则停止定时器
    delete(t);
end
%% 查找串口对象
scoms = instrfind;
%% 尝试停止、关闭删除串口对象
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
end
%% 关闭窗口
delete(hObject);

function hex_send_Callback(hObject, eventdata, handles)
%% 根据【十六进制发送】复选框的状态，更新isHexSend参数
if get(hObject,'value')
    isHexSend = true;
else
    isHexSend = false;
end
setappdata(handles.figure1, 'isHexSend', isHexSend);
%% 更新要发送的数据
sends_Callback(handles.sends, eventdata, handles);


function sends_Callback(hObject, eventdata, handles)
%   数据发送编辑区的Callback回调函数
%   更新要发送的数据
%% 获取数据发送编辑区的字符串
str = get(hObject, 'string');
%% 获取参数isHexSend的值
isHexSend = getappdata(handles.figure1, 'isHexSend');
if ~isHexSend %若为ASCII值形式发送，直接将字符串转化为对应的数值
    val = double(str);
else  %若为十六进制发送，获取要发送的数据
    n = find(str == ' ');   %查找空格
    n =[0 n length(str)+1]; %空格的索引值
    %% 每两个相邻空格之间的字符串为数值的十六进制形式，将其转化为数值
    for i = 1 : length(n)-1 
        temp = str(n(i)+1 : n(i+1)-1);  %获得每段数据的长度，为数据转换为十进制做准备
        if ~rem(length(temp), 2)
            b{i} = reshape(temp, 2, [])'; %将每段十六进制字符串转化为单元数组
        else
            break;
        end
    end
    val = hex2dec(b)';     %将十六进制字符串转化为十进制数，等待写入串口
   
end
%% 更新要显示的数据
set(hObject, 'UserData', val); 
%% 自己的测试代码
 %% display(val);


function xianshi_Callback(hObject, eventdata, handles)
% hObject    handle to xianshi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xianshi as text
%        str2double(get(hObject,'String')) returns contents of xianshi as a double


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over rate.
function rate_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on sends and none of its controls.
function sends_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to sends (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Half_Word_H_First.
function Half_Word_H_First_Callback(hObject, eventdata, handles)
% hObject    handle to Half_Word_H_First (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Half_Word_H_First


% --- Executes on button press in Byte_Enable.
function Byte_Enable_Callback(hObject, eventdata, handles)
% hObject    handle to Byte_Enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Byte_Enable


% --- Executes on button press in togglebutton7.
function togglebutton7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton7


% --- Executes on button press in togglebutton8.
function togglebutton8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton8




        


% --- Executes on button press in PushToNew1.
function PushToNew1_Callback(hObject, eventdata, handles)
% hObject    handle to PushToNew1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PushToNew1
h =  figure(NewFigure1);
set(h,'Visible','on');




% --- Executes on button press in PushToNew2.
function PushToNew2_Callback(hObject, eventdata, handles)
% hObject    handle to PushToNew2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% 调用另外一个GUI 把收到的全局数据通过plot画在坐标轴axes上
h = handles.figure1;
Newfigure1(h);




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
