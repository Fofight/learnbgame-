s=xlsread('cast.xls');
ls=length(s);
plot(s)
[C,L] = wavedec(s,3,'db2');%ִ��3���źŷֽ⣬wavedec�Ƕ��ֽ⺯��
cA3 = appcoef(C,L,'db2',3);%��C�г�ȡ3�����ϵ����detcoefϸ��ϵ����ȡ��appcoef����ϵ����ȡ
cD3 = detcoef(C,L,3);%��C�г�ȡ3��2��1��ϸ��ϵ��
cD2 = detcoef(C,L,2);
cD1 = detcoef(C,L,1);
A3 = wrcoef('a',C,L,'db2',3);%��C���ؽ�3����ƣ�waverecȫ�ع���wrcoef��ѡ�����ع���upcoef��һ�ع�
D1 = wrcoef('d',C,L,'db2',1);%��C���ؽ�1��2��3��ϸ��ϵ��
D2 = wrcoef('d',C,L,'db2',2);
D3 = wrcoef('d',C,L,'db2',3);
subplot(2,2,1); plot(A3);%��ʾ3��ֽ�Ľ��
title('Approximation A3')
subplot(2,2,2); plot(D1);
title('Detail D1')
subplot(2,2,3); plot(D2);
title('Detail D2')
subplot(2,2,4); plot(D3);
title('Detail D3')
[thr,sorh,keepapp]=ddencmp('den','wv',s);
T1=thr
%��Ӳ��ֵȥ���ع�
cd1soft1=wthresh(cD1,'s',T1);
cd2soft1=wthresh(cD2,'s',T1);
cd3soft1=wthresh(cD3,'s',T1);
sc1=[cA3',cd3soft1',cd2soft1',cd1soft1']';
s1=waverec(sc1,L,'db2');
%����Ӳ��ֵȥ��
cd1hard1=wthresh(cD1,'h',T1(1));
cd2hard1=wthresh(cD2,'h',T1(1));
cd3hard1=wthresh(cD3,'h',T1(1));
hc1=[cA3',cd3hard1',cd2hard1',cd1hard1']';
h1=waverec(hc1,L,'db2');
%y3��ֵ����ȥ��
x3=length(cD3);
a=1;%����
n=3;%����
for i=1:x3
if abs(cD3(i))>=T1 
    l=abs(cD3(i))-T1;
    u=1-exp((-a)*(l.^2));
    h=(2*T1)/(1+exp(l.^n));
    ay3(i)=u*cD3(i)+(1-u)*sign(cD3(i))*(abs(cD3(i))-h);
else
   ay3(i)=0;
end;
end;
x2=length(cD2);
for i=1:x2
if abs(cD2(i))>=T1 
    l=abs(cD2(i))-T1;
    u=1-exp((-a)*(l.^2));
    h=(2*T1)/(1+exp(l.^n));
    ay2(i)=u*cD2(i)+(1-u)*sign(cD2(i))*(abs(cD2(i))-h);
else
    ay2(i)=0;
end;
end;
x1=length(cD1);
for i=1:x1
if abs(cD1(i))>=T1 
    l=abs(cD1(i))-T1;
    u=1-exp((-a)*(l.^2));
    h=(2*T1)/(1+exp(l.^n));
    ay1(i)=u*cD1(i)+(1-u)*sign(cD1(i))*(abs(cD1(i))-h);
else
    ay1(i)=0;
