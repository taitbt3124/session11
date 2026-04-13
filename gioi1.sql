
create table products (
    product_id serial primary key,
    product_name varchar(100),
    stock int,
    price numeric(10,2)
);

create table orders (
    order_id serial primary key,
    customer_name varchar(100),
    total_amount numeric(10,2),
    created_at timestamp default now()
);

create table order_items (
    order_item_id serial primary key,
    order_id int references orders(order_id),
    product_id int references products(product_id),
    quantity int,
    subtotal numeric(10,2)
);

insert into products (product_name, stock, price)
values 
    ('laptop', 10, 1500.00),
    ('chuột không dây', 5, 20.00);

-- kịch bản 1: giao dịch đặt hàng thành công
begin;

update products set stock = stock - 2 where product_id = 1 and stock >= 2;
update products set stock = stock - 1 where product_id = 2 and stock >= 1;

insert into orders (customer_name, total_amount) 
values ('nguyen van a', 0) returning order_id; 

insert into order_items (order_id, product_id, quantity, subtotal)
values 
    (1, 1, 2, 3000.00),
    (1, 2, 1, 20.00);

update orders set total_amount = 3020.00 where order_id = 1;

commit;

select * from products;
select * from orders;
select * from order_items;

update products set stock = 0 where product_id = 2;

begin;

-- thử đặt hàng khi sản phẩm 2 đã hết hàng
update products set stock = stock - 2 where product_id = 1 and stock >= 2;

-- lệnh này sẽ không ảnh hưởng đến dòng nào (0 rows affected) vì stock = 0
update products set stock = stock - 1 where product_id = 2 and stock >= 1;

-- trong thực tế ứng dụng, nếu kiểm tra thấy 1 trong các lệnh update trả về 0 row 
-- hoặc có lỗi phát sinh, ta sẽ thực hiện rollback
rollback;

-- kiểm tra: tồn kho laptop vẫn là 8 (không bị trừ thêm 2 do đã rollback)
select * from products;
