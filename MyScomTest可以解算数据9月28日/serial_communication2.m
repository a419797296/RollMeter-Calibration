function varargout = serial_communication2(varargin)
%   ���ߣ��޻���
%   ���ܣ������շ�
%   �汾��20101103 V2.0
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
%% ��ʼ������
hasData = false; %���������Ƿ���յ�����
isShow = false;  %�����Ƿ����ڽ���������ʾ�����Ƿ�����ִ�к���dataDisp
isStopDisp = false;  %�����Ƿ����ˡ�ֹͣ��ʾ����ť
isHexDisp = false;   %�����Ƿ�ѡ�ˡ�ʮ��������ʾ��
isHexSend = false;   %�����Ƿ�ѡ�ˡ�ʮ�����Ʒ��͡�
numRec = 0;    %�����ַ�����
numSend = 0;   %�����ַ�����
strRec = '';   %�ѽ��յ��ַ���
Last_Serial_Data = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]; % 1*20 double

Serial_Data_Format = 0;  %Ĭ��Ϊ8λ�ֽ�����

isLast_Serial_StartByte_First = false ;

%% 10��11�� �������ݽ������� 
Aver_Data_Rec = 0;
Serial_Data_2BeContinued = false ;

%% ������������ΪӦ�����ݣ����봰�ڶ�����
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
%   ����/�رմ��ڡ���ť�Ļص�����
%    �򿪴��ڣ�����ʼ����ز���

%% �����¡��򿪴��ڡ���ť���򿪴���
if get(hObject, 'value')
    %% ��ȡ���ڵĶ˿���
    com_n = sprintf('com%d', get(handles.com, 'value'));
    %% ����չʾ�˲�ͬ����ʹ��PopUp�����˵��ķ���1
    %% ��ȡ������
    rates = [300 600 1200 2400 4800 9600 19200 38400 43000 56000 57600 115200];
     %% �����൱��Ŀ¼������ 'value'�е�ֵΪ����ֵ ratesΪö�ٳ���Ŀ¼
     %% ����չʾ�˲�ͬ����ʹ��PopUp�����˵��ķ���2
    baud_rate = rates(get(handles.rate, 'value'));
    %% ��ȡУ��λ����
    switch get(handles.jiaoyan, 'value')
        case 1
            jiaoyan = 'none';
        case 2
            jiaoyan = 'odd';
        case 3
            jiaoyan = 'even';
    end
    %% ����չʾ�˲�ͬ����ʹ��PopUp�����˵��ķ���3
    %% ��ȡ����λ����
    data_bits = 5 + get(handles.data_bits, 'value');
    %% ����չʾ�˲�ͬ����ʹ��PopUp�����˵��ķ���4
    %% ��ȡֹͣλ����
    stop_bits = get(handles.stop_bits, 'value');
    %% �������ڶ���
    scom = serial(com_n);
    %% ���ô������ԣ�ָ����ص�����
    set(scom, 'BaudRate', baud_rate, 'Parity', jiaoyan, 'DataBits',...
        data_bits, 'StopBits', stop_bits,'InputBufferSize',1000,...  %%�鱾�ϵ�˵���ƺ����� �����������Բ�ֹ512 ���Ե��ӽ�5000
     'TimerPeriod', 0.1, 'timerfcn', {@dataDisp1, handles}); %%  ... % ���ڻ��������10�����ݺ�ŵ��øú�����  %% 9��21�ղ��� %%    'BytesAvailableFcn', {@dataDisp, handles}, 'BytesAvailableFcnCount', 20,...   %%@dataDisp bytes
    %% �ֽ���ģʽ ��ֹģʽ
    %% �����ڶ���ľ����Ϊ�û����ݣ����봰�ڶ���
    set(handles.figure1, 'UserData', scom);
    %% ���Դ򿪴���
    try
        fopen(scom);  %�򿪴���
    catch   % �����ڴ�ʧ�ܣ���ʾ�����ڲ��ɻ�ã���
        msgbox('���ڲ��ɻ�ã�');
        set(hObject, 'value', 0);  %���𱾰�ť 
        return;
    end
    %% �򿪴��ں������ڷ������ݣ���ս�����ʾ������������״ָ̬ʾ�ƣ�
    %% �����ı���ť�ı�Ϊ���رմ��ڡ�
    set(handles.period_send, 'Enable', 'on');  %���á��Զ����͡���ť
    set(handles.manual_send, 'Enable', 'on');  %���á��ֶ����͡���ť
    
