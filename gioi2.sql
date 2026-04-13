create table accounts (
    account_id serial primary key,
    customer_name varchar(100),
    balance numeric(12,2)
);

create table transactions (
    trans_id serial primary key,
    account_id int references accounts(account_id),
    amount numeric(12,2),
    trans_type varchar(20), -- 'withdraw' hoặc 'deposit'
    created_at timestamp default now()
);

insert into accounts (customer_name, balance) 
values ('nguyen van a', 2000.00);

-- trường hợp 1: giao dịch rút tiền thành công
begin;

-- bước 1: trừ tiền tài khoản (ví dụ rút 500)
update accounts 
set balance = balance - 500.00 
where account_id = 1 and balance >= 500.00;

-- bước 2: ghi log vào bảng transactions
insert into transactions (account_id, amount, trans_type)
values (1, 500.00, 'withdraw');

commit;

-- kiểm tra kết quả
select * from accounts;
select * from transactions;

-- trường hợp 2: mô phỏng lỗi ghi log (sai account_id) và rollback
begin;

-- bước 1: trừ tiền tài khoản (rút thêm 200)
update accounts 
set balance = balance - 200.00 
where account_id = 1 and balance >= 200.00;

-- bước 2: cố ý chèn sai account_id (ví dụ id 999 không tồn tại) để gây lỗi
insert into transactions (account_id, amount, trans_type)
values (999, 200.00, 'withdraw');

-- hệ thống báo lỗi ngoại lệ, thực hiện rollback
rollback;

-- chứng minh: số dư vẫn giữ nguyên là 1500, không bị trừ 200
select * from accounts;
select * from transactions;

-- trường hợp 3: kiểm tra khi số dư không đủ (lỗi logic)
begin;

-- thực hiện update nhưng điều kiện balance >= 5000 không thỏa mãn
update accounts 
set balance = balance - 5000.00 
where account_id = 1 and balance >= 5000.00;

-- kiểm tra nếu không có dòng nào được cập nhật thì rollback
-- trong thực tế lập trình, bước này sẽ kiểm tra 'row count'
rollback;

select * from accounts;
