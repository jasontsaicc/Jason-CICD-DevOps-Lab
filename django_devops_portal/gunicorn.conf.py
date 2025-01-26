# gunicorn.conf.py
bind = "0.0.0.0:8058"  # 與 EXPOSE 端口一致
workers = 4
timeout = 120