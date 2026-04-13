create table accounts (
    account_id serial primary key,
    owner_name varchar(100),
    balance numeric(10,2)
);

insert into accounts (owner_name, balance) 
values ('a', 500.00), ('b', 300.00);

-- trường hợp 1: giao dịch chuyển tiền thành công
begin;
update accounts set balance = balance - 100.00 where owner_name = 'a';
update accounts set balance = balance + 100.00 where owner_name = 'b';
commit;

-- kiểm tra số dư sau khi chuyển thành công
select * from accounts;

-- trường hợp 2: mô phỏng lỗi (sai id người nhận) và rollback toàn bộ
begin;
update accounts set balance = balance - 100.00 where owner_name = 'a';
-- giả sử id 999 không tồn tại để gây ra lỗi logic hoặc không tìm thấy dòng
update accounts set balance = balance + 100.00 where account_id = 999;
rollback;

-- kiểm tra lại số dư (vẫn giữ nguyên như sau trường hợp 1)
select * from accounts;

-- trường hợp 3: thử nghiệm lỗi logic (chuyển quá số dư hiện có)
begin;
update accounts set balance = balance - 1000.00 where owner_name = 'a';
update accounts set balance = balance + 1000.00 where owner_name = 'b';
-- quyết định hủy bỏ vì số dư không đủ
rollback;

-- kiểm tra lại số dư (đảm bảo không có thay đổi)
select * from accounts;

-- trường hợp 4: sử dụng savepoint để hủy một phần giao dịch bị lỗi
begin;
update accounts set balance = balance - 50.00 where owner_name = 'a';
savepoint point1;

update accounts set balance = balance + 50.00 where account_id = 888;

rollback to savepoint point1;
update accounts set balance = balance + 50.00 where owner_name = 'b';
commit;

select * from accounts;
