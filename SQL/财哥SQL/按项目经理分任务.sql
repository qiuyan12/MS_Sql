
select t1.fnumber ����,t1.fname ����,t1.fmodel ���,t1.f_105 ����,f_106 ���û���,f_107 ��������
from t_icitem t1 where left(t1.fnumber,1) in ('a','p','j','x','y') and fitemid not in(select fitemid from icbom) order by fnumber


select t1.fnumber ����,t1.fname ����,t1.fmodel ���,t1.f_105 ����,f_106 ���û���,f_107 ��������
from t_icitem t1 where left(t1.fnumber,1) in ('a','p','j','x','y') and fitemid  in(select fitemid from icbom) order by fnumber


select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='300402'
select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='300450'
select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='300330'
select fitemid,fnumber,fname,fmodel from t_icitem where fshortnumber='301339'


select t1.fbomnumber,t2.fnumber,t2.fname,t4.fitemid,t4.fnumber,t4.fname 
--update t1 set fitemid=66875
from icbom t1 
inner join icbomchild t3 on t1.finterid=t3.finterid
inner join t_icitem t4 on t3.fitemid=t4.fitemid
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where t4.fshortnumber in('300450','500450')

select * 
--update t1 set fitemid=66937
from icbomchild t1 where fitemid=65691

select max(fshortnumber) from t_icitem where fnumber like '3.%'


select fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then 'δ���' else '���' end as ���״̬ from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and t1.fstatus=0

--��ռΰ
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40113
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(fnumber,6,2) in ('01','02','03')

--������
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40114
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(fnumber,6,2) in ('04','05','06','08','09','14','21','19')
order by t2.fnumber


--������
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40115
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(fnumber,6,2) in ('07','10','11','12','13','15','16')



--����
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40116
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('j','x') 


--��ӡ��
select fnumber,fname,fmodel,substring(fnumber,6,2),t3.f_128
--update t3 set f_128=40115
from t_icitem t2  
inner join t_ICItemCustom t3 on t2.fitemid=t3.fitemid
where left(t2.fnumber,1) in ('y') 



--��ѯ��׼��Ʒδ���BOM����
select t3.fname as �з�����,fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then 'δ���' else '���' end as BOM���״̬,case t2.f_126 when 40019 then '��' else ' 'end as �Ƿ��Ʒ���� from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') and t1.fstatus=0
order by t2.f_128,t2.fnumber


select t3.fname as �з�����,count(*) as δ���BOM�� from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
inner join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') and t1.fstatus=0
group by t3.fname


--��ѯ���Ի���Ʒδ���BOM����
select t3.fname as �з�����,fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then 'δ���' else '���' end as BOM���״̬,case t2.f_126 when 40019 then '��' else ' 'end as �Ƿ��Ʒ���� from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('v') and t1.fstatus=0
order by t2.f_128,t2.fnumber

select * 
--delete
from icbomgroup where fnumber like '8.%'




--��ѯ��׼��Ʒδ���BOM����
select t3.fname as �з�����,fbomnumber,t2.fnumber,t2.fname,t2.fmodel,case t1.fstatus when 0 then 'δ���' else '���' end as BOM���״̬,case t2.f_126 when 40019 then '��' else ' 'end as �Ƿ��Ʒ���� from icbom t1
inner join t_icitem t2 on t1.fitemid=t2.fitemid
left join t_submessage t3 on t2.f_128=t3.finterid
where left(t2.fnumber,1) in ('a','p','j','x','y') and substring(t2.fnumber,3,2) in ('01')
order by t2.f_128,t2.fnumber