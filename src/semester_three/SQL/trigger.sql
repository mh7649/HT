/**
�������Ļ������
	һ������Ĵ洢����.
*/
use xinwen;
go
create trigger db_safe
on database
for
	DROP_TABLE,ALTER_TABLE,CREATE_TABLE
as
	print '���ܶ����ݿ���д�������ɾ�������޸ı��Ĳ���';
	rollback transaction;

create table test_1(
	id int primary key
);

drop table t_user;

go
create trigger table_safe
on t_user --ָ������ı�����ͼ������Ƕ���ͼ���Ӵ���������for��д��instead of
for
	delete, update, insert -- ֧�ֶ�������¼�
as
	print '���ܶԱ�����ɾ�������£��������';
	rollback tran;

delete from t_user;

drop trigger table_safe;

go
create trigger insert_user
on t_user
for insert
as
	if (select pwd from inserted) = '123456'
		begin
			print '����̫��';
			rollback tran;
		end;
	else
		print '����ɹ�';

insert into t_user(email, pwd) values('abcdef@qq.com', '123456'); 

go
create trigger delete_user
on t_user
for delete
as 
	if (select email from deleted) like '%@126%' 
		begin
			print '����ɾ��126����ļ�¼';
			rollback tran;
		end;
	else
		print 'ɾ���ɹ�';

drop trigger delete_user;

select * from t_user;
delete from t_user where email = '123@126.com';

go
create trigger update_user
on t_user
for update
as
 if (select email from inserted) like '%@qq.com%'
	begin
		print '�ܾ�QQ���䣡';
		rollback;
	end;
else 
	print '���³ɹ�';

update t_user set email = 'abcd@qq.com' where email = 'test1@qq.com'; 

go
create view view_user
as
	select * from t_user;
go
create trigger view_user_tri
on view_user
instead of update
as
	if (select email from inserted) like '%@qq.com%'
		begin
			print '�ܾ�QQ���䣡';
			rollback;
		end;
	else 
		print '���³ɹ�';

go
create trigger update_user_email
on t_user
for update
as 
	if update(email) -- �ж��Ƿ��ָ�����ֶν����˸���
		begin
			print '���ܸ�������';
			rollback tran;
		end;

update t_user set email = 'abc' where email = 'bcd@126.com';

/**
	�鿴�û���������д������������¼�
*/
select * from sys.triggers;