%%    set(handles.xianshi, 'string', ''); %��ս�����ʾ��
    
%     set(handles.activex1, 'value', 1);  %��������״ָ̬ʾ��
    set(hObject, 'String', '�رմ���');  %���ñ���ť�ı�Ϊ���رմ��ڡ�
else  %���رմ���
    %% ֹͣ��ɾ����ʱ��
    t = timerfind;
    if ~isempty(t)
        stop(t);
        delete(t);
    end
    %% ֹͣ��ɾ�����ڶ���
    scoms = instrfind;
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
    %% ���á��Զ����͡��͡��ֶ����͡���ť��Ϩ�𴮿�״ָ̬ʾ��
    set(handles.period_send, 'Enable', 'off', 'value', 0); %���á��Զ����͡���ť
    set(handles.manual_send, 'Enable', 'off');  %���á��ֶ����͡���ť
%     set(handles.activex1, 'value', 0);  %Ϩ�𴮿�״ָ̬ʾ��
    set(hObject, 'String', '�򿪴���');  %���ñ���ť�ı�Ϊ���رմ��ڡ�
    %% ʹ�����ݸ�ʽѡ��
%%    set(handles.Data_Format_Confirm,'enable','on');
%%    set(handles.Half_Word_H_First,'enable','on');
%%    set(handles.Half_Word_L_First,'enable','on');
%%    set(handles.Byte_Enable,'enable','on');
end

               
        


function dataDisp(obj, event, handles)
%	���ڵ�TimerFcn�ص�����
%   ����������ʾ
%% ��ȡ����
hasData = getappdata(handles.figure1, 'hasData'); %�����Ƿ��յ�����
strRec = getappdata(handles.figure1, 'strRec');   %�������ݵ��ַ�����ʽ����ʱ��ʾ������
numRec = getappdata(handles.figure1, 'numRec');   %���ڽ��յ������ݸ���
%% ������û�н��յ����ݣ��ȳ��Խ��մ�������
if ~hasData
    bytes(obj, event, handles);
end
%% �����������ݣ���ʾ��������
if hasData
    %% ��������ʾģ��ӻ�����
    %% ��ִ����ʾ����ģ��ʱ�������ܴ������ݣ�����ִ��BytesAvailableFcn�ص�����
    setappdata(handles.figure1, 'isShow', true); 
    %% ��Ҫ��ʾ���ַ������ȳ���10000�������ʾ��
    if length(strRec) > 10000
        strRec = '';
        setappdata(handles.figure1, 'strRec', strRec);
    end
    %% ��ʾ����
    set(handles.xianshi, 'string', strRec);
    %% ���½��ռ���
    set(handles.rec,'string', numRec);
    %% ����hasData��־���������������Ѿ���ʾ
    setappdata(handles.figure1, 'hasData', false);
    %% ��������ʾģ�����
    setappdata(handles.figure1, 'isShow', false);
end

function dataDisp1(obj, event, handles)
   n_bytes = get(obj,'BytesAvailable');     %% ����������
   if n_bytes      %% ��Ч��ȡ ��ֹMatlab�ӳٽ���������
   Data = fread(obj, n_bytes, 'uchar')';     %% �������ݲ�����Data�� ֱ��Ϊʮ������ֵ��ʽ
   
   StartByteFirst_Index = find(Data == 254);   %% ��Ѱ���ܵ�֡��ʼ��־λ��һ�� 0xfe
   StartByteSecond_Index = find(Data == 255);   %% ��Ѱ���ܵ�֡��ʼ��־λ�ڶ��� 0xff
  
   StartByteSecond_Index1 = StartByteSecond_Index - 1; %% ����λ�Լ�1 ʹ������֡��־λ0xff ���� 0xfe            
%% Start_Index = find(Start_Index_Temp);   %% ֡��ʼ��־λΪ2�� 0xfe + 0xff   
   StartIndex_Real = intersect(StartByteFirst_Index,StartByteSecond_Index1) + 1 ;    %% �ҳ���֡�������������ֵ(�����п����ҵ���֡��ʼ��־λ0xffλ��)       
   
 %    if StartIndex_Real(1) == 22
 %      display('Empty detected!');
 %    end
   
%    display(StartIndex_Real);
%  if ~isempty(StartByteSecond_Index)   %% ��BUG? 
   if StartByteSecond_Index(1) == 1             %% ���ܵ�֡����λ����  ״��1 ״��������...,Data,Data,StartByteFirst||StartByteSecond,Data,Data,....  
      if getappdata(handles.figure1,'isLast_Serial_StartByte_First');  %% ȷʵ������֡��ʼ��־λ��λ
      %% ׼�������
       StartIndex_Real = [1,StartIndex_Real];     %% �����µ�����ͷλ��
       setappdata(handles.figure1,'isLast_Serial_StartByte_First',false);  %% ���־λ  