end;
end;
C1=[cA3',ay3,ay2,ay1];
W= waverec(C1,L,'db2');%��C���ؽ�3����ƣ�waverecȫ�ع���
%y4��ֵ����
k=2/3;%y4�Ĳ���
n1=1;%y4�Ĳ���
m=1;%y4�Ĳ���
for i=1:x3
if abs(cD3(i))>=T1
    by3(i)=cD3(i)-((T1*k*sign(cD3(i)))/(exp((abs(cD3(i))-T1)/n1)));
else
    by3(i)=(m*((cD3(i))^(2*n1+1)))/((2*n1)*(T1^(2*n1)));
end;
end;
for i=1:x2
if abs(cD2(i))>=T1
    by2(i)=cD2(i)-((T1*k*sign(cD2(i)))/(exp((abs(cD2(i))-T1)/n1)));
else
    by2(i)=(m*((cD2(i))^(2*n1+1)))/((2*n1)*(T1^(2*n1)));
end;
end;
for i=1:x1
if abs(cD1(i))>=T1
    by1(i)=cD1(i)-((T1*k*sign(cD1(i)))/(exp((abs(cD1(i))-T1)/n1)));
else
    by1(i)=(m*((cD1(i))^(2*n1+1)))/((2*n1)*(T1^(2*n1)));
end;
end;
C2=[cA3',by3,by2,by1];
W2= waverec(C2,L,'db2');
%y5��ֵ����
t0=2;%y5���м���ֵ
k1=1;%y5�Ĳ���
for i=1:x3
if abs(cD3(i))>=T1
   l1=((abs(cD3(i)))-T1)/2;
    u1=2*k1+1;
    th1=u1*(1+exp(l1));
    m1=abs(cD3(i)); 
    cy3(i)=(sign(cD3(i)))*(m1-((2*T1)/th1));
elseif abs(cD3(i))<t0
    cy3(i)=0;
else
    cy3(i)=(k1*((cD3(i))^(2*k1+1)))/((2*k1+1)*(T1^(2*k1)));
end;
end;
for i=1:x2
if abs(cD2(i))>=T1
   l1=((abs(cD2(i)))-T1)/2;
    u1=2*k1+1;
    th1=u1*(1+exp(l1));
    m1=abs(cD2(i)); 
    cy2(i)=(sign(cD2(i)))*(m1-((2*T1)/th1));
elseif abs(cD2(i))<t0
    cy2(i)=0;
else
    cy2(i)=(k1*((cD2(i))^(2*k1+1)))/((2*k1+1)*(T1^(2*k1)));
end;
end;
for i=1:x1
if abs(cD1(i))>=T1
   l1=((abs(cD1(i)))-T1)/2;
    u1=2*k1+1;
    th1=u1*(1+exp(l1));
    m1=abs(cD1(i)); 
    cy1(i)=(sign(cD1(i)))*(m1-((2*T1)/th1));
elseif abs(cD1(i))<t0
    cy1(i)=0;
else
    cy1(i)=(k1*((cD1(i))^(2*k1+1)))/((2*k1+1)*(T1^(2*k1)));
end;
end;
C3=[cA3',cy3,cy2,cy1];
W3= waverec(C3,L,'db2');
%����ֵ����
t0=T1;%����
k1=1;%����
t1=1.9*T1;%����
for i=1:x3
if abs(cD3(i))>=t1
   l1=((abs(cD3(i)))-T1)/2;
    u1=k1+1;
    h2=exp((abs(cD3(i)))-t1)*u1*(1+exp(l1));
    m1=abs(cD3(i)); 
    gcy3(i)=(sign(cD3(i)))*(m1-((2*T1)/h2));
elseif abs(cD3(i))<t0
    gcy3(i)=(k1*((cD3(i))^(2*k1+1)))/((k1+1)*(T1^(2*k1)));
else
    l1=((abs(cD3(i)))-T1)/2;
    u1=k1+1;
    h2=u1*(1+exp(l1));
    m1=abs(cD3(i)); 
    gcy3(i)=(sign(cD3(i)))*(m1-((2*T1)/h2));
end;
end;
for i=1:x2
if abs(cD2(i))>=t1
   l1=((abs(cD2(i)))-T1)/2;
    u1=k1+1;
    h2=exp((abs(cD2(i)))-t1)*u1*(1+exp(l1));
    m1=abs(cD2(i)); 
    gcy2(i)=(sign(cD2(i)))*(m1-((2*T1)/h2));
elseif abs(cD2(i))<t0
    gcy2(i)=(k1*((cD2(i))^(2*k1+1)))/((k1+1)*(T1^(2*k1)));
else 
    l1=((abs(cD2(i)))-T1)/2;
    u1=k1+1;
    h2=u1*(1+exp(l1));
    m1=abs(cD2(i)); 
    gcy2(i)=(sign(cD2(i)))*(m1-((2*T1)/h2));
end;
end;
for i=1:x1
if abs(cD1(i))>=t1
   l1=((abs(cD1(i)))-T1)/2;
    u1=k1+1;
     h2=exp((abs(cD1(i)))-t1)*u1*(1+exp(l1));
    m1=abs(cD1(i)); 
   gcy1(i)=(sign(cD1(i)))*(m1-((2*T1)/h2));
elseif abs(cD1(i))<t0
    gcy1(i)=(k1*((cD1(i))^(2*k1+1)))/((k1+1)*(T1^(2*k1)));
else
    l1=((abs(cD1(i)))-T1)/2;
    u1=k1+1;
    h2=u1*(1+exp(l1));
    m1=abs(cD1(i)); 
    gcy1(i)=(sign(cD1(i)))*(m1-((2*T1)/h2));
end;
end;
C4=[cA3',gcy3,gcy2,gcy1];
W4= waverec(C4,L,'db2');
hPs0=sum(s.^2);%�����signal power
hPn1=sum((s-s1).^2);
snr1=10*(log10(hPs0/hPn1));
hPn2=sum((s-h1).^2);
snr2=10*log10(hPs0/hPn2);
hPn3=sum((s-W').^2);
snr3=10*log10(hPs0/hPn3);
hPn4=sum((s-W3').^2);
snr4=10*log10(hPs0/hPn4);
hPn5=sum((s-W4').^2);
snr5=10*log10(hPs0/hPn5);
RMS1=sum((s-s1).^2)/ls;
RMS2=sum((s-h1).^2)/ls;
RMS3=sum((s-W').^2)/ls;
RMS4=sum((s-W3').^2)/ls;
RMS5=sum((s-W4').^2)/ls;
subplot(3,2,1);plot(s);title('ĳ��һ��ͨ����')%�ź�ͼ
subplot(3,2,2);plot(s1);title('ʹ������ֵȥ��������') 
subplot(3,2,3);plot(h1);title('ʹ��Ӳ��ֵȥ��������') 
subplot(3,2,4);plot(W);title('����9����ֵ����ȥ��������') 
subplot(3,2,5);plot(W3);title('����10����ֵ����ȥ��������')
subplot(3,2,6);plot(W4);title('����ֵ����ȥ��������')  
%������
SNR = [snr1,snr2,snr3,snr4,snr5]
RMS = [RMS1,RMS2,RMS3,RMS4,RMS5]
