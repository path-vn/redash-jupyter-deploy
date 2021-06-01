# redash-jupyter-deploy

##
- Hệ thống gồm 2 module chính là jupyter-notebook và redash chạy trên nền web
- Jupyter được sử dụng để dọc và load dữ liệu vào database
- Redash được sử dụng để truy vấn và trình diễn dữ liệu 

## Yêu cầu phần cứng

## Yêu cầu phần mềm

- Cài đặt docker: https://docs.docker.com/engine/install/

- Cài đặt docker-compose: https://docs.docker.com/compose/install/

- Sử dụng git clone hoặc giải nén project này vào thư mục triển khai 

## Cấu hình

- Thay đổi cấu hình port cho jupyter trong file docker-compose.yml, service jupyter sang port triển khai, mặc định dùng port 3004
```bash
jupyter:
    image: jupyter/datascience-notebook:ubuntu-18.04
    restart: always
    volumes:
      - ./notebooks:/home/jovyan/work
      - ./jupyter_notebook_config.json:/home/jovyan/.jupyter/jupyter_notebook_config.json
    ports:
      - "3004:8888"
```
- Thay đổi cấu hình port cho redash trong file docker-compose.yml, service nginx sang port triển khai, mặc định dùng port 3003

```
nginx:
    image: redash/nginx:latest
    ports:
      - "3003:80"
    depends_on:
      - server
    links:
      - server:redash
    restart: always
```

- Cấu hình email cho service redash để cấp thêm tài khoản trong file env
```

REDASH_MAIL_SERVER=smtp.gmail.com
REDASH_MAIL_PORT=465
REDASH_MAIL_USE_TLS=false
REDASH_MAIL_USE_SSL=true
REDASH_MAIL_USERNAME=***
REDASH_MAIL_PASSWORD=***
REDASH_MAIL_DEFAULT_SENDER=***
REDASH_HOST=***

```

- Chú ý nếu sử dụng gmail cần bật chế độ ["Turn on less secure apps"](https://support.google.com/a/answer/176600?hl=en#zippy=%2Cuse-the-gmail-smtp-server)

- Để cấu hình password jupyter, chạy command line cd vào thư mục triển khai và chạy lệnh
```bash
  docker-compose  run --rm  jupyter jupyter notebook password
```

- User quản trị redash được cấu hình trong lần truy cập đầu tiên

## Khởi tạo và chạy hệ thống

- Cài đặt admin, và tạo database cho redash, chạy command line, cd vào thư mục triển khai và chạy lệnh:
```bash
  docker-compose run --rm server create_db
```

- Khởi chạy toàn bộ hệ thống, cd vào thư mục triển khai, chạy lệnh 
```bash
  docker-compose  up -d
```

- Kiểm tra hệ thống đã chạy , cd vào thư mục triển khai, chạy lệnh
```bash
  docker-compose  ps
```

Output nếu hệ thống đã chạy bình thường 
```bash
    cucytdp_adhoc_worker_1       /app/bin/docker-entrypoint ...   Up      5000/tcp                     
    cucytdp_db_1                 docker-entrypoint.sh --def ...   Up      3306/tcp, 33060/tcp          
    cucytdp_jupyter_1            tini -g -- start-notebook.sh     Up      0.0.0.0:3004->8888/tcp       
    cucytdp_nginx_1              nginx -g daemon off;             Up      443/tcp, 0.0.0.0:3003->80/tcp
    cucytdp_postgres_1           docker-entrypoint.sh postgres    Up      5432/tcp                     
    cucytdp_redis_1              docker-entrypoint.sh redis ...   Up      6379/tcp                     
    cucytdp_scheduled_worker_1   /app/bin/docker-entrypoint ...   Up      5000/tcp                     
    cucytdp_scheduler_1          /app/bin/docker-entrypoint ...   Up      5000/tcp                     
    cucytdp_server_1             /app/bin/docker-entrypoint ...   Up      0.0.0.0:5000->5000/tcp   
```


- Một số lệnh cần dùng khác
```bash
    # tạm dừng 
    docker-compose stop
    # chạy 
    docker-compose start
    # khởi động lại toàn bộ hệ thống
    docker-compose start
    # Xoá toàn bộ container (Vẫn lưu lại dữ liệu)
    docker-compose down
```