%       display('detected!');
%      display(StartIndex_Real);
      end  
   end
   
   Num_StartIndex_Real = numel(StartIndex_Real);
%  end
   
   if StartByteFirst_Index(end) == n_bytes   %% ���ڻ��������һλ�����ݵ�֡ͷ��һ������ 0xfe     
      setappdata(handles.figure1,'isLast_Serial_StartByte_First',true);   
%      display('Cross!');          % ״��2 ״�������� ...,Data,Data, StartByteFirst||StartByteSecond,Data,...     
   end
   
    if StartIndex_Real(1) > 2    %% ���ֶ�ʱ����ȡ����������ͬһ֡���ݸ���
    Last_Serial_Data1 = getappdata(handles.figure1,'Last_Serial_Data');  %%��ȡ�ϴ�δ���������
    Last_Serial_Data2 = Data(1:StartIndex_Real(1) - 2);  %% ��ȡ�ϴ�û����ȫ�����������
    if StartIndex_Real(1) < 22 
    Last_Serial_Data2 = [zeros(1,20 - numel(Last_Serial_Data2)),Last_Serial_Data2];
    end
    
   if numel(Last_Serial_Data1) ~=numel(Last_Serial_Data2)  % ��֪Ϊ����������BUG ��������ǲ�����ֵ� �����ifӦ���ǲ����ܽ���� 
       %����Matlab �ڿ������ڵ�ʱ�򱨴� ���� ������Matrix dimensions must agree.  Last_Data
       %= Last_Serial_Data1 + Last_Serial_Data2 ; %����if ���ܿ�BUG?
       display(numel(Last_Serial_Data1));
       display(numel(Last_Serial_Data2));
   else
    Last_Data = Last_Serial_Data1 + Last_Serial_Data2 ;   %% Last_Data ��Ϊ�ϲ��޸��������
   end
    
    %% ��д���ݴ�����  ǰ�� �Ѿ������һ֡���������ݹ�20�� ��λ��ǰ ��λ�ں� 
%    display(Last_Data);  
     setappdata(handles.figure1,'Serial_Data_2BeContinued',false);
    end
   
   if StartIndex_Real(end) > n_bytes - 20    %% һ֡���ݱ���;�Ͽ� 
       setappdata(handles.figure1,'Serial_Data_2BeContinued',true);      %% �����жϱ�־      
   %% ��ȡδ���������     %% ״��  ...,StartByteFirst,StartByteSecond,Data,...,Data|  ���յ���Data����һ֡
   %% �����ݶ���   
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
   setappdata(handles.figure1,'Last_Serial_Data',Last_Serial_Data);   %% �洢����
%   display(Last_Serial_Data);
   %% ���﷽������һ�㣿��û�и��õķ����� 
   end
          
   Mul_Matrix = [1;256;1;256;1;256;1;256;1;256;1;256;1;256;1;256;1;256;1;256];   %% ����ΪȨ������
       
    if StartIndex_Real(end) > n_bytes - 20   % �������ݴ�λ
       Aver_Data = zeros(1,Num_StartIndex_Real - 1,'double');   %Ԥ����ռ� ���Ч�� 
        for Count = 1 :1: Num_StartIndex_Real - 1  
     Aver_Data(Count) =  Data(StartIndex_Real(Count)+1:StartIndex_Real(Count)+20)*Mul_Matrix/4096*0.33;  %ͨ��Ԥ��׼���õľ���Mul_Matrix ʹ�þ�����˾ͻ����ƽ��ֵ
%     Aver_Data(Count) = (Aver_Data/4096)*0.33;
%    display(Aver_Data);  
        end
      else   % û�г������ݴ�λ��� һ��Ƚ��ټ�
   %% ���ÿ֡�����е�20��һ֡���� ������X֡(��������) 
     Aver_Data = zeros(1,Num_StartIndex_Real,'double');  %Ԥ����ռ� ���Ч�� 
     for Count = 1 :1: Num_StartIndex_Real            
     Aver_Data(Count) =  Data(StartIndex_Real(Count)+1:StartIndex_Real(Count)+20)*Mul_Matrix/4096*0.33;
 %    Aver_Data(Count) = (Aver_Data/4096)*0.33;
   %   display(Aver_Data);
     end
    end       
    
       %% �����Ӷ�Last_Data �Ĵ��� ��Ҫ��ʧ�����ȡ��λ���޸�������
    if StartIndex_Real(1) > 2   % if exist('Last_Data') ��������������� ���ǲ�֪�������д������� ��ʱ��ô�� 
    %% �����Ѿ��кϲ��޸�������
    Aver_Data_Last = Last_Data * Mul_Matrix/4096*0.33;
    Aver_Data = [Aver_Data_Last, Aver_Data];   
%    display('Data_Added!');
    end  %% end if
      
    %% �������� 
  Aver_Data_Rec = getappdata(handles.figure1,'Aver_Data_Rec');
%  display(Aver_Data_Rec);
  Aver_Data_Rec = [Aver_Data_Rec,Aver_Data];
  setappdata(handles.figure1,'Aver_Data_Rec',Aver_Data_Rec);
 
  %% ׼����ͼ ������Aver_Data ����Data_Axes �����۲� �����Ƕ�̬��ʾ һ����ʾ���ܳ���100�����ݵ�
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
%   ���ڵ�BytesAvailableFcn�ص�����
%   ���ڽ�������
%% ��ȡ����
strRec = getappdata(handles.figure1, 'strRec'); %��ȡ����Ҫ��ʾ������
numRec = getappdata(handles.figure1, 'numRec'); %��ȡ�����ѽ������ݵĸ���
isStopDisp = getappdata(handles.figure1, 'isStopDisp'); %�Ƿ����ˡ�ֹͣ��ʾ����ť
isHexDisp = getappdata(handles.figure1, 'isHexDisp'); %�Ƿ�ʮ��������ʾ
isShow = getappdata(handles.figure1, 'isShow');  %�Ƿ�����ִ����ʾ���ݲ���
%% ������ִ��������ʾ�������ݲ����մ�������
if isShow
    return;
end
%% ��ȡ���ڿɻ�ȡ�����ݸ���
n = get(obj, 'BytesAvailable');
display(n);
%% �����������ݣ�������������
if n
    %% ����hasData����������������������Ҫ��ʾ
    setappdata(handles.figure1, 'hasData', true);
     display('Data Detected!');
    %% ��ȡ��������
    a = fread(obj, n, 'uchar');
    display(a);
    %% ��û��ֹͣ��ʾ�������յ������ݽ��������׼����ʾ
    if ~isStopDisp 
        %% ���ݽ�����ʾ��״̬����������ΪҪ��ʾ���ַ���
        if ~isHexDisp 
            c = char(a');
        else
            strHex = dec2hex(a')';
            strHex2 = [strHex; blanks(size(a, 1))];
            c = strHex2(:)';
        end
        %% �����ѽ��յ����ݸ���
        numRec = numRec + size(a, 1);
        %% ����Ҫ��ʾ���ַ���
        strRec = [strRec c];
    end
    %% ���²���
    setappdata(handles.figure1, 'numRec', numRec); %�����ѽ��յ����ݸ���
    setappdata(handles.figure1, 'strRec', strRec); %����Ҫ��ʾ���ַ���
end


function qingkong_Callback(hObject, eventdata, handles)
%% ���Ҫ��ʾ���ַ���
setappdata(handles.figure1, 'strRec', '');
%% �����ʾ
% set(handles.xianshi, 'String', '');

function stop_disp_Callback(hObject, eventdata, handles)
%% ���ݡ�ֹͣ��ʾ����ť��״̬������isStopDisp����
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
%% ���ݡ�ʮ��������ʾ����ѡ���״̬������isHexDisp����
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
%% ��Ҫ���͵����ݲ�Ϊ�գ���������
if ~isempty(val)
    %% ���õ������ĳ�ֵ
    n = 1000;
    while n
        %% ��ȡ���ڵĴ���״̬��������û������д���ݣ�д������
        str = get(scom, 'TransferStatus');
        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
            fwrite(scom, val, 'uint8', 'async'); %����д�봮��
            break;
        end
        n = n - 1; %������
    end
%% else  %% ��������
%%  msgbox('����Ϊ��!');  
end


function clear_send_Callback(hObject, eventdata, handles)
%% ��շ�����
set(handles.sends, 'string', '')
%% ����Ҫ���͵�����
set(handles.sends, 'UserData', []);

function checkbox2_Callback(hObject, eventdata, handles)


function period_send_Callback(hObject, eventdata, handles)
%   ���Զ����͡���ť��Callback�ص�����
%% �����¡��Զ����͡���ť��������ʱ��������ֹͣ��ɾ����ʱ��
if get(hObject, 'value')
    display(get(handles.period1, 'string'));
    t1 = 0.001 * str2double(get(handles.period1, 'string'));%��ȡ��ʱ������
    t = timer('ExecutionMode','fixedrate', 'Period', t1, 'TimerFcn',...
        {@manual_send_Callback, handles}); %������ʱ��
    set(handles.period1, 'Enable', 'off'); %�������ö�ʱ�����ڵ�Edit Text����
    set(handles.sends, 'Enable', 'inactive'); %�������ݷ��ͱ༭��
    start(t);  %������ʱ��
else
    set(handles.period1, 'Enable', 'on'); %�������ö�ʱ�����ڵ�Edit Text����
    set(handles.sends, 'Enable', 'on');   %�������ݷ��ͱ༭��
    t = timerfind; %���Ҷ�ʱ��
    stop(t); %ֹͣ��ʱ��
    delete(t); %ɾ����ʱ��
end

function period1_Callback(hObject, eventdata, handles)

function period1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function clear_count_Callback(hObject, eventdata, handles)
%% �������㣬�����²���numRec��numSend
set([handles.rec, handles.trans], 'string', '0')
setappdata(handles.figure1, 'numRec', 0);
setappdata(handles.figure1, 'numSend', 0);

function copy_data_Callback(hObject, eventdata, handles)
%% �����Ƿ������ƽ���������ʾ���ڵ�����
if get(hObject,'value')
    set(handles.xianshi, 'enable', 'on');
else
    set(handles.xianshi, 'enable', 'inactive');
end

function figure1_CloseRequestFcn(hObject, eventdata, handles)
%   �رմ���ʱ����鶨ʱ���ʹ����Ƿ��ѹر�
%   ��û�йرգ����ȹر�
%% ���Ҷ�ʱ��
t = timerfind;
%% �����ڶ�ʱ������ֹͣ���ر�
if ~isempty(t)
    stop(t);  %����ʱ��û��ֹͣ����ֹͣ��ʱ��
    delete(t);
end
%% ���Ҵ��ڶ���
scoms = instrfind;
%% ����ֹͣ���ر�ɾ�����ڶ���
try
    stopasync(scoms);
    fclose(scoms);
    delete(scoms);
end
%% �رմ���
delete(hObject);

function hex_send_Callback(hObject, eventdata, handles)
%% ���ݡ�ʮ�����Ʒ��͡���ѡ���״̬������isHexSend����
if get(hObject,'value')
    isHexSend = true;
else
    isHexSend = false;
end
setappdata(handles.figure1, 'isHexSend', isHexSend);
%% ����Ҫ���͵�����
sends_Callback(handles.sends, eventdata, handles);


function sends_Callback(hObject, eventdata, handles)
%   ���ݷ��ͱ༭����Callback�ص�����
%   ����Ҫ���͵�����
%% ��ȡ���ݷ��ͱ༭�����ַ���
str = get(hObject, 'string');
%% ��ȡ����isHexSend��ֵ
isHexSend = getappdata(handles.figure1, 'isHexSend');
if ~isHexSend %��ΪASCIIֵ��ʽ���ͣ�ֱ�ӽ��ַ���ת��Ϊ��Ӧ����ֵ
    val = double(str);
else  %��Ϊʮ�����Ʒ��ͣ���ȡҪ���͵�����
    n = find(str == ' ');   %���ҿո�
    n =[0 n length(str)+1]; %�ո������ֵ
    %% ÿ�������ڿո�֮����ַ���Ϊ��ֵ��ʮ��������ʽ������ת��Ϊ��ֵ
    for i = 1 : length(n)-1 
        temp = str(n(i)+1 : n(i+1)-1);  %���ÿ�����ݵĳ��ȣ�Ϊ����ת��Ϊʮ������׼��
        if ~rem(length(temp), 2)
            b{i} = reshape(temp, 2, [])'; %��ÿ��ʮ�������ַ���ת��Ϊ��Ԫ����
        else
            break;
        end
    end
    val = hex2dec(b)';     %��ʮ�������ַ���ת��Ϊʮ���������ȴ�д�봮��
   
end
%% ����Ҫ��ʾ������
set(hObject, 'UserData', val); 
%% �Լ��Ĳ��Դ���
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

%% ��������һ��GUI ���յ���ȫ������ͨ��plot����������axes��
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
